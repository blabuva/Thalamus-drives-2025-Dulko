%% clear all
ccc ;

%% create file to keep track of functions
[fidTracker, fileName] = createFileTrackerName() ;

%% Load in Ela's master excel sheet
%pathToExcel = '/media/probeX/intanData/ela/elasMasterProbeSheet.xlsx' ;
pathToExcel = '/media/elaX/intanData/elasMasterProbeSheet_2.xlsx'; 
excelTable = readtable(pathToExcel) ;

%% collect all data (i.e., experiments with an associated "Analytics Time Stamp" in the excel file
experimentNum = 1; 
for iFileLine = 1:size(excelTable,1)
    currentLine = excelTable(iFileLine, :) ;
    analyticsTimeStamp = currentLine.AnalyticsTimeStamp{1} ;
        if ~isempty(analyticsTimeStamp)
            experimentInfo = readElasTable(currentLine) ;
            pathToData = findThePhaseFile(experimentInfo, analyticsTimeStamp) ;
            allExperiments{experimentNum, 1} = load(pathToData) ;
            allExperiments{experimentNum, 1}.mouseID = currentLine.MouseID{1} ;
            allExperiments{experimentNum, 1}.analyticsTimeStamp = analyticsTimeStamp ;
            allExperiments{experimentNum, 1}.pathToData = pathToData ;
            allExperiments{experimentNum, 1}.gender = currentLine.MouseSex{1} ;
            allExperiments{experimentNum, 1}.age = currentLine.MouseAge_days_ ;
            allExperiments{experimentNum, 1}.strain = currentLine.MouseStrain;
            experimentNum = experimentNum + 1 ;
        end
end

%% aggregate data
aggraPhase(allExperiments)
