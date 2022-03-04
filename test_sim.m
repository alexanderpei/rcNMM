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
nTrial = 100;

for i = 1:nTrial
    P(i) = fn_get_params_simu(1, 1);
end

fracData = 10./logspace(1,4,10);
fracData = fracData(1:end-1);
esns = cell(1, length(fracData));
for i = 1:length(fracData)
    esns{i} = ['esn_' num2str(i) '.mat'];
end

esns = esns(1);
ks = [0.95];

c = 0;

%% Exp 1

k = 0.9;
f = 1;

ac1 = [0 0];
ac2 = [0 0];
in  = Simulink.SimulationInput(model);
in  = in .setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_pred_');
in  = in .setBlockParameter([model '/u1'], 'Seed', num2str(P(i).seed(1)));
in  = in .setBlockParameter([model '/u2'], 'Seed', num2str(P(i).seed(2)));
in  = in .setModelParameter('SaveState', 'on');
in  = in .setVariable('P', P(i), 'Workspace', model);
in  = in .setVariable('ac1', ac1, 'Workspace', model);
in  = in .setVariable('ac2', ac2, 'Workspace', model);

in  = in .setBlockParameter([model '/Constant'], 'Value', num2str(f));
in  = in .setBlockParameter([model '/Constant1'], 'Value', num2str(k));

out2 = sim(in);


