%% min/max analysis


post_stim = floor(max(size(traces,1)) * .6);
dist = [];
figure(1)
%select correct data for analysis
hold on

for i = 1:size(traces,2)
    [Mpks, ~] = findpeaks(traces(post_stim : end,i),'MinPeakDistance', 50);
    M = max(Mpks);
    plot(t(find(traces(:,i) == M)), M, 'r*')
    [mpks, ~] = findpeaks(-traces(post_stim : end,i),'MinPeakDistance', 50);
    m = max(mpks);
    plot(t(find(traces(:,i) == -m)), -m, 'r*')
    dist(end+1) = M + m;
end
hold off

figure(2)
ndist = (dist-min(dist)) ./ (max(dist)-min(dist));
cats = categorical(times);
b = bar(cats,ndist,'FaceColor', 'flat');

ylabel('Normalized Max - Min voltage (mV)', 'FontWeight', 'bold')
xlabel('Time of measurement','FontWeight','bold')
ylim([0 1.1])
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(round(b.YData, 2));
text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
xticklabels(times)
set(gca,'FontSize', 13)
title({'Maximum peak-to-trough amplitudes', 'Measured at left extensor carpi radialis (LECR)'})

drop = find(dist == min(dist));

%% multi-pig

if drop == 1
    drop_range = [drop_range;-1, dist(drop + 1), dist(drop + 1)];
elseif drop == length(dist)
    drop_range = [drop_range;dist(drop - 1), dist(drop), -1];
else
    drop_range = [drop_range;dist(drop - 1), dist(drop), dist(drop + 1)];
end


figure(3);
cats = categorical({'Pre-Drop', 'Drop', 'Post-Drop'});
cats = reordercats(cats,{'Pre-Drop', 'Drop', 'Post-Drop'});
b = bar(cats,drop_range);

ylabel('Normalized Max - Min voltage (mV)', 'FontWeight', 'bold')
xlabel('Time of measurement','FontWeight','bold')
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
xticklabels(times)
set(gca,'FontSize', 13)
title({'Maximum peak-to-trough amplitudes', 'Measured at left extensor carpi radialis (LECR)'})






