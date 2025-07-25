%% mother script for evaluating phase

%% clear all
ccc ;

%% turn off matlab warnings (matlab warns about creating folders that already exist) 
warning('off', 'all')

%% Load in Ela's master excel sheet
pathToExcel = '/media/probeX/intanData/ela/elasMasterProbeSheet.xlsx' ;
excelTable = readtable(pathToExcel) ;

%% count numbers of Ys to analyze for progress report
numberExperimentsToAnalyze = length(find(strcmp('Y', excelTable.Analyze_Y_N_))) ;

%% Loop through excelTable and analyze experiments
experimentNumberTracker = 1; 
for iExperiment = 1:size(excelTable,1)
    currentLine = excelTable(iExperiment, :) ;
    if strcmp(currentLine.Analyze_Y_N_, 'Y')
        experimentInfo = readElasTable(currentLine) ;
        disp(sprintf('Analyzing %s (%i%% complete of total)', experimentInfo.mouse.ID, round(100 * experimentNumberTracker/numberExperimentsToAnalyze)))
        phaseAnalyticsPath = sprintf('%s/%s/plotsAndAnalytics/%s', currentLine.PathToDataFolder{1}, currentLine.MouseID{1}, currentLine.AnalyticsTimeStamp{1}) ;
        phaseFile = dir(sprintf('%s/spikePhases*', phaseAnalyticsPath)) ;
        phaseFileFull = sprintf('%s/%s', phaseAnalyticsPath, phaseFile.name) ;
        parseThePhaseFile(phaseFileFull, currentLine.MouseID{1}, currentLine.AnalyticsTimeStamp{1}) ;
        experimentNumberTracker =  experimentNumberTracker + 1 ;
    end
end

%% turn  matlab warnings back on just in case
warning('on', 'all')

