%% Figure 2: Show reduction in energy, AC characteristics

clc
clear all
close all

load ftdata_1
load ftdata_1_freq

%% Calculate the energy over all trials

nCond = 3;
nChan = 4;
nTrial = 100;

en = zeros(nTrial, nCond, nChan);

for iCond = 1:nCond

    ixTrial = find(ftdata.trialinfo == iCond);
    
    for iTrial = 1:length(ixTrial)

        tempTrial = ftdata.trial{ixTrial(iTrial)};
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


for c = 1:1

hold on
box on

means = mean(en(:, :, c), 1);
stds  = std(en(:, :, c), 1)/sqrt(nTrial);

bar(means, 'FaceColor', [1 0 0], 'LineWidth', 1.5)
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
iTrial = 3;
iChan = 1;

t = ftdata.time{iTrial}(iT);
y1 = ftdata.trial{iTrial+nTrial*2}(iChan, iT);
y2 = ftdata.trial{iTrial}(iChan, iT);
y3 = ftdata.trial{iTrial+nTrial}(iChan, iT);

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

title('(a)')

% Power spectrum
subplot(2,2,2)
hold on
box on

f = freq.freq(iF);

y1f = squeeze(freq.powspctrm(iTrial+nTrial*2, iChan, iF));
y2f = squeeze(freq.powspctrm(iTrial, iChan, iF));
y3f = squeeze(freq.powspctrm(iTrial+nTrial, iChan, iF));

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

title('(b)')
legend('Rand FB', 'No FB', 'FB')

% AC Current
subplot(2,2,3)
hold on
box on 
t = ftdata.time{iTrial}(iT);
y1 = ftdata.trial{iTrial}(iChan+2, iT);

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

title('(c)')

% AC Current
subplot(2,2,4)
hold on
box on 

f = freq.freq(iF);

y1f = squeeze(freq.powspctrm(iTrial, iChan+2, iF));

plot(f, y1f, 'm', 'LineWidth', 1.2)
ylim([0 0.04])
yticks([0 0.02 0.04])
yticklabels({'0', '0.02', '0.04'})
ylabel('Power (mv^2/Hz)')
xlabel('Frequency (Hz)')

ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('(d)')

%% 

fig = figure;
fig.Position = [587 967 1360/2 371];

box on
hold on
f = freq.freq(iF);

iChan = 1;

err1 = std(squeeze(freq.powspctrm(201:300, iChan, iF)))/10;
err2 = std(squeeze(freq.powspctrm(1:100, iChan, iF)))/10;
err3 = std(squeeze(freq.powspctrm(101:200, iChan, iF)))/10;

y1f = squeeze(mean(freq.powspctrm(201:300, iChan, iF)));
y2f = squeeze(mean(freq.powspctrm(1:100, iChan, iF)));
y3f = squeeze(mean(freq.powspctrm(101:200, iChan, iF)));

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
legend('Rand FB', 'No FB', 'FB')
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
