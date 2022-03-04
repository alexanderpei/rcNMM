%% Converts output from Simulink solver into Fieldtrip Datastructure

clear
close all

%% Convert to Fieldtrip

nCond = 3;
nSample = 400;
dur = 4;
Fs = nSample/dur;
chanLabels  = {'y1','y2', 'ac1', 'ac2', 'x15-x16', 'x25-x26', 'ac1rand', 'ac2rand'};
nChannel = length(chanLabels);

data = [];
labels = [];
allP = [];

for iCond = 1:nCond

    pathData = fullfile(cd, ['out_exp' num2str(iCond)]);
    dirData  = dir(fullfile(pathData, 'out*'));
    nTrials = length(dirData);

    tempData = zeros(nChannel, nSample, nTrials);
    tempLabels = ones(1, nTrials)*iCond;

    for iTrial = 1:nTrials

        load(fullfile(pathData, dirData(iTrial).name))

        tempData(1,:,iTrial) = out.y1.Data(1:400);
        tempData(2,:,iTrial) = out.y2.Data(1:400);
        tempData(3,:,iTrial) = out.ac1.Data(1:400);
        tempData(4,:,iTrial) = out.ac2.Data(1:400);

        %%%%%%

        outputs = out.xout;

        ac1 = out.ac1.Data(1:400);
        ac2 = out.ac2.Data(1:400);

        x15 = getElement(outputs, 'x15');
        x15 = x15.Values.Data/P.Te(1);
        
        x16 = getElement(outputs, 'x16');
        x16 = x16.Values.Data/P.Ti(1);
        
        x15 = resample(x15, length(ac1), length(x15));
        x16 = resample(x16, length(ac1), length(x16));
    
        x25 = getElement(outputs, 'x25');
        x25 = x25.Values.Data/P.Te(1);
        
        x26 = getElement(outputs, 'x26');
        x26 = x26.Values.Data/P.Ti(1);
        
        x25 = resample(x25, length(ac1), length(x25));
        x26 = resample(x26, length(ac1), length(x26));

        tempData(5,:,iTrial) = [0; diff(x15 - x16)];
        tempData(6,:,iTrial) = [0; diff(x25 - x26)];

        allP = [allP; P];

    end

    tempData(7, :, :) = tempData(3, :, randperm(nTrials));
    tempData(8, :, :) = tempData(4, :, randperm(nTrials));

    data = cat(3,data,tempData);
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

save('ftdata', 'ftdata' ,'allP')
