function out = fn_simu_pred_(in)

esn = in(end-1);
k   = in(end);

in = in(1:end-2);

delta = (size(in, 1)-1)/2;

% Load persistant stuff

persistent allEsn c tc ac n acHist

if isempty(c) || in(end) == 0

    allEsn = [];
    c = 0;
    tc = 2;
    ac = zeros(2, delta);
    acHist = zeros(2, delta);
    tcc = 0;
    pd = 0;
    n = zeros(6, delta);
    
end

% load('k.mat')
% load('esnf.mat')

if in(end) >= tc

    if isempty(allEsn)
        %load(fullfile(cd, 'esn', ['esn_' num2str(1) '.mat']))
        fName = ['esn_' num2str(esn) '.mat'];

        load(fName)
    end

    n(1, :) = in(1:delta);
    n(2, :) = in(delta+1:end-1);

    n(3, 1:end-1) = n(1, 2:end);
    n(4, 1:end-1) = n(2, 2:end);
    n(3, end) = n(3, end-1)*k;
    n(4, end) = n(4, end-1)*k;

    n(5, :) = acHist(1, :);
    n(6, :) = acHist(2, :);

    tc = tc + 0.01;

    % Should we calculate new stimulation
    if true
        ac = zeros(2, delta);
        for iEsn = 1:length(allEsn)
            ac = ac + fn_pred_ac(n, allEsn(iEsn))./length(allEsn);
        end
        acHist = ac;
    end

end

if true
    out = ac(:, end);
else
    out = zeros(2, delta);
    out = out(:, end);
end

end