%%

clear all 
close all

x = zeros(100, 4, 400);

%%

for iFile = 1:100

    load(fullfile(cd, 'out_exp1', ['out_' num2str(iFile) '.mat']))

    outputs = out.xout;
    
    ac1 = out.ac1.Data(1:400);
    ac2 = out.ac2.Data(1:400);
    
    x15 = getElement(outputs, 'x15');
    x15 = x15.Values.Data/P.Te(1);
    
    x16 = getElement(outputs, 'x16');
    x16 = x16.Values.Data/P.Ti(1);
    
    x15 = resample(x15, length(ac1), length(x15));
    x16 = resample(x16, length(ac1), length(x16));

    x25 = getElement(outputs, 'x25');
    x25 = x25.Values.Data/P.Te(1);
    
    x26 = getElement(outputs, 'x26');
    x26 = x26.Values.Data/P.Ti(1);
    
    x25 = resample(x25, length(ac1), length(x25));
    x26 = resample(x26, length(ac1), length(x26));

    x(iFile, 1, :) = ac1;
    x(iFile, 2, :) = ac2;
    x(iFile, 3, :) = [0; diff(x15 - x16)];
    x(iFile, 4, :) = [0; diff(x25 - x26)];

end

%%

xfft = x(:, :, 201:400);
Fs = 100;
T = 1/Fs; 
L = 200;
t = (0:L-1)*T;
f = Fs*(0:(L/2))/L;

for i = 1:100
    for j = 1:4
        xfft(i, j, :) = fft(xfft(i, j, :));
    end
end

%%

fig = figure;

for iPlot = 1:4

    switch iPlot
        case 1
            y1 = angle(xfft(:, 2, :)./xfft(:, 4, :));
            y2 = angle(xfft(:, 2, :)./xfft(randperm(100), 4, :));
    end

    subplot(2,2,iPlot)
    hold on
    box on
    plot(f, mean(y1(:, 100:200)))
    plot(f, mean(y2(:, 100:200)))

end

%%

figure
hold on
plot(squeeze(x(3,1,:)))
plot(squeeze(x(30,3,:)))
