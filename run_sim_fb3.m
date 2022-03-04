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
nExp = 3;
in = Simulink.SimulationInput(model);

%%

pathOut = fullfile(cd, 'out_exp3');
nFile = length(dir(fullfile(pathOut, 'out*')));

% Get the seed
load(fullfile(cd, 'out_exp1', ['out_' num2str(nFile+1)]))

out.ac1 = [0 0];
out.ac2 = [0 0];
in = in.setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_zero');

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

