%%

clear all
close all

%%

nIter = 100;

for idx = 1:nIter
    
    % Read txt into cell A
    fid = fopen(fullfile(cd,'job.sh'),'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);
    % Change cell A
    A{20} = sprintf('#SBATCH --output=/lab_data/barblab/AlexP/source/dde%d.out',idx);
    
    A{27} = sprintf('matlab -nodisplay -nosplash -r "rng(%d); nIter=%d; run_dde"',randi(1e6),idx);
    % Write cell A into txt
    fid = fopen(fullfile(cd,['job' num2str(idx) '.sh']), 'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end
    
    fclose all;
    
end

