%%

clear all
close all

pathData = fullfile(cd, 'out_exp1');
dirData  = dir(fullfile(pathData, '*.mat'));
nFile    = length(dirData);

%%

en = zeros(nFile, 6);
iStimStart = 200;

for iFile = 1:nFile

    load(fullfile(cd, 'out_exp1', dirData(iFile).name))

    en(iFile, 1) = mean(out.y1.Data(200:end).^2);
    en(iFile, 2) = mean(out.y2.Data(200:end).^2);

    load(fullfile(cd, 'out_exp2', dirData(iFile).name))

    en(iFile, 3) = mean(out.y1.Data(200:end).^2);
    en(iFile, 4) = mean(out.y2.Data(200:end).^2);

    load(fullfile(cd, 'out_exp3', dirData(iFile).name))

    en(iFile, 5) = mean(out.y1.Data(200:end).^2);
    en(iFile, 6) = mean(out.y2.Data(200:end).^2);

end

%% Visualize

figure

subplot(1,2,1)
hold on

load(fullfile(cd, 'out_exp1', dirData(1).name))
y1_ = out.y1.Data;
plot(y1_);

load(fullfile(cd, 'out_exp2', dirData(1).name))
y1 = out.y1.Data;
plot(y1);

load(fullfile(cd, 'out_exp3', dirData(1).name))
y1rand = out.y1.Data;
plot(y1rand);

legend('Pred AC', 'Rand AC', 'No AC')

subplot(1,2,2)
plot(y1_-y1)

%%

figure
hold on

histogram(en(:,1))
histogram(en(:,3))
histogram(en(:,5))