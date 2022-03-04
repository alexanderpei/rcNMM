%%

clear all
close all

if exist('out_exp1')
    rmdir('out_exp1','s')
end
if exist('out_exp3')
    rmdir('out_exp3','s')
end

run_sim_fb1;
run_sim_fb3;

%%

load(fullfile('out_exp1', 'out_1'))

out1 = out;

load(fullfile('out_exp3', 'out_1'))

out2 = out;

%%

figure
subplot(2,2,1)
hold on
plot(out1.y1)
plot(out2.y1)

subplot(2,2,2)
hold on
plot(out1.ac1)
plot(out2.ac1)
legend('FB', 'No FB')

subplot(2,2,3)
hold on
plot(out1.y2)
plot(out2.y2)
legend('FB', 'No FB')

subplot(2,2,4)
hold on
plot(out1.ac2)
plot(out2.ac2)
legend('FB', 'No FB')

en1 = mean(out1.y1.Data(201:400).^2);
en2 = mean(out2.y1.Data(201:400).^2);
en3 = mean(out1.y2.Data(201:400).^2);
en4 = mean(out2.y2.Data(201:400).^2);

disp(en1 - en2)
disp(en3 - en4)
disp((en1-en2)/en2*100)
