function [t, allT, idxOut] = fn_cluster_perm(freq1, freq2, nPerm, alpha) 

nFreq = length(freq1.freq);
nTrial = size(freq1.powspctrm,1);

h = zeros(1,nFreq);
tStat = zeros(1,nFreq);

% Average across the two columns
aveFreq1 = squeeze(mean(freq1.powspctrm, 2));
aveFreq2 = squeeze(mean(freq2.powspctrm, 2));

% Get all the t-values and if reject/accept h
for idx = 1:nFreq
    [h(idx), ~, ~, tStat_] = ttest(aveFreq1(:,idx), aveFreq2(:,idx), 'alpha', alpha);
    tStat(idx) = tStat_.tstat;
end

% Zero pad 
h = [0 h 0];
tStat = [0 tStat 0];

% Find the largest cluster in the all of the t-values
idxClust = fn_find_cluster_idx(h);
t = sum(tStat(idxClust));
idxOut = idxClust;

% Do the permutation test
allFreq = [aveFreq1; aveFreq2];
allT = zeros(1, nPerm);

for idxPerm = 1:nPerm
    randIdx = randperm(nTrial*2);
    tempFreq1 = allFreq(randIdx(1:nTrial),:);
    tempFreq2 = allFreq(randIdx(nTrial+1:nTrial*2),:);
    h = zeros(1,nFreq);
    tStat = zeros(1,nFreq);
    for idx = 1:nFreq
        [h(idx), ~, ~, tStat_] = ttest(tempFreq1(:,idx), tempFreq2(:,idx), 'alpha', alpha);
        tStat(idx) = tStat_.tstat;
    end
    h = [0 h 0];
    tStat = [0 tStat 0];
    idxClust = fn_find_cluster_idx(h);
    allT(idxPerm) = sum(tStat(idxClust));
end