% MEPs stacking

close all
hold on
traces = [];
times = {};

var = s10_14;
for i = 1:length(var)
    if (isempty(var(i).MEP) == 0) && (isempty(var(i).MEP(6).C1) == 0)
        traces(:,end+1) = var(i).MEP(6).C1;
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


t = 0:100/max(size(traces,1)): 99.99;
plot(t, traces, 'Color', 'Black', 'LineWidth', 1.7)
xlabel('Time (ms)','FontWeight', 'bold')
ylabel('Time of measurement','FontWeight','bold')
ylim([min(min(traces))-100, max(max(traces))+100])
xlim([40, 90])
yticks(flip(traces(1,:)))
yticklabels(flip(times))
set(gca,'FontSize', 13);
title({'MEP signal traces measured from the', 'right tibialis flexor (RTF)'})
set(gcf,'Position',[0 0 400 400])

hold off 

%% do once
drop_range = [];
