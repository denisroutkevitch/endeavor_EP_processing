clear all, close all

file = fullfile('/','Users','nickats','Desktop','porcine_spinal_chord_project','pig data processing','pig_1021');
bexfiles = dir(fullfile(file,'*.bex'));
txtfiles = dir(fullfile(file,'*.txt'));

%{
C1 = cell(length(bexfiles),1);
C2 = cell(length(bexfiles),1);
D_wave_C1 = cell(length(bexfiles),1);
D_wave_C2 = cell(length(bexfiles),1);
arms = cell(length(bexfiles),1);
legs = cell(length(bexfiles),1);

C1_pat = ["C1", "c1"];
C2_pat = ["C2", "c2"];
D_pat = ["D wave", "D Wave"];
arms_pat = ["arm", "Arm", "arms","Arms"];
legs_pat = ["leg", "Leg", "legs", "Legs"];

i=1;
while i <= length(bexfiles)
    if contains(bexfiles(i).name,D_pat) == 1
        if  contains(bexfiles(i).name,C1_pat) == 1
            D_wave_C1{i} = bexfiles(i).name;
            bexfiles(i).name = [];
            i = i+1;
        else
            D_wave_C2{i} = bexfiles(i).name;
            bexfiles(i).name = [];
            i = i+1;
        end
    elseif contains(bexfiles(i).name, C1_pat) == 1
        C1{i} = bexfiles(i).name;
        bexfiles(i).name = [];
        i = i+1;
    elseif contains(bexfiles(i).name, C2_pat) == 1
        C2{i} = bexfiles(i).name;
        bexfiles(i).name = [];
        i = i+1;
    elseif contains(bexfiles(i).name, arms_pat) == 1
        arms{i} = bexfiles(i).name;
        bexfiles(i).name = [];
        i = i+1;
    elseif contains(bexfiles(i).name, legs_pat) == 1
        legs{i} = bexfiles(i).name;
        bexfiles(i).name = [];
        i = i+1;
    end
end
C1 = C1(~cellfun('isempty',C1));
C2 = C2(~cellfun('isempty',C2));
D_wave_C1 = D_wave_C1(~cellfun('isempty',D_wave_C1));
D_wave_C2 = D_wave_C2(~cellfun('isempty',D_wave_C2));
arms = arms(~cellfun('isempty',arms));
legs = legs(~cellfun('isempty',legs));
%}
mep = {'LECR', 'RECR', 'LBF', 'RBF', 'LTF', 'RTF'};
Dwave = {'cau', 'ros'};
ssep = {'C3', 'C4', 'Cz', 'Cervical'};
C1_pat = ["C1", "c1"];
C2_pat = ["C2", "c2"];
arms_pat = ["arm", "Arm", "arms","Arms"];
legs_pat = ["leg", "Leg", "legs", "Legs"];

load("Sample Structure.mat")

String_Time = {};
failedsorts = [];

for i = 1:length(bexfiles)
    btemp = bexfiles(i).name;
    ttemp = txtfiles(i).name;
    if isempty(regexp(btemp,'\d\d+','match')) ~= 1
        to_format = char(regexp(btemp,'\d\d+','match'));
        if length(to_format) == 3
            to_format = insertBefore(to_format, 1 , '0');
        end
        formatted = insertAfter(to_format,length(to_format)-2,':');
        s_as_cell = struct2cell(s);
        check_against = vertcat(s_as_cell{1,:});
            
   
        s(i).String_Time = to_format;
           % s(i).String_Time = to_format;

            %s(i).Time = seconds(duration(s(i).String_Time, 'InputFormat', 'hh:mm')) - ...
                %seconds(duration(s(1).String_Time, 'InputFormat', 'hh:mm'));

      

    else
        failedsorts = [failedsorts; btemp];
    end
end




%{

%categorize data into MEP, D-wave, SSEP
holdmep = cell(length(txtfiles),1);
holdD = cell(length(txtfiles),1);
holdssep = cell(length(txtfiles),1);

for i = 1:length(txtfiles)
    fid = fopen(fullfile(file,txtfiles(i).name));
    meta = textscan(fid,'%s');
    check = contains(meta{1},mep);
    if any(check) == 1
        holdmep{i} = bexfiles(i).name;
    end
    check = contains(meta{1}, Dwave);
    if any(check) == 1
        holdD{i} = bexfiles(i).name;
    end
    check = contains(meta{1}, ssep);
    if any(check) == 1
        holdssep{i} = bexfiles(i).name;
    end
end

holdmep = holdmep(~cellfun('isempty',holdmep));
holdD = holdD(~cellfun('isempty',holdD));
holdssep = holdssep(~cellfun('isempty',holdssep));

%populate main sorting structure with unique timestamps 
%populate array of data that failed to sort based on filename
String_Time = {};
failedsorts = [];
for i = 1:length(bexfiles)
    if isempty(regexp(bexfiles(i).name,'\d\d+','match')) ~= 1
        String_Time{end+1} = char(regexp(bexfiles(i).name,'\d\d+','match'));
    else
        failedsorts = [failedsorts; bexfiles(i).name];
    end
end
[~, idx] = unique(str2double(String_Time));
String_Time = String_Time(idx).';

for i = 1:length(String_Time)
    s(i).String_Time = insertAfter(String_Time{i},length(String_Time{i})-2,':');
    s(i).Time = seconds(duration(s(i).String_Time, 'InputFormat', 'hh:mm')) - ...
        seconds(duration(s(1).String_Time, 'InputFormat', 'hh:mm'));
end

% sort each trace according to filename, electrode
for i = 1:length(holdmep)
    if ismember(holdmep, failedsorts) ~= 1
         if  contains(holdmep{i},C1_pat) == 1
            D_wave_C1{i} = bexfiles(i).name;
            bexfiles(i).name = [];
            i = i+1;
        else
            D_wave_C2{i} = bexfiles(i).name;
            bexfiles(i).name = [];
            i = i+1;
        end
    end
    
end

%}


%%

%write function for this 
L = length(s.left_Cervical);   %samples            
Fs = 1;     %samples/ms
f = ((0:L-1) * Fs/L)'; %samples/ms/samples


X = fftshift(fft(s.left_Cervical));
X_norm = X/L;

figure(2)
subplot(1,2,1)
plot(f,abs(X_norm),'o'), xlabel('frequency'), ylabel('amplitude')
yline(.75.*max(abs(X_norm))); 
subplot(1,2,2)
plot(f,angle(X_norm),'o'), xlabel('frequency'), ylabel('phase angle')

X_recon = X;
keep = 0;
for i = 1:length(f)/2
    if abs(X_norm) > .75.*max(abs(X_norm))
       keep = keep+1;
    end
end

