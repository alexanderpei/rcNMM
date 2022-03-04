%%

clear all
close all

pathData = fullfile(cd, 'esn');
dirData  = dir(fullfile(pathData, '*.mat'));

%%



mse = [];
frac = [];

for iFile = 1:length(dirData)
    load(fullfile(pathData, dirData(iFile).name))

    name = dirData(iFile).name(5:end-4);
    frac = [frac str2num(name)];

    mse = [mse; squeeze(mean(errors(:,:,:), [1 3]))];
end

%%

fracData = 10./logspace(1,4,10);
fracData = fracData(1:end-1);

fig = figure;
fig.Position = [587         400        1360/2         371]; 
hold on
box on 

plot(log(fracData), mse(:,1), 'b', 'LineWidth', 1.2)
plot(log(fracData), mse(:,2), 'r', 'LineWidth', 1.2)
legend('Train', 'Test')
ylabel('MSE')
xlabel('Log fraction of training data')
xlim([log(fracData(end)) log(fracData(1))])
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;