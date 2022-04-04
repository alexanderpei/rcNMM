%% Run the AC simulation

% Runs iterations of the simulation with randomly generated AC
% This will generate the training data to train the ESN

clc
clear
close all

model = 'nmm';
N = 1000;
load_system(model)

nIter = 1;
for i = 1:nIter

tic

P = fn_get_params_simu(1, N);

for idx = N:-1:1
    in(idx) = Simulink.SimulationInput(model);
end

out = parsim(in, 'ShowProgress', 'on', 'TransferBaseWorkspaceVariables', 'on');

toc

for idx = N:-1:1
    sol(idx).y = [out(idx).y1.Data,out(idx).y2.Data]';
    sol(idx).ac = [squeeze(out(idx).ac1.Data), squeeze(out(idx).ac2.Data)]';
end

save(fullfile(cd, ['sol_' num2str(i)]), 'sol', '-v7.3')

end

%% Merge the sol files together into a single file 

c = 0;
for i = 1:nIter
    
    load(fullfile(cd, ['sol_' num2str(i)]))

    allsol(N*nIter-(i-1)*N:-1:N*nIter-(i)*N+1) = sol; 
    c = c + 1;

end

sol = allsol;
save('sol', 'sol', '-v7.3')
