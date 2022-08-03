% MEPs stacking

close all
hold on
traces = [];
times = {};

var = s113;
for i = 1:length(var)
    if (isempty(var(i).D) == 0) && (isempty(var(i).D(2).C2) == 0)
        traces(:,end+1) = var(i).D(2).C;
        times{end+1} = var(i).String_Time;
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

for i = 1: size(traces,2) - 1
    dist = min(traces(:,i)) - max(traces(:,i+1));
    traces(:,i+1) = traces(:,i+1) + dist - 50;
end


t = 0:100/max(size(traces,1)):99.99;
plot(t, traces, 'Color', 'Black', 'LineWidth', 1.7)
xlabel('Time (ms)','FontWeight', 'bold')
ylabel('Time of measurement','FontWeight','bold')
ylim([min(min(traces))-100, max(max(traces))+100])
xlim([40, 90])
yticks(flip(traces(1,:)))
yticklabels(flip(times))
set(gca,'FontSize', 13);
title('Caudal D-wave signal traces')
set(gcf,'Position',[0 0 400 400])

hold off 


%% panel plots
close all

h1 = openfig('produced plots/1:13/1:13 C2 LECR.fig', 'reuse', 'invisible');
fig1 = gca;
h2 = openfig('produced plots/1:13/1:13 C2 RECR.fig', 'reuse', 'invisible');
fig2 = gca;
h3 = openfig('produced plots/1:13/1:13 C2 LBF.fig', 'reuse', 'invisible');
fig3 = gca;
h4 = openfig('produced plots/1:13/1:13 C2 RBF.fig', 'reuse', 'invisible');
fig4 = gca;
h5 = openfig('produced plots/1:13/1:13 C2 LTF.fig', 'reuse', 'invisible');
fig5 = gca;
h6 = openfig('produced plots/1:13/1:13 C2 RTF.fig', 'reuse', 'invisible');
fig6 = gca;

hmain = figure;
s1 = subplot(3,2,1);
xlim([40 90])
title('Left Extensor Carpi Radialis (LECR)')
s1.YTick = fig1.YTick;
s1.YTickLabels = fig1.YTickLabels;

s2 = subplot(3,2,2);
xlim([40 90])
title('Right Extensor Carpi Radialis (RECR)')
s2.YTick = fig2.YTick;
s2.YTickLabels = fig2.YTickLabels;

s3 = subplot(3,2,3);
xlim([40 90])
title('Left Bicep Flexor (LBF)')
s3.YTick = fig3.YTick;
s3.YTickLabels = fig3.YTickLabels;

s4 = subplot(3,2,4);
xlim([40 90])
title('Right Bicep Flexor (RBF)')
s4.YTick = fig4.YTick;
s4.YTickLabels = fig4.YTickLabels;

s5 = subplot(3,2,5);
xlim([40 90])
title('Left Tibialis Flexor (LTF)')
s5.YTick = fig5.YTick;
s5.YTickLabels = fig5.YTickLabels;

s6 = subplot(3,2,6);
xlim([40 90])
title('Right Tibialis Flexor (RTF)')
s6.YTick = fig6.YTick;
s6.YTickLabels = fig6.YTickLabels;

copyobj(get(fig1,'children'), s1);
copyobj(get(fig2,'children'), s2);
copyobj(get(fig3,'children'), s3);
copyobj(get(fig4,'children'), s4);
copyobj(get(fig5,'children'), s5);
copyobj(get(fig6,'children'), s6);

han=axes(hmain,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
yl = ylabel(han,'Time of measurement','FontWeight','bold');
yl.Position(1) = yl.Position(1) - abs(yl.Position(1) * .2);
xl = xlabel(han,'Time (ms)','FontWeight', 'bold');
xl.Position(2) = xl.Position(2) - abs(xl.Position(2) * .15);
tl = title(han,'MEP traces for 1/13 surgery', 'FontSize', 13);
tl.Position(2) = tl.Position(2) + abs(tl.Position(2) * .03);

set(gcf,'Position',[0 0 700 1000])

%% do once
drop_range = [];
