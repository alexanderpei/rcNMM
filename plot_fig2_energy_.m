%% Figure 2: Show reduction in energy, AC characteristics

clc
clear all
close all

coi = 7;

load ftdata_1
load ftdata_1_freq

cfg = [];
cfg.trials = ftdata.trialinfo == coi;
ftdata1 = ft_selectdata(cfg, ftdata);
freq1 = ft_selectdata(cfg, freq);
 
load ftdata_2
load ftdata_2_freq

cfg = [];
cfg.trials = ftdata.trialinfo == coi;
ftdata2 = ft_selectdata(cfg, ftdata);
freq2 = ft_selectdata(cfg, freq);

load ftdata_3
load ftdata_3_freq

cfg = [];
cfg.trials = ftdata.trialinfo == coi;
ftdata3 = ftdata;
freq3 = freq;

ks = [0.7:0.05:1];
esns = 1:9;

coi = 1;

%% Calculate the energy over all trials

nCond = 3;
nChan = 4;
nTrial = 100;

en = zeros(nTrial, nCond, nChan);

for iCond = 1:nCond

    switch iCond
        case 1
            tempData = ftdata1;
        case 2
            tempData = ftdata2;
        case 3
            tempData = ftdata3;
    end
    
    for iTrial = 1:nTrial

        tempTrial = tempData.trial{iTrial};
        tempTrial = mean(tempTrial(:,201:400).^2, 2);

        en(iTrial, iCond, :) = tempTrial(1:4);
        
    end
    
end

%% Do simple stats on the energy

[h, p1] = ttest(en(:, 1, 1), en(:, 2, 1))
[h, p2] = ttest(en(:, 1, 1), en(:, 3, 1))


%% Make a bargraph

iChan = 1;

% First bargraph y1 energy
fig = figure;
fig.Position = [587 967 1100/2 360];


for c = 1

hold on
box on

means = mean(en(:, :, c), 1);
stds  = std(en(:, :, c), 1)/sqrt(nTrial);

H = bar(means, 'FaceColor', [1 0 0], 'LineWidth', 1.5);

groups = {[1 2], [1 3]};
sigstar(groups, [-Inf, -Inf])
er = errorbar(means, stds);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
er.LineWidth = 1.5;

ylim([0 0.06])
xticks([1 2 3])
xticklabels({'FB', 'Rand FB', 'No FB'})
yticks([0 0.03 0.06])
yticklabels({'0', '0.03', '0.06'})

ylabel('Mean Squared PC Potential')

ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;


end


%% Plot with and without AC

fig = figure;
fig.Position = [587 400 1360 371*2];

% Time series
subplot(2,2,1)
hold on
box on

iT = 100:400;
iF = 1:60;
iTrial = 5;
iChan = 1;

t = ftdata.time{iTrial}(iT);
y1 = ftdata3.trial{iTrial}(iChan, iT);
y2 = ftdata1.trial{iTrial}(iChan, iT);
y3 = ftdata2.trial{iTrial}(iChan, iT);

plot(t, y3, 'Color', [0 220 0]/255, 'LineWidth', 1.5)
plot(t, y1, 'r', 'LineWidth', 1.2)
plot(t, y2, 'b', 'LineWidth', 1.2)

ylim([-0.8 0.8])
xlim([1 4])

yticks([-0.8 0 0.8])
yticklabels({'-0.8', '0', '0.8'})

xticks([1:4])
xticklabels({'1', '2', '3', '4'})

