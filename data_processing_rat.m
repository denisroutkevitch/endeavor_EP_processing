clear all, close all

%  file = fullfile('/','Users','nickats','Desktop','porcine_spinal_chord_project','pig data processing','pig 011322');
% fpath = 'E:\Data\220805 Arjun EP Round 3';
fpath = "D:\Data\230712 Angelica MEPs\Binary Files";

% EPstruct = dir(fullfile(fpath,'Raw','*.bex'));
EPstruct = dir(fullfile(fpath,'*.bex'));
% txtfiles = dir(fullfile(fpath,'*.txt'));


timestamps = datetime({EPstruct.date})';
% datetime(timestamps{1})
rectime = hour(timestamps)*3600 + minute(timestamps)*60 + second(timestamps);
rectime = rectime-min(rectime);

[B, I] = sort(rectime);
EPstruct = EPstruct(I);

EPstruct = rmfield(EPstruct, "bytes");
EPstruct = rmfield(EPstruct, "isdir");
EPstruct = rmfield(EPstruct, "datenum");
C = num2cell(sort(rectime));
[EPstruct.time] = C{:};


for ii = 1:length(EPstruct)

    data = data_grabbing(fullfile(EPstruct(ii).folder, EPstruct(ii).name));
    data = [data; zeros(803-size(data,1),2)];
    EPstruct(ii).UL_MEP = data(:,1);
    EPstruct(ii).LL_MEP = data(:,2);
end

save(fullfile(fpath, 'EP_sorted.mat'), 'EPstruct');


%% MEPs stacking

close(figure(1))
set(figure(1), 'Position', [1,49,1280,899]);
hold on
% setappdata(gcf, 'SubplotDefaultAxesLocation', [0, 0, 1, 1]);
getappdata(gcf, 'SubplotDefaultAxesLocation')
tracesUL = [];
tracesLL = [];
times = {};

s = EPstruct;

for i = 2:length(s) %ceil(length(s)/2):length(s)
    
        tracesUL(:,end+1) = s(i).UL_MEP;
        tracesLL(:,end+1) = -s(i).LL_MEP;
        times{end+1} = s(i).name;
end

% for i = 1:length(times)
%     if length(times{i}) == 3
%         to_format = insertBefore(times{i}, 1 , '0');
%     else
%         to_format = times{i};
%     end
%     formatted = insertAfter(to_format,length(to_format)-2,':');
%     times{i} = datestr(duration(formatted, 'InputFormat', 'hh:mm'), 'HH:MM');
% end

ratio = max(tracesUL(550:end))/max(tracesLL(550:end));

for i = 1: size(tracesUL,2) - 1
    dist = min(tracesUL(550:end,i)) - max(tracesUL(550:end,i+1));
    tracesUL(:,i+1) = tracesUL(:,i+1) + dist - 5;
    tracesLL(:,i+1) = ratio*tracesLL(:,i+1) + dist - 5;
end

% for i = 1: size(tracesLL,2) - 1
%     dist = min(tracesLL(:,i)) - max(tracesLL(:,i+1));
%     tracesLL(:,i+1) = tracesLL(:,i+1) + dist - 50;
% end

t = 0:100/max(size(tracesLL,1)): 99.99;
subplot(1,2,1), plot(t, tracesUL, 'Color', 'Black', 'LineWidth', 1.7);
xlabel('Time (ms)','FontWeight', 'bold')
ylabel('Time of measurement (file name, seconds)','FontWeight','bold')
ylim([min(min(tracesUL))-5, max(max(tracesUL))+5])
xlim([40, 90])
yticks(flip(tracesUL(1,:)));
yticklabels(flip(times))
set(gca,'FontSize', 13);
title({'UL MEPs'})

subplot(1,2,2), plot(t, tracesLL, 'Color', 'Black', 'LineWidth', 1.7)
xlabel('Time (ms)','FontWeight', 'bold')
ylim([min(min(tracesUL))-5, max(max(tracesUL))+5])
xlim([40, 90])
set(gca,'YTickLabel',[]);
yticks(flip(tracesLL(1,:)));
yticklabels(flip(times));
set(gca,'FontSize', 13);
title({'LL MEPs'})

% set(gcf,'Position',[2211,75,1051,1154])
hold off 


%% min/max analysis


post_stim = floor(max(size(tracesLL,1)) * .6);
dist = [];
figure(1)
%select correct data for analysis
subplot(1,2,1)
hold on

for i = 1:size(tracesUL,2)
    [Mpks, inds] = findpeaks(tracesUL(post_stim : end,i),'MinPeakDistance', 50);
    [M, MI] = max(Mpks);
    plot(t(post_stim+inds(MI)), M, 'r*')
    [mpks, inds] = findpeaks(-tracesUL(post_stim : end,i),'MinPeakDistance', 50);
    [m, mi] = max(mpks);
    plot(t(post_stim+inds(mi)), -m, 'r*')
    dist(i,1) = M + m;
end
hold off

subplot(1,2,2)
hold on

for i = 1:size(tracesLL,2)
    [Mpks, inds] = findpeaks(tracesLL(post_stim : end,i),'MinPeakDistance', 50);
    [M, MI] = max(Mpks);
    plot(t(post_stim+inds(MI)), M, 'r*')
    [mpks, inds] = findpeaks(-tracesLL(post_stim : end,i),'MinPeakDistance', 50);
    [m, mi] = max(mpks);
    plot(t(post_stim+inds(mi)), -m, 'r*')
    dist(i,2) = M + m;
end
hold off


%%
figure(2)
set(gcf,'Position',[2211,75,1051,1154])

subplot(1,2,1)

plotdist = flip(dist(:,1));
plotdist = (plotdist-min(plotdist)) ./ (max(plotdist)-min(plotdist));

b = barh(plotdist,'FaceColor', 'flat');

xlabel('Normalized Max - Min voltage (mV)', 'FontWeight', 'bold')
ylabel('Time of measurement','FontWeight','bold')
xlim([0 1.15])
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(round(b.YData, 2));
text(ytips+0.05,xtips,labels,'HorizontalAlignment','left','VerticalAlignment','middle')
yticks(1:length(times))
yticklabels(flip(times))
set(gca,'FontSize', 13)
title({'UL MEP Norm. Amplitudes'})

subplot(1,2,2)

plotdist = flip(dist(:,2));
plotdist = (plotdist-min(plotdist)) ./ (max(plotdist)-min(plotdist));

b = barh(plotdist,'FaceColor', 'flat');

xlabel('Normalized Max - Min voltage (mV)', 'FontWeight', 'bold')
xlim([0 1.15])
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(round(b.YData, 2));
text(ytips+0.05, xtips,labels,'HorizontalAlignment','left','VerticalAlignment','middle')
set(gca,'YTickLabel',[]);
yticks(1:length(times))
% yticklabels(times)
yticklabels(flip(times))
set(gca,'FontSize', 13)
title({'LL MEP Norm. Amplitudes'})


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





