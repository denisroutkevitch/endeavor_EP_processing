clear all, close all


% file = "D:\Data\230720 Pig EP";
% file = 'C:\Users\Denis\Documents\JHSOM\PhD\Data\211021 Pig EP sample\pig 1021';
file = "C:\Users\Denis\OneDrive - Johns Hopkins\NT Research 2023\HEPIUS\Pig\Experiments\2023\2023_10_27 Pig FUS experiments\EP\231026_143103\10262023\";

bexfiles = dir(fullfile(file,'*.bex'));

txtfiles = dir(fullfile(file,'*.txt'));

%classification identifiers
mep = {'LECR', 'RECR', 'LBF', 'RBF', 'LTF', 'RTF'};
Dwave = {'cau', 'ros', 'Cau', 'Ros'};
ssep = {'C3', 'C4', 'Cz', 'Cervical'};
C1_pat = ["C1", "c1"];
C2_pat = ["C2", "c2"];
arms_pat = ["arm", "Arm", "arms", "Arms", "median", "Median"];
legs_pat = ["leg", "Leg", "legs", "Legs", "tibial", "Tibial"];

load("C:\Users\abche\Desktop\endeavor_EP_processing-main\Sample Structure.mat")

String_Time = {};
failedsorts = {}; %deposit of data files that weren't able to be sorted by algorithm

%sorting data files into structure
for i = 1:min(length(bexfiles),length(txtfiles))
    btemp = bexfiles(i).name;
    ttemp = txtfiles(i).name;
    
    if isempty(regexp(btemp,'\d\d+','match')) ~= 1
        if contains(btemp, '-2')
            to_format = [char(regexp(btemp,'\d\d+','match')), '-2'];
        else
            to_format = char(regexp(btemp,'\d\d+','match'));
        end

        if any(strcmp(to_format, {s.String_Time})) == 0
            s(end+1).String_Time = to_format;
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
            elseif contains(btemp,C2_pat) == 1
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
            else
                failedsorts{end+1} = btemp;
            end
        end
        check = contains(meta{1}, Dwave);
        if any(check) == 1
            d_order = {meta{1,1}{1}, meta{1,1}{10}};
            d_sensitivity = {meta{1,1}{3}, meta{1,1}{12}};
            if contains(btemp,C1_pat) == 1 || contains(btemp, 'D wave')
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).D)
                                s(i).D = s(1).D;
                            end

                            place = find(contains(d_order, 'ros', 'IgnoreCase',true));
                            s(i).D(1).C1 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(1).C1_sensitivity = sensitivity{1};

                            place = find(contains(d_order, 'cau', 'IgnoreCase',true));
                            s(i).D(2).C1 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(2).C1_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            elseif contains(btemp,C2_pat) == 1
                for i = 3:length(s)
                    if contains(btemp, s(i).String_Time)
                        try
                            data = data_grabbing(fullfile(file, btemp));

                            if isempty(s(i).D)
                                s(i).D = s(1).D;
                            end

                            place = find(contains(d_order, 'ros', 'IgnoreCase',true));
                            s(i).D(1).C2 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(1).C2_sensitivity = sensitivity{1};

                            place = find(contains(d_order, 'cau', 'IgnoreCase',true));
                            s(i).D(2).C2 = data(:,place);
                            sensitivity = regexp(d_sensitivity{place}, 'Sensitivity:(\d+\s*\D+)','tokens');
                            s(i).D(2).C2_sensitivity = sensitivity{1};
                            break

                        catch
                            failedsorts{end+1} = btemp;
                        end
                    end
                end
            else
                failedsorts{end+1} = btemp;
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
            elseif contains(btemp,legs_pat) == 1
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
            else
                failedsorts{end+1} = btemp;
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

%% fill in Time field

for i = 1:length(s)
    if length(s(i).String_Time) == 3
        to_format = insertBefore(s(i).String_Time, 1 , '0');
    else
        to_format = s(i).String_Time;
    end

    if length(to_format) == 4
        formatted = [insertAfter(to_format,length(to_format)-2,':'), ' 20231026'];
        s(i).Time = datetime(formatted, 'InputFormat', 'HH:mm yyyyMMdd');