ylabel('Potential (mV)')
xlabel('Time (s)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
legend('Rand FB', 'No FB', 'FB', 'Location', 'Northwest')

title('A')

% Power spectrum
subplot(2,2,2)
hold on
box on

f = freq.freq(iF);

y1f = squeeze(freq3.powspctrm(iTrial, iChan, iF));
y2f = squeeze(freq1.powspctrm(iTrial, iChan, iF));
y3f = squeeze(freq2.powspctrm(iTrial, iChan, iF));

plot(f, y3f, 'Color', [0 220 0]/255, 'LineWidth', 1.2)
plot(f, y1f, 'r', 'LineWidth', 1.2)
plot(f, y2f, 'b', 'LineWidth', 1.2)

ylim([0 1.6e-3])
yticks([0 0.8e-3 1.6e-3])
yticklabels({'0', '8-e04', '16e-4'})
ylabel('Power (mv^2/Hz)')
xlabel('Frequency (Hz)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('B')
legend('Rand FB', 'No FB', 'FB', 'Location', 'Northwest')

% AC Current
subplot(2,2,3)
hold on
box on 
t = ftdata1.time{iTrial}(iT);
y1 = ftdata1.trial{iTrial}(iChan+2, iT);

plot(t, y1, 'm', 'LineWidth', 1.2)

ylim([-6 6])
xlim([1 4])

yticks([-6 0 6])
yticklabels({'-6', '0', '6'})

xticks([1:4])
xticklabels({'1', '2', '3', '4'})

ylabel('Current (mA)')
xlabel('Time (s)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('C')

% AC Current
subplot(2,2,4)
hold on
box on 

f = freq1.freq(iF);
6
y1f = squeeze(freq1.powspctrm(iTrial, iChan+2, iF));

plot(f, y1f, 'm', 'LineWidth', 1.2)
ylim([0 0.04])
yticks([0 0.02 0.04])
yticklabels({'0', '0.02', '0.04'})
ylabel('Power (C mv^2/Hz)')
xlabel('Frequency (Hz)')

ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('D')

%% 

fig = figure;
fig.Position = [587 967 1360/2 371];

box on
hold on
f = freq.freq(iF);

iChan = 1;

err1 = std(squeeze(freq3.powspctrm(:, iChan, iF)))/10;
err2 = std(squeeze(freq1.powspctrm(:, iChan, iF)))/10;
err3 = std(squeeze(freq2.powspctrm(:, iChan, iF)))/10;

y1f = squeeze(mean(freq3.powspctrm(:, iChan, iF)));
y2f = squeeze(mean(freq1.powspctrm(:, iChan, iF)));
y3f = squeeze(mean(freq2.powspctrm(:, iChan, iF)));

shadedErrorBar(f, y3f, err3, 'lineProps', {'Color', [0 220 0]/255, 'LineWidth', 1.2})
shadedErrorBar(f, y1f, err1, 'lineProps', {'r', 'LineWidth', 1.2})
shadedErrorBar(f, y2f, err2, 'lineProps', {'b', 'LineWidth', 1.2})

ylim([0 1.6e-3])
yticks([0 0.8e-3 1.6e-3])
yticklabels({'0', '8-e04', '16e-4'})
ylabel('Power (mv^2/Hz)')
xlabel('Frequency (Hz)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
legend('Rand FB', 'No FB', 'FB', 'Location', 'Northeast')
% subplot(1,2,2)
% hold on
% box on
% f = freq.freq(iF);
% 
% iChan = 2;
% y1f = squeeze(mean(freq.powspctrm(201:300, iChan, iF)));
% y2f = squeeze(mean(freq.powspctrm(1:100, iChan, iF)));
% y3f = squeeze(mean(freq.powspctrm(101:200, iChan, iF)));
% 
% shadedErrorBar(f, y3f, err3, 'lineProps', {'Color', [0 220 0]/255, 'LineWidth', 1.2})
% shadedErrorBar(f, y1f, err1, 'lineProps', {'r', 'LineWidth', 1.2})
% shadedErrorBar(f, y2f, err2, 'lineProps', {'b', 'LineWidth', 1.2})
% 
% ylim([0 1.6e-3])
% yticks([0 0.8e-3 1.6e-3])
% yticklabels({'0', '8-e04', '16e-4'})
% ylabel('Power (mv^2/Hz)')
% xlabel('Frequency (Hz)')
% ax = gca;
% ax.FontSize = 16;
% ax.LineWidth = 1.5;
% legend('Rand FB', 'No FB', 'FB')
% title('PC 2')
