%% Look at the state variables and current 

clear all 

en1 = [];
en2 = [];

for i = 1:100

load(fullfile(cd, 'out_exp1', ['out_' num2str(i)]))
outputs = out.xout;

y1 = out.y1.Data(1:400);
y2 = out.y2.Data(1:400);

ac1 = out.ac1.Data(1:400);
ac2 = out.ac2.Data(1:400);

x15 = out.x15.Data(1:400);
x16 = out.x16.Data(1:400);

pdot1 = x15 - x16;

en1 = [en1 mean(pdot1.^2)];
en2 = [en2 mean((pdot1+ac1).^2)];

end

%%

figure
hold on
histogram(en1)
histogram(en2)

%%

figure
hold on

plot(diff(x15 - x16))
plot(ac1)

figure
hold on
plot([0; diff(x15 - x16)] + ac1)
plot([0; diff(x15 - x16)])
