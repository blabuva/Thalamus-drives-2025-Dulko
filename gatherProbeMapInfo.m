function map = gatherProbeMapInfo(mapPath, dataPathCurated, fidTracker) 
% Parent Function: analyzeElasExperiment.m

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

%% load file containing anatomical location of each electrode
electrodeLocations = load(sprintf('%s%s', mapPath, 'electrodeLocations.mat')) ;
map.channelBrainLocations = electrodeLocations.electrodeLocations ;

%% load file containing electrode ID# for each identified cluster (i.e. neuron). The electrode containing the highest spike amplitude is used.
map.clusterChannelIDs = readtable(sprintf('%s/%s', dataPathCurated, 'cluster_info.tsv'), 'FileType', 'delimitedtext');

%% increment channel numbers by 1 (KS assigns channels starting with 0)
map.clusterChannelIDs.ch = map.clusterChannelIDs.ch + 1;

% load file containing X-Y positions of electrodes
map.channelPositions = readNPY(sprintf('%s/%s', dataPathCurated, 'channel_positions.npy')) ;