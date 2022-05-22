%% Figure 2: Show reduction in energy, AC characteristics

clc
clear all
close all

nCond = 3;
nChan = 6;
nTrial = 10;
en = zeros(63, nTrial, nCond, nChan);
freqs = zeros(63, nTrial, 6, 101);

ks = [0.7:0.05:1];
esns = 1:9;

c = 0;
for i = 1:length(ks)
    for j = 1:length(esns)

        c = c + 1;
        disp(c)

        load ftdata_1
        load ftdata_1_freq

        cfg = [];
        cfg.trials = ftdata.trialinfo == c;
        ftdata1 = ft_selectdata(cfg, ftdata);
        freq1 = ft_selectdata(cfg, freq);

        freqs(c, :, :, :) = freq1.powspctrm;

        load ftdata_2
        load ftdata_2_freq

        cfg = [];
        cfg.trials = ftdata.trialinfo == c;
        ftdata2 = ft_selectdata(cfg, ftdata);
        freq2 = ft_selectdata(cfg, freq);

        load ftdata_3
        load ftdata_3_freq

        ftdata3 = ftdata;
        freq3 = freq;

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

                en(c, iTrial, iCond, :) = tempTrial;

            end

        end

    end
end

%%

save('en', 'en', 'freqs')

%%
arr = zeros(length(esns), length(ks));

c = 0;
for i = 1:length(esns)
    for j = 1:length(ks)
        c = c + 1;

        en1 = mean(en(c, :, 1, 1));
        en2 = mean(en(c, :, 3, 1));

        arr(i, j) = (en1 - en2) / en2 ;

    end
end

imagesc(arr)
colorbar

%%

fracData = 10./logspace(1,4,10);
fracData = fracData(1:end-1);

kstr = cell(1,length(ks));
for i = 1:length(ks)
    kstr{i} = num2str(ks(i));
end

formatSpec = '%.1f';
estr = cell(1,length(fracData));
for i = 1:length(fracData)
    estr{i} = num2str(log(fracData(i)), formatSpec);
end

fig = imagesc(arr*100);
xticks(1:7)
xticklabels(kstr)
yticks(1:9)
yticklabels(estr)
xlabel('k')
ylabel('Log fraction of training data')

c = colorbar;
c.LineWidth = 1.5;
colormap jet

ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;

%% AC energy vs. k

fig = figure;
fig.Position = [587 400 1360 371];

subplot(1,2,1)
box on
hold on
en_ = [];

for i = 7:7:63

    temp = squeeze(en(i, :, 1, [3 4]));
    temp = mean(temp(:).^2);
    en_ = [en_ temp];

end
scatter(1:length(en_), log(en_), 'k', 'filled')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
xticks(1:9)
xticklabels(estr)
xlim([1 9])
xlabel('Log fraction of training data')
ylabel('Mean AC Energy')
title('A')

subplot(1,2,2)
box on
hold on

c = colormap(jet);
iColor = 1:floor(size(c, 1)/9):size(c,1);

iCond = 7:7:63;

for i = 1:length(iCond)

    plot(freq.freq, squeeze(mean(freqs(iCond(i), :, 3, :), 2)), 'Color', c(iColor(i), :), 'LineWidth', 2)

end
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;
xlim([0 30])
title('B')

c = colorbar;
c.LineWidth = 1.5;
c.FontSize = 16;
c.Ticks = linspace(0, 1, 9);
c.TickLabels = estr;

ylim([0 0.12])
ylabel('Power (C mV^2/Hz)')
xlabel('Frequency (Hz)')