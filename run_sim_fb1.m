%% Script that runs the close-loop simulation

% Two different experiments:
% 1. Normal feedback prediction
% 2. AC from a different random seed
% 3. No AC, using same random seed

clear all
close all
warning off 

model = 'nmm_fb';
load_system(model)
nExp = 1;
in = Simulink.SimulationInput(model);

%%


pathOut = fullfile(cd, 'out_exp1');
nFile = length(dir(fullfile(pathOut, 'out*')));

P = fn_get_params_simu(1, 1);

out.ac1 = [0 0];
out.ac2 = [0 0];
in = in.setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_pred');


% elseif nExp == 2
% 
%     pathOut = fullfile(cd, 'out_exp2');
%     nFile = length(dir(fullfile(pathOut, 'out*')));
%     
%     % Get the seed from the first file
%     load(fullfile(cd, 'out_exp1', ['out_' num2str(nFile+1)]))
%     P_ = P;
% 
%     % Get the AC stim from the second file
%     iRand = randi(10);
%     while iRand == nFile+1
%         iRand = randi(20);
%     end
% 
%     load(fullfile(cd, 'out_exp1', ['out_' num2str(iRand)]))
%     P = P_;
% 
%     in = in.setBlockParameter([model '/gainInput1'], 'Gain', num2str(1));
%     in = in.setBlockParameter([model '/gainInput2'], 'Gain', num2str(1));
%     in = in.setBlockParameter([model '/gainPred1'],  'Gain', num2str(0));
%     in = in.setBlockParameter([model '/gainPred2'],  'Gain', num2str(0));
% 
% elseif nExp == 3
% 
%     pathOut = fullfile(cd, 'out_exp3');
%     nFile = length(dir(fullfile(pathOut, 'out*')));
% 
%     % Get the seed
%     load(fullfile(cd, 'out_exp1', ['out_' num2str(nFile+1)]))
% 
%     in = in.setBlockParameter([model '/gainInput1'], 'Gain', num2str(0));
%     in = in.setBlockParameter([model '/gainInput2'], 'Gain', num2str(0));
%     in = in.setBlockParameter([model '/gainPred1'],  'Gain', num2str(0));
%     in = in.setBlockParameter([model '/gainPred2'],  'Gain', num2str(0));
% 
% end

if ~exist(pathOut)
    mkdir(pathOut)
end

in = in.setBlockParameter([model '/u1'], 'Seed', num2str(P.seed(1)));
in = in.setBlockParameter([model '/u2'], 'Seed', num2str(P.seed(2)));
in = in.setModelParameter('SaveState', 'on');

tic

out = sim(in);

toc

save(fullfile(pathOut, ['out_' num2str(nFile+1)]), 'out', 'P')