%         - seconds(duration(base, 'InputFormat', 'hh:mm'));
    else
        formatted = [insertAfter(to_format(1:4),2,':'), ':30 20231026'];
        s(i).Time = datetime(formatted, 'InputFormat', 'HH:mm:ss yyyyMMdd');
%         - seconds(duration(base, 'InputFormat', 'hh:mm'));
    end
end

%% MEPs stacking

mpd = 30;
mpp = 0.0005;
dscale = 0.3;

trange = [65 80];
windloc = [55 90];
tickloc = 70;

EP_type = 'D';
stim_site = 'C1';
rec_loc = 1;

% analysrange = [65 72];
analysrange = [59 65];

% trange = [65 80];
% windloc = [55 90];
% tickloc = 57;
% 
% EP_type = 'MEP';
% stim_site = 'C2';
% rec_loc = 5;



% close all
try close(figure(1))
end

figure(1)
set(figure(1), 'Position', [32,58,511,868])
hold on
traces = [];
taxis = datetime([],[],[]);
times = {};


for i = 1:length(s)
    EP_struct = s(i).(EP_type);
    if (isempty(EP_struct) == 0) && isempty(EP_struct(rec_loc).(stim_site)) == 0
        try
            traces(:,end+1) = EP_struct(rec_loc).(stim_site);
        catch
            traces(:,end+1) = [EP_struct(rec_loc).(stim_site);0];
        end

        times{end+1} = s(i).String_Time;
        taxis(end+1) = s(i).Time;
        fieldn = fieldnames(EP_struct);
        rec_loc_string = EP_struct(rec_loc).(fieldn{1});
    end
end


for i = 1:length(times)
    if length(times{i}) == 3
        to_format = insertBefore(times{i}, 1 , '0');
    else
        to_format = times{i};
    end
    formatted = insertAfter(to_format,length(to_format)-2,':');
    times{i} = datestr(duration(formatted, 'InputFormat', 'hh:mm'), 'HH:MM');
end


t = 0:100/max(size(traces,1)): 99.99;


[~,ind1] = min(abs(t-trange(1)));
[~,ind2] = min(abs(t-trange(2)));


[~,aind1] = min(abs(t-analysrange(1)));
[~,aind2] = min(abs(t-analysrange(2)));


[~,windind] = min(abs(t-tickloc));

% dist =  max(traces(963:1200,:), [], 'all') - min(traces(963:1200,:), [], 'all');
dist =  max(traces(ind1:ind2,:), [], 'all') - min(traces(ind1:ind2,:), [], 'all');
for i = 1: size(traces,2) - 1
    
    traces(:,i+1) = traces(:,i+1) - i*(dscale*dist);
end



plot(t, traces, 'Color', 'Black', 'LineWidth', 1.7)
xlabel('Time (ms)','FontWeight', 'bold')
ylabel('Time of measurement','FontWeight','bold')

ylim([min(traces(aind1:aind2,:),[],'all')-dscale*dist, max(traces(aind1:aind2,:),[],'all')+3]+dscale*dist)
xlim(windloc)
title(sprintf('%s %s %s', EP_type, stim_site, rec_loc_string))
yticks(flip(traces(windind,:)))
yticklabels(flip(times))
set(gca,'FontSize', 13);
%title({'MEP signal traces measured from the', 'left extensor carpi radialis (LECR)'})
% title({'SSEP signal traces measured from the Legs', 'Cervical'})

% set(gcf,'Position',[0 0 300 300])


hold off 

%% SSEP Conversion


%%%1-801 for first trace and 803-1603 for second

% Loop between all traces and does first minus the second 

traces_ssep = [];
select = [6,40,114, 118,119,129,157];
for i = 1:size(traces,2)
    traces_ssep(:,end+1) = traces((1:801), i) - traces((803:1603), i);

    %plot(traces);
    %plot(traces(1:inds(MI)));

    %plot(t(inds(MI)), M, '*r');
    %plot(t(inds(MI)), M, 'r*');
    %[mpks, inds] = findpeaks(-traces(1: end,i),'MinPeakDistance', 10);
    %[m, mi] = max(mpks);
    %plot(t(inds(mi)), -m, 'r*')

end

