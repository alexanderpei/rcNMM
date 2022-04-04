%% Script that runs the close-loop simulation

% Main script to run the feedback stimulation

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
nTrial = 10;

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
ks = [0.7:0.05:1];
ks = 0.95;

c = 0;

%% Exp 1

for f = 1:length(esns)

    for k = ks

        for i = 1:nTrial

            c = c + 1;

            ac1 = [0 0];
            ac2 = [0 0];

            in(c) = Simulink.SimulationInput(model);
            in(c) = in(c).setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_pred_');
            in(c) = in(c).setBlockParameter([model '/u1'], 'Seed', num2str(P(i).seed(1)));
            in(c) = in(c).setBlockParameter([model '/u2'], 'Seed', num2str(P(i).seed(2)));
            in(c) = in(c).setVariable('P', P(i), 'Workspace', model);
            in(c) = in(c).setVariable('ac1', ac1, 'Workspace', model);
            in(c) = in(c).setVariable('ac2', ac2, 'Workspace', model);

            in(c) = in(c).setBlockParameter([model '/Constant'], 'Value', num2str(f));
            in(c) = in(c).setBlockParameter([model '/Constant1'], 'Value', num2str(k));

        end

    end

end

tic

out = parsim(in, 'ShowProgress', 'on', 'AttachedFiles', esns);

toc

save('out_1.mat', 'out', '-v7.3')
save('P','P')
%% Exp 2

% load out_1
clear in
c = 0;
iCond = 0;

for f = 1:length(esns)

    for k = ks

        iCond = iCond + 1;

        for i = 1:nTrial

            c = c + 1;

            randTrial = randi(nTrial)+(iCond-1)*nTrial;
            while randTrial == c
                randTrial = randi(nTrial)+(iCond-1)*nTrial;
            end

            ac1 = out(randTrial).ac1;
            ac2 = out(randTrial).ac2;

            in(c) = Simulink.SimulationInput(model);
            in(c) = in(c).setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_zero');
            in(c) = in(c).setBlockParameter([model '/u1'], 'Seed', num2str(P(i).seed(1)));
            in(c) = in(c).setBlockParameter([model '/u2'], 'Seed', num2str(P(i).seed(2)));
            in(c) = in(c).setVariable('P', P(i), 'Workspace', model);
            in(c) = in(c).setVariable('ac1', ac1, 'Workspace', model);
            in(c) = in(c).setVariable('ac2', ac2, 'Workspace', model);

        end

    end

end

tic

out = parsim(in, 'ShowProgress', 'on');

toc

save('out_2.mat', 'out', '-v7.3')

%% Exp 3

clear in
c = 0;

for f = 1

    for k = 1

        for i = 1:nTrial

            c = c + 1;

            randTrial = randi(nTrial);
            while randTrial == i
                randTrial = randi(nTrial);
            end

            ac1 = [0 0];
            ac2 = [0 0];

            in(c) = Simulink.SimulationInput(model);
            in(c) = in(c).setBlockParameter([model '/AC Prediction'],  'MATLABFcn', 'fn_simu_zero');
            in(c) = in(c).setBlockParameter([model '/u1'], 'Seed', num2str(P(i).seed(1)));
            in(c) = in(c).setBlockParameter([model '/u2'], 'Seed', num2str(P(i).seed(2)));
            in(c) = in(c).setVariable('P', P(i), 'Workspace', model);
            in(c) = in(c).setVariable('ac1', ac1, 'Workspace', model);
            in(c) = in(c).setVariable('ac2', ac2, 'Workspace', model);

        end

    end

end

tic

out = parsim(in, 'ShowProgress', 'on');

toc

save('out_3.mat', 'out', '-v7.3')
