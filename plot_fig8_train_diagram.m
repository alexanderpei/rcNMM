%%

clear all
close all

%%

t = 0:0.15:1;
I = sin(2*pi*t);
P = randi(10, [1 length(t)]);

figure
subplot(2,1,1)
plot(sin(2*pi*t),'k','LineWidth', 2)
subplot(2,1,2)
plot(P,'k','LineWidth', 2)
