%% Fig 7 destructive interference

clc
clear all
close all

nTrial = 100;

coi = 7;

load ftdata_1
load ftdata_1_freq

cfg = [];
cfg.trials = ftdata.trialinfo == coi;
ftdata1 = ft_selectdata(cfg, ftdata);
freq1 = ft_selectdata(cfg, freq);

%% Calculate destructive interference

en1 = [];
en2 = [];

for iTrial = 1:nTrial

    temp = ftdata1.trial{iTrial}(5, 201:400);
    en1 = [en1 mean(temp.^2)];

    temp = temp + ftdata1.trial{iTrial}(3, 201:400);
    en2 = [en2 mean(temp.^2)];

end

[h,p] = ttest(en1, en2)

%%

fig = figure;
fig.Position = [587 400 1360 371];

subplot(1,2,1)
hold on
box on
[~, idx] = max(en1 - en2);

temp = ftdata1.trial{idx}(5, 201:300);

plot(ftdata1.time{idx}(201:300), temp, 'r', 'LineWidth', 1.5)
temp = temp + ftdata1.trial{idx}(3, 201:300);
plot(ftdata1.time{idx}(201:300), temp, 'b', 'LineWidth', 1.5)
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
xlabel('Time (sec)')
ylabel('Membrane Current')
title('A')

subplot(1,2,2)
hold on
box on

means = mean([en1; en2], 2);
stds  = std([en1; en2]', 1)./sqrt(100);

H = bar(means, 'FaceColor', [1 0 0], 'LineWidth', 1.5);

groups = {[1 2]};
sigstar(groups, [-Inf])
er = errorbar(means, stds);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
er.LineWidth = 1.5;

ylim([0 140])
xticks([1 2])
xticklabels({'No FB', 'FB'})
% yticks([0 0.03 0.06])
% yticklabels({'0', '0.03', '0.06'})
title('B')
ylabel('Mean Squared Current')

ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
