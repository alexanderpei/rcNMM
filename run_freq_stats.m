%% 

clear all
close all

load ftdata_freq

nPerm = 1000;
alpha = 0.05;

%%

cfg = [];
cfg.trials = freq.trialinfo == 1;
freq1 = ft_selectdata(cfg, freq);
freq1.powspctrm = freq1.powspctrm(:,1,:);

cfg.trials = freq.trialinfo == 2;
freq2 = ft_selectdata(cfg, freq);
freq2.powspctrm = freq2.powspctrm(:,1,:);

%%

figure
hold on
err =  std(squeeze(freq1.powspctrm))/10;
shadedErrorBar(freq1.freq, squeeze(mean(freq1.powspctrm)), err)
% plot(squeeze(mean(freq1.powspctrm)))
% plot(squeeze(mean(freq2.powspctrm)))
