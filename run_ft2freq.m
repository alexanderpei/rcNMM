%% Do time-freq analysis on Fieldstrip struct

clear
close all

fName = 'ftdata_3';

load(fName)

%% Run

cfg = [];
cfg.toi        = ftdata.time{1}(201:400);
cfg.channel    = 'all';
cfg.tapsmofrq  = 2;
cfg.method     = 'mtmfft';
cfg.pad        = 'nextpow2';
cfg.keeptrials = 'yes';
cfg.output     = 'powandcsd';
cfg.foi        = 0:0.5:50;
cfg.calcdof    = 'yes';

freq = ft_freqanalysis(cfg, ftdata);
save([fName '_freq'] ,'freq')

%%

% cfg = [];
% cfg.trials = ftdata.trialinfo == 1;
% freq = ft_selectdata(cfg, freq);
% 
% cfg = [];
% cfg.method = 'coh';
% out = ft_connectivityanalysis(cfg, freq);
