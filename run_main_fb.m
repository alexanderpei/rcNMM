if exist('out_exp1')
    rmdir('out_exp1','s')
end
if exist('out_exp3')
    rmdir('out_exp3','s')
end
if exist('out_exp2')
    rmdir('out_exp2','s')
end

% ks = 0.7:0.05:1;
% esns = 0.2:0.2:1;

ks = 0.95;
esns = 1;

for k = ks
    for esnf = esns

        save('k', 'k')
        save('esnf', 'esnf')

        for i = 1:100
            run_sim_fb1;
        end; beep;

        for i = 1:100
            run_sim_fb2;
        end; beep;

        for i = 1:100
            run_sim_fb3;
        end; beep;

        load('k')
        load('esnf')

        dirOut = fullfile(cd, 'outs', ['out_' num2str(k) '_' num2str(esnf)]);
        mkdir(dirOut)

        movefile('out_exp1', dirOut)
        movefile('out_exp2', dirOut)
        movefile('out_exp3', dirOut)

    end
end