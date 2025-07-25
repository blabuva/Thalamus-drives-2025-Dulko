%% clear all
ccc ;

%% Load in Ela's master excel sheet
pathToExcel = '/media/markX/elasMasterProbeSheet.xlsx' ;
excelTable = readtable(pathToExcel) ;

%% Loop through excelTable and analyze experiments
for iExperiment = 1:size(excelTable,1)
    currentLine = excelTable(iExperiment, :) ;
    if strcmp(currentLine.Analyze_Y_N_, 'Y')
        experimentInfo = readElasTable(currentLine) ;
        analyzeElasExperiment(experimentInfo) ;
    end
end









