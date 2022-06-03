clear all, close all

% file = fullfile('/','Users','nickats','Desktop','porcine_spinal_chord_project','pig data processing','pig_1021');
file = 'C:\Users\Denis\Documents\JHSOM\PhD\Data\211021 Pig EP sample\pig 1021';

bexfiles = dir(fullfile(file,'*.bex'));
txtfiles = dir(fullfile(file,'*.txt'));

%classification identifiers
mep = {'LECR', 'RECR', 'LBF', 'RBF', 'LTF', 'RTF'};
Dwave = {'cau', 'ros'};
ssep = {'C3', 'C4', 'Cz', 'Cervical'};
C1_pat = ["C1", "c1"];
C2_pat = ["C2", "c2"];
arms_pat = ["arm", "Arm", "arms","Arms"];
legs_pat = ["leg", "Leg", "legs", "Legs"];

load("Sample Structure.mat")

String_Time = {};
failedsorts = {}; %deposit of data files that weren't able to be sorted by algorithm

%sorting data files into structure
for i = 1:length(bexfiles)
    btemp = bexfiles(i).name;
    ttemp = txtfiles(i).name;
    if isempty(regexp(btemp,'\d\d+','match')) ~= 1
        to_format = char(regexp(btemp,'\d\d+','match'));
        if  any(strcmp(to_format, {s.String_Time})) == 0
            s(end+1).String_Time = to_format;
