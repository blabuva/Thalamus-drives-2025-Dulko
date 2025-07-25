function mappedUnits = curateKiloSort(dataPathCurated, map, fidTracker)
% Parent Function: analyzeElasExperiment.m

% save('/home/mark/matlab_temp_variables/spikeCLUST')
% ccc
% load('/home/mark/matlab_temp_variables/spikeCLUST')

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

%% load all data into structure. The 'loadKSdir' function comes from the UCL neuropixels GitHub repo
spikeStruct = loadKSdir_mark(dataPathCurated) ;

%% Grab all spike data (times & cluster ID) from within spikeStruc and place in table
allSpikes = array2table([double(spikeStruct.st), double(spikeStruct.clu)], 'VariableNames', {'SpikeTimes', 'ClusterID'}) ;

%% Grab curated data from within spikeStruc (variables named by UCL are extracted, transposed and placed in table)
%    --> grab curated spike cluster IDs (i.e., the clusters that have been manually curated - all except the noisy ones)
curatedSpikes = array2table([spikeStruct.cids', spikeStruct.cgs']  , 'VariableNames', {'ClusterID', 'UnitType'}) ;

%% go thru all curatedSpikes.ClusterID and grab their spike times
curatedSpikes = collectCuratedSpikeTimes(allSpikes, curatedSpikes) ;

%% collect single units and multi units from curated data
unMappedUnits = collectSingleMultiUnits(curatedSpikes) ;

%% align units with channel map
mappedUnits = mapClusterWithElectrode(unMappedUnits, map) ;