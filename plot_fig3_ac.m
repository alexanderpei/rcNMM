%% Plot sample AC 

clc
close all
clear all

load sol

%%

fig = figure;
fig.Position = [587         400        1360/2         371]; 
% Time series
hold on
box on

t = 1:0.01:4;
y1 = sol(15).ac(:, 1:length(t));

plot(t, y1(1, :), 'b', 'LineWidth', 1.2)
plot(t, y1(2, :), 'r', 'LineWidth', 1.2)

% ylim([-0.8 0.8])
% xlim([1 4])
% 
% yticks([-0.8 0 0.8])
% yticklabels({'-0.8', '0', '0.8'})

xticks([1:4])
xticklabels({'1', '2', '3', '4'})

ylabel('Current (mA)')
xlabel('Time (s)')
ax = gca;
ax.FontSize = 16;
ax.LineWidth = 1.5;


