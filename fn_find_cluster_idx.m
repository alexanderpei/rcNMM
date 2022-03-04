function idxClust = fn_find_cluster_idx(h)

idxClustStart = find(diff(h)==1);
idxClustEnd = find(diff(h)==-1);
clustSize = idxClustEnd - idxClustStart;
[maxClustSize, maxClustIdx] = max(clustSize);
idxClust = idxClustStart(maxClustIdx):idxClustStart(maxClustIdx)+maxClustSize-1;
