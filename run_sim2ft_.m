%% Converts output from Simulink solver into Fieldtrip Datastructure

clear
close all

%% Convert to Fieldtrip

nExp = 2;
nCond = 63;
nSample = 400;
dur = 4;
Fs = nSample/dur;
chanLabels  = {'y1','y2', 'ac1', 'ac2', 'x15-x16', 'x25-x26'};
nChannel = length(chanLabels);
nTrials = 10;

labels = [];

pathData = ['out_' num2str(nExp) '.mat'];
load(pathData)

data = zeros(nChannel, nSample, nTrials*nCond);

c = 0;

for iCond = 1:nCond

tempLabels = ones(1, nTrials)*iCond;

    for iTrial = 1:nTrials

        c = c + 1;

        data(1,:, c) = out(c).y1.Data(1:400);
        data(2,:, c) = out(c).y2.Data(1:400);
        data(3,:, c) = out(c).ac1.Data(1:400);
        data(4,:, c) = out(c).ac2.Data(1:400);
        data(5,:, c) = out(c).x15.Data(1:400)-out(c).x16.Data(1:400);
        data(6,:, c) = out(c).x25.Data(1:400)-out(c).x26.Data(1:400);

    end

    labels = [labels tempLabels];    

end

% Create time axis
timeAxis = linspace(0, dur, nSample);

% Make Fieldtrip structure
ftdata = [];
[~,~,total] = size(data);
for i = 1:total
    ftdata.trial{i} = squeeze(data(:, :, i));
    ftdata.time{i} = timeAxis;
end

ftdata.fsample = Fs;
ftdata.label = chanLabels;
ftdata.label = ftdata.label(:);
ftdata.trialinfo = labels';

save(['ftdata_' num2str(nExp)], 'ftdata' , '-v7.3')

beep