% for i = 1: size(traces_ssep,2) - 1
    % syms x
    % eqn = min(traces_ssep(:,i)) - max(traces_ssep(:,i+1)) + 1 + x == 0;
    % solx = solve(eqn, x);
    %dist = min(traces_ssep(:,i)) - max(traces(:,i+1));
    % traces_ssep(:,i+1) = traces_ssep(:,i+1) - solx;
% end
select_traces_ssep = [];
select_times = {};
for i= 1:length(select)
    select_traces_ssep(:,end+1) = traces_ssep(:,select(i));
    select_times(end+1) =  times(select(i));
end

select_traces_ssep = fliplr(select_traces_ssep);
select_times = fliplr(select_times);
for i = 1: size(select_traces_ssep,2)-1
    syms x
    eqn = min(select_traces_ssep(350:end,i+1)) - max(select_traces_ssep(350:end,i)) -2 + x == 0;
    solx = solve(eqn, x);
    select_traces_ssep(:,i+1) = select_traces_ssep(:,i+1) + solx;
end

figure(1);
set(gca, 'LineWidth',1.5);
set(gca, 'FontWeight', 'bold');
hold on
t = 0:100/max(size(select_traces_ssep,1)): 99.99;
plot(t, select_traces_ssep, 'Color', 'Black', 'LineWidth', 1.7);
xlabel('Time (ms)','FontWeight', 'bold')
ylabel('Time of measurement','FontWeight','bold')
ylim([min(min(select_traces_ssep)), max(max(select_traces_ssep))])
xlim([3, 50])
yticks((select_traces_ssep(25,:)))
yticklabels((select_times))
set(gca,'FontSize', 13);
title({'SSEP Cervical Legs'})
set(gcf,'Position',[0 0 300 300])

% hold off

dist = [];

%select correct data for analysis
% hold on
post_stim = 20;
for i = 1:size(traces_ssep,2)
% for i = 1:size(select_traces_ssep,2)
    [mpks, inds] = findpeaks(-traces_ssep(post_stim : 350,i),'MinPeakDistance', 10);
    % [mpks, inds] = findpeaks(-select_traces_ssep(post_stim : 350,i),'MinPeakDistance', 10);

    
    [m, mi] = max(mpks);
    index_min = post_stim+inds(mi);
    % plot(t(index_min), -m, 'r*')

    [Mpks, inds] = findpeaks(traces_ssep(index_min : 390,i),'MinPeakDistance', 10);
    % [Mpks, inds] = findpeaks(select_traces_ssep(index_min : 390,i),'MinPeakDistance', 10);
    [M, MI] = max(Mpks);
    % plot(t(index_min + inds(MI)), M, 'r*')

    if(isempty(M))
        M = traces_ssep(390,i);
        % M = select_traces_ssep(390,i);
    end

    dist(i) = M + m;
end

hold off

ticks = [];
minute_time = [];
%Convert time to minutes
for i = 1:size(times,2)
    cell = times(1,i);
    str_temp = string(cell);
    str_temp1= erase(str_temp,":");
    num_temp = str2num(str_temp1);

    r = rem(num_temp,10);
    mintues = r;
    num_temp = num_temp-r;
    r = rem(num_temp,100);
    mintues = mintues +r;
    num_temp = (num_temp-r)/100;
    minutes = mintues+ num_temp*60;

    % Time of first recording
    minutes = minutes - 780;

    minute_time(end+1) = minutes;
    
end

time_labels={};
for i = 1:size(times,2)
    if (rem(i,20)==1)
        time_labels(end+1) = times(1,i);
        ticks(end+1) = i;
    end
end

% Plot in minutes for x and amplitude in Y
figure(2);
set(gca, 'LineWidth',1.5);
set(gca, 'FontWeight', 'bold');
hold on
t = 0:100/max(size(dist,1)): 99.99;
plot(dist, 'Color', 'Black', 'LineWidth', 1.7);
xlabel('Time (minutes)','FontWeight', 'bold')
ylabel('Amplitude','FontWeight','bold')
ylim([min(min(dist))-1, max(max(dist))+1])
xlim([1, 160])
xticks(ticks)
xticklabels(time_labels)
set(gca,'FontSize', 13);
title({'SSEP Cervical Legs Amplitude'})
set(gcf,'Position',[0 0 300 300])


