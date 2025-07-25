% function aggraPhase(allExperiments)
% % parent function: phasePop.m

% save('/home/mark/matlab_temp_variables/aggrap')
% ccc
% load('/home/mark/matlab_temp_variables/aggrap')
% set(0,'DefaultFigureVisible','off')
clc
close all
keep allExperiments

%% load in Anna Grace's structure/color excel file
structureInfo = readtable('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;

%% extract code structure names
brainNames = structureInfo.NameUsedByCode ;

%% populate phaseTable with empty cells
allDataTable = createAllDataTableForUnits(brainNames) ;

%% enter function that loops through all the data and append phase data to appropriate brain structure
allDataTable = collectAllRawPhases(allDataTable, 'SWDs', allExperiments, structureInfo, brainNames) ;

%% add number of mice and neurons to phase Table
allDataTable = addMouseNeuronNs(allDataTable, brainNames) ;

%% create monster phase matrices from allDataTable
allDataTable = monsterUnitPhase(allDataTable) ;

%% plot sample size update
% plotUnitSampleSize(allDataTable, brainNames)
% close all

%% plot phase data
% allDataTable = plotAggaUnitsPhase(allDataTable, 'SWDs')





