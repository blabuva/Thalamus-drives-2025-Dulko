function pathToData = findThePhaseFile(experimentInfo, analyticsTimeStamp)
% parent function: phasePop.m

% save('/home/mark/matlab_temp_variables/phaseFILE')
% ccc
% load('/home/mark/matlab_temp_variables/phaseFILE')

%% path to data
dataPath = sprintf('%s/%s/plotsAndAnalytics/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, analyticsTimeStamp) ;

%% list contents of dataPath
dataFile = dir(sprintf('%s/allData*.mat', dataPath)) ;

%% explicitly define phase file
pathToData = sprintf('%s/%s', dataPath, dataFile.name) ;
