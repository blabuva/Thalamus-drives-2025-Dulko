function curatedSpikes = collectCuratedSpikeTimes(allSpikes, curatedSpikes)
% parent function: curateKiloSort.m

%% extract relevant functions
allClusterIDs = allSpikes.ClusterID ;
curatedClusterIDs = curatedSpikes.ClusterID ;

%% get indices of curatedClusterIDs that are found within allClusterIDs. Use indices to collect curated spike times
for iCluster = 1:length(curatedClusterIDs)
    clusterIDX{iCluster,1} = find(allClusterIDs == curatedClusterIDs(iCluster)) ;
    curatedSpikes.SpikeTimesSec{iCluster,1} = allSpikes.SpikeTimes(clusterIDX{iCluster}) ;
end

%% append indices of curatedClusterIDs that are found within allClusterIDs.
curatedSpikes.IDXofUncuratedSpikeVector = clusterIDX ;


