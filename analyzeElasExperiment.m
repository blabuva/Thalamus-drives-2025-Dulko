function individualExperimentDataBaseFileName = analyzeElasExperiment(experimentInfo, fidTracker, ...
    numSeizureDetectionMats, dataBaseFolderDump, dataBaseTimeStamp) 
% Parent Function: analyzeElasMasterProbeFile


% save('/home/mark/matlab_temp_variables/ELs')
% ccc
% load('/home/mark/matlab_temp_variables/ELs')

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

skip = 0
if skip == 0

%% create time stamp to store output
%% save data mat
if numSeizureDetectionMats == 1
    matDumpPath = sprintf('%s/%s/plotsAndAnalytics/Motor/', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file) ;
else
    matDumpPath = sprintf('%s/%s/plotsAndAnalytics/S1/', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file) ;
end
   
mkdir(matDumpPath) ;
timeNow = clock ;
theTimeStamp = sprintf('%i_%02i_%02i__%02i_%02i_%02i', timeNow(1), timeNow(2), timeNow(3), timeNow(4), timeNow(5), round(timeNow(6))) ;
dumpFolder = sprintf('%s%s', matDumpPath, theTimeStamp) ;     
unix(sprintf('mkdir %s', dumpFolder)) ;

%% define data input paths
dataPathCurated = sprintf('%s/%s/%s/', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, 'analyzedData') ;
mapPath = sprintf('%s/%s/%s/', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, 'anatomyData') ;
dataPathRaw = sprintf('%s/%s/%s/', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, 'rawData') ;
detectedSeizuresPath = experimentInfo.dataPaths.pathToSeizures ;

%% Collect channel maps for curated clusters (obtained from anatomical reconstruction of probe location)
map = gatherProbeMapInfo(mapPath, dataPathCurated, fidTracker) ;

%% Organize curated data (i.e. single/multiunits)
mappedKSUnits = curateKiloSort(dataPathCurated, map, fidTracker) ;

%% Align Spikes with Seizures (according to user-defined pad in excel sheet)
seizurePad = experimentInfo.spikeDetectionParams.seizurePad ;
[type1SWDs, nonSWDs, EEG] = spikesAndSeizures(mappedKSUnits, detectedSeizuresPath, seizurePad, dataPathRaw, fidTracker) ;

%% create searchable database for future generations to love and cherish
dataBase = createSingleExperimentUnitDataBase(type1SWDs, mappedKSUnits, EEG, experimentInfo, map, theTimeStamp, ...
    dataPathRaw, dataPathCurated, detectedSeizuresPath, dumpFolder);

%% group SWDs and associated spikes according to brain structure
brainSpikes = groupClustersFromSameBrainStructures(type1SWDs, fidTracker) ;
brainSpikesNonSWD = groupClustersFromSameBrainStructures(nonSWDs, fidTracker) ;

%% plot SWD and KS spike data
experimentData.SWDs = plotType1SWDs(brainSpikes, EEG, experimentInfo, 'SWD', dumpFolder, fidTracker) ;

%% save temp
% save('/home/mark/matlab_temp_variables/anaEla')
end
% load('/home/mark/matlab_temp_variables/anaEla')

%% plot NON-SWD and KS spike data
experimentData.NON_SWDs = plotType1SWDs(brainSpikesNonSWD, EEG, experimentInfo, 'NON-SWD', dumpFolder, fidTracker) ;

%% pack the EEG variable in experimentData (probably helpful later)
experimentData.EEG = EEG ;

%% save the variables to disk
saveProbeAnalytics(experimentData, dumpFolder, theTimeStamp, experimentInfo)  ;

%% save database file
individualExperimentDataDump = sprintf('%s/%s', dataBaseFolderDump, experimentInfo.mouse.ID) ;
mkdir(individualExperimentDataDump) ;

individualExperimentDataBaseFileName = sprintf('%s/%s/%s_dataBase__%s', dataBaseFolderDump, experimentInfo.mouse.ID, ...
    experimentInfo.mouse.ID, dataBaseTimeStamp) ;

save(individualExperimentDataBaseFileName, 'dataBase') ;



%% Collect raw traces and spike threshold to get all spikes
% if strcmp(experimentInfo.spikeDetectionParams.runManThreshold, 'Y') == 1
%     spikeThreshold = experimentInfo.spikeDetectionParams.threshold ;
%     hiPassFilt = experimentInfo.spikeDetectionParams.hiPassFilt ;
%     mappedThresholdedSpikes = threshRawIntanData(dataPathRaw, map, spikeThreshold, hiPassFilt) ;
% end