% min/max analysis

dist = [];
figure(1)

%select correct data for analysis
hold on

for i = 1:size(traces,2)

    [Mpks, inds] = findpeaks(traces(aind1 : aind2,i),'MinPeakDistance', mpd, 'MinPeakProminence',mpp);
    [M, MI] = max(Mpks);
    plot(t(aind1+inds(MI)), M, 'r*')
    [mpks, inds] = findpeaks(-traces(aind1 : aind2,i),'MinPeakDistance', mpd, 'MinPeakProminence',mpp);

    [m, mi] = max(mpks);
    if i ==1
        m = -traces(580,1);
        inds(mi)= 580-aind1;
    end
    plot(t(aind1+inds(mi)), -m, 'r*')
    dist(i,2) = M + m;
end
hold off

dist = (dist-min(dist)) ./ (max(dist)-min(dist));

figure(2)
set(figure(2), 'Position', [200 200 750, 185])
plot(taxis, dist,'LineWidth', 1.5);
xline(fus_on,'-','FUS On','LineWidth', 1.5)
xline(fus_off,'-','FUS Off','LineWidth', 1.5)
kl = xline(ket_on,'-','KETAMINE','LineWidth', 1.5);
kl.LabelVerticalAlignment = 'bottom';

set(gca, 'LineWidth', 1.5)
set(gca,'FontWeight','bold')
title(sprintf('%s %s %s', EP_type, stim_site, rec_loc_string))

ylim([-0.1 1.1])
ylabel({'Normalized Voltage', '(Max-Min)'})

exportgraphics(figure(1), fullfile("C:\Users\Denis\OneDrive - Johns Hopkins\NT Research 2023\HEPIUS\Pig\Experiments\2023\2023_10_27 Pig FUS experiments",...
                        sprintf('%s %s %s traces.png', EP_type, stim_site, rec_loc_string)));

exportgraphics(figure(2), fullfile("C:\Users\Denis\OneDrive - Johns Hopkins\NT Research 2023\HEPIUS\Pig\Experiments\2023\2023_10_27 Pig FUS experiments",...
                        sprintf('%s %s %s mag.png', EP_type, stim_site, rec_loc_string)));


%%
figure(2)
dist = (dist-min(dist)) ./ (max(dist)-min(dist));
cats = categorical(times);

b = bar(cats,dist,'FaceColor', 'flat');

ylabel('Normalized Max - Min voltage (mV)', 'FontWeight', 'bold')
xlabel('Time of measurement','FontWeight','bold')
ylim([0 1.1])
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = String(b.YData);
%labels = string(round((b.YData), 2));
text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
xticklabels(times)
set(gca,'FontSize', 13)
title({'Maximum peak-to-trough amplitudes', 'Measured at left extensor carpi radialis (LECR)'})


%% preliminary analysis

trace = s(10).MEP(6).C1;
t = 0:100/length(trace): 99.99;
ntrace = -1 + 2.*(trace - min(trace)) ./ (max(trace) - min(trace));

%filter normalized traces

%[y,z] = butter(5, .125);
Fs = length(ntrace)/.1;
d = designfilt('bandstopiir','FilterOrder',20, ...
               'HalfPowerFrequency1',50,'HalfPowerFrequency2',70, ...
               'DesignMethod','butter','SampleRate',Fs);
% ntrace = filtfilt(d,ntrace);
% ntrace = filtfilt(d,ntrace);

figure(1)
plot(t,ntrace), xlabel = 'Time (ms)';
m = min(ntrace);
M = max(ntrace);
% diffs  = abs(diff(ntrace)); 
% [~,locs]= findpeaks(diffs, 'MinPeakHeight', .3);
% findpeaks(diffs, 'MinPeakHeight', .3); hold off;
% response = ntrace(locs(end)+4 : end);
%figure(2)
%plot(t(locs(end)+4 : end),response), xlabel = 'Time (ms)';

figure(3)
a = fft(ntrace);
f = Fs*(0:(length(ntrace)/2))/length(ntrace);
plot(f,abs(a(1:ceil(length(a)/2))));
idx = find(a == min(abs(a-60)));
a(1:2)=0;
ntrace = ifft(a);

figure(4);
plot(t,ntrace);





