function [x, y] = fn_preproc_ac(sol)

nTrial = length(sol);
delta = 60;
nTime = 400;
iRand = 0;
len = length(2+iRand:delta:nTime-delta);

x = zeros(nTrial*len, 6, delta);
y = zeros(nTrial*len, 2, delta);

c = 0;
for iTrial = 1:nTrial

    for iTime = 2+iRand:delta:nTime-delta

        c = c + 1;

        % x(c, 1:2, :) = sol(iTrial).y([9 18], iStart+delta:iEnd-1+delta);
        x(c, 1:2, :) = sol(iTrial).y(:, iTime:iTime+delta-1);
        x(c, 3:4, :) = sol(iTrial).y(:, iTime+1:iTime+delta);
        x(c, 5:6, :) = sol(iTrial).ac(:, iTime-1:iTime+delta-2);
        
        y(c, 1:2, :) = sol(iTrial).ac(:, iTime:iTime+delta-1);

    end

end

end