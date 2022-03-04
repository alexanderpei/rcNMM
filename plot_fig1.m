%% Figure 1: Sample trial and spectrum

% Plot a sample trial and spectrum

clc
clear all
close all

load ftdata_3
load ftdata_3_freq

%% Generate the plot

iTrial = 8;

fig = figure;
fig.Position = [587 400 1360 371];

% Time series
subplot(1,2,1)
hold on
box on

iT = 1:200;
iF = 1:60;
t = ftdata.time{iTrial}(iT);
y1 = ftdata.trial{iTrial}(1, iT);
y2 = ftdata.trial{iTrial}(2, iT);

plot(t, y1, 'b', 'LineWidth', 1.2)
plot(t, y2, 'r', 'LineWidth', 1.2)

ylim([-0.8 0.8])
yticks([-0.8 0 0.8])
yticklabels({'-0.8', '0', '0.8'})
ylabel('Potential (mV)')
xlabel('Time (s)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('A')

% Power spectrum
subplot(1,2,2)
hold on
box on

f = freq.freq(iF);

y1f = squeeze(mean(freq.powspctrm(iTrial, 1, iF), 1));
y2f = squeeze(mean(freq.powspctrm(iTrial, 2, iF), 1));

plot(f, y1f, 'b', 'LineWidth', 1.2)
plot(f, y2f, 'r', 'LineWidth', 1.2)

ylim([0 12e-4])
yticks([0 6e-4 12e-4])
yticklabels({'0', '6e-4', '12-e4'})
ylabel('Power (mv^2/Hz)')
xlabel('Frequency (Hz)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

title('B')