%             s(end).MEP = s(1).MEP;
%             s(end).D = s(1).D;
%             s(end).SSEP = s(1).SSEP;
            s(end).MEP = [];
            s(end).D = [];
            s(end).SSEP = [];
        end


        fid = fopen(fullfile(file, ttemp));
        meta = textscan(fid,'%s', 'Delimiter','\n');
        fclose(fid);

        check = contains(meta{1},mep);
        if any(check) == 1
            mep_order = {meta{1,1}{1}, meta{1,1}{10},meta{1,1}{19},meta{1,1}{28},...
                meta{1,1}{37}, meta{1,1}{46}};
            mep_sensitivity = {meta{1,1}{3}, meta{1,1}{12}, meta{1,1}{21}, meta{1,1}{30}, ...
                meta{1,1}{39}, meta{1,1}{48}};
            if contains(btemp,C1_pat) == 1
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).MEP)
                                s(i).MEP = s(1).MEP;
                            end

                            place = find(contains(mep_order, 'LECR'));
                            s(i).MEP(1).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(1).C1_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RECR'));
                            s(i).MEP(2).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(2).C1_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'LBF'));
                            s(i).MEP(3).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(3).C1_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RBF'));
                            s(i).MEP(4).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(4).C1_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'LTF'));
                            s(i).MEP(5).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(5).C1_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RTF'));
                            s(i).MEP(6).C1 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(6).C1_sensitivity = sensitivity{1};

                           
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            else
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).MEP)
                                s(i).MEP = s(1).MEP;
                            end

                            place = find(contains(mep_order, 'LECR'));
                            s(i).MEP(1).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(1).C2_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RECR'));
                            s(i).MEP(2).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(2).C2_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'LBF'));
                            s(i).MEP(3).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(3).C2_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RBF'));
                            s(i).MEP(4).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(4).C2_sensitivity = sensitivity{1};    

                            place = find(contains(mep_order, 'LTF'));
                            s(i).MEP(5).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(5).C2_sensitivity = sensitivity{1};

                            place = find(contains(mep_order, 'RTF'));
                            s(i).MEP(6).C2 = data(:,place);
                            sensitivity = regexp(mep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).MEP(6).C2_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            end
        end
        check = contains(meta{1}, Dwave);
        if any(check) == 1
            d_order = {meta{1,1}{1}, meta{1,1}{10}};
            d_sensitivity = {meta{1,1}{3}, meta{1,1}{12}};
            if contains(btemp,C1_pat) == 1
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).D)
                                s(i).D = s(1).D;
                            end

                            place = find(contains(d_order, 'ros'));
                            s(i).D(1).C1 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(1).C1_sensitivity = sensitivity{1};

                            place = find(contains(d_order, 'cau'));
                            s(i).D(2).C1 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(2).C1_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            else
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).D)
                                s(i).D = s(1).D;
                            end

                            place = find(contains(d_order, 'ros'));
                            s(i).D(1).C2 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(1).C2_sensitivity = sensitivity{1};

                            place = find(contains(d_order, 'cau'));
                            s(i).D(2).C2 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(2).C2_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            end
        end

        check = contains(meta{1}, ssep);
        if any(check) == 1
            ssep_order = {meta{1,1}{1}, meta{1,1}{10}, meta{1,1}{19}, meta{1,1}{28}, ...
                meta{1,1}{37}, meta{1,1}{46}, meta{1,1}{55}, meta{1,1}{64}};
            ssep_sensitivity = {meta{1,1}{3}, meta{1,1}{12}, meta{1,1}{21}, meta{1,1}{30}, ...
                meta{1,1}{39}, meta{1,1}{48}, meta{1,1}{57}, meta{1,1}{66}};
            if contains(btemp,arms_pat) == 1
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).SSEP)
                                s(i).SSEP = s(1).SSEP;
                            end

                            place = find(contains(ssep_order, "C4 - C3'"));
                            s(i).SSEP(1).Arms = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(1).Arms_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, 'C4') & ~contains(ssep_order, "C4 - C3'") & ~contains(ssep_order, "C3' - C4"));
                            s(i).SSEP(2).Arms = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(2).Arms_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, 'Cz'));
                            s(i).SSEP(3).Arms = data(:,place(1));
                            sensitivity = regexp(ssep_sensitivity{place(1)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(3).Arms_sensitivity = sensitivity{1};
                            s(i).SSEP(7).Arms = data(:,place(2));
                            sensitivity = regexp(ssep_sensitivity{place(2)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(7).Arms_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, 'Cervical'));                       
                            s(i).SSEP(4).Arms = data(:,place(1));
                            sensitivity = regexp(ssep_sensitivity{place(1)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(4).Arms_sensitivity = sensitivity{1};
                            s(i).SSEP(8).Arms = data(:,place(2));
                            sensitivity = regexp(ssep_sensitivity{place(2)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(8).Arms_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, "C3' - C4"));
                            s(i).SSEP(5).Arms = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(5).Arms_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, "C3'") & ~contains(ssep_order, "C4 - C3'") & ~contains(ssep_order, "C3' - C4"));
                            s(i).SSEP(6).Arms = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(6).Arms_sensitivity = sensitivity{1};
                         break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            else
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).SSEP)
                                s(i).SSEP = s(1).SSEP;
                            end

                            place = find(contains(ssep_order, "C4 - C3'"));
                            s(i).SSEP(1).Legs = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(1).Legs_sensitivity = sensitivity{1};

                            place = find(contains(ssep_order, 'Cz') & ~contains(ssep_order, 'Cz - C4') & ~contains(ssep_order, "Cz - C3'"));
                            s(i).SSEP(3).Legs = data(:,place(1));
                            sensitivity = regexp(ssep_sensitivity{place(1)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(3).Legs_sensitivity = sensitivity{1};
                            s(i).SSEP(7).Legs = data(:,place(2));
                            sensitivity = regexp(ssep_sensitivity{place(2)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(7).Legs_sensitivity = sensitivity{1};
                            
                            place = find(contains(ssep_order, 'Cervical'));
                            s(i).SSEP(4).Legs = data(:,place(1));
                            sensitivity = regexp(ssep_sensitivity{place(2)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(4).Legs_sensitivity = sensitivity{1};
                            s(i).SSEP(8).Legs = data(:,place(2));
                            sensitivity = regexp(ssep_sensitivity{place(2)}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(8).Legs_sensitivity = sensitivity{1};
                            
                            place = find(contains(ssep_order, "C3' - C4"));
                            s(i).SSEP(5).Legs = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(5).Legs_sensitivity = sensitivity{1};
                            
                            place = find(contains(ssep_order, 'Cz - C4'));
                            s(i).SSEP(2).Legs = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(2).Legs_sensitivity = sensitivity{1};
                            
                            place = find(contains(ssep_order, 'Cz - C3'));
                            s(i).SSEP(6).Legs = data(:,place);
                            sensitivity = regexp(ssep_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).SSEP(6).Legs_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            end
        end

    else
        failedsorts{end+1} = btemp;
    end
end
s(1) = []; s(1) = [];
T = struct2table(s);
s = table2struct(natsortrows(T, [],{'String_Time'}));

if length(s(1).String_Time) == 3
    base = insertBefore(s(1).String_Time, 1 , '0');
end
base = insertAfter(s(1).String_Time,length(s(1).String_Time)-2,':');

%fill in Time field

for i = 1:length(s)
    if length(s(i).String_Time) == 3
        to_format = insertBefore(s(i).String_Time, 1 , '0');
    else
        to_format = s(i).String_Time;
    end
    formatted = insertAfter(to_format,length(to_format)-2,':');
    s(i).Time = seconds(duration(formatted, 'InputFormat', 'hh:mm')) - ...
        seconds(duration(base, 'InputFormat', 'hh:mm'));
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

