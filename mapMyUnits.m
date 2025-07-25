function mapped = mapMyUnits(unMapped, map)
% parent function: mapClusterWithElectrode.m

% save('/home/mark/matlab_temp_variables/MP')
% ccc
% load('/home/mark/matlab_temp_variables/MP')



%% extract cluster and channel IDs
clusterChannelMap = array2table(map.clusterChannelIDs.cluster_id, 'VariableNames', {'ClusterID'}) ;
clusterChannelMap.ChannelID = map.clusterChannelIDs.ch ;
clusterIDs_All = unMapped.ClusterID ;

%% for some experiments, there's a mismatch between existing clusters (i.e. those from 'cluster_info.tsv' and those from the
% neuropixels KS code (loadKSdir_mark.m)). This loop ensures that only clusters from 'map' (derived from 'cluster_info.tsv' are taken
for iCluster = 1:length(clusterIDs_All)
    clusterIDX = find(clusterChannelMap.ClusterID == clusterIDs_All(iCluster)) ;
    trackEmptyClusters{iCluster,1} = clusterIDX ;
end

if exist('trackEmptyClusters') ==1
    nonEmptyClusterIDX = find(~cellfun(@isempty,trackEmptyClusters));
else
    nonEmptyClusterIDX = [] ;
end

%% copy unmapped into a mapped structure to which electrode info will be appended
mapped = unMapped(nonEmptyClusterIDX, :) ;

%% get cluster ID values that exist both 
nonEmptyClusterIDs = clusterIDs_All(nonEmptyClusterIDX) ;

%% append map info
for iCluster = 1:length(nonEmptyClusterIDs)
    clusterIDX = find(clusterChannelMap.ClusterID == nonEmptyClusterIDs(iCluster)) ;
    mapped.ClusterIDVerify(iCluster) =clusterChannelMap.ClusterID(clusterIDX) ;
    mapped.Channel_Number(iCluster) =clusterChannelMap.ChannelID(clusterIDX) ;
    mapped.Channel_Xposition(iCluster) = map.channelPositions(mapped.Channel_Number(iCluster), 1) ;
    mapped.Channel_Yposition(iCluster) = map.channelPositions(mapped.Channel_Number(iCluster), 2) ;
    mapped.Channel_Brain(iCluster) = map.channelBrainLocations(mapped.Channel_Number(iCluster), 2)  ;
end












