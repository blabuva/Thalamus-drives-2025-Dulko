%% this script takes off where 'unitPhaseFromDataBase.m' leaves off (line 88). Mark peeled off this script to keep memory issues at bay
%% unitPhaseFromDataBase.m includes the original data base as well as the phase data base. There's (probably) no need to load both tables in a single
%% script if you're just extracting phase data
%% just recall that everytime the data base is updated, the phase table loaded in this script also needs to be reconstructed and saved from
%% unitPhaseFromDataBase.m


% parent-ish script: unitPhaseFromDataBase.m

%%
% ccc ;

%%
% load('/home/mark/matlab_temp_variables/justTheDBphase') ;
keep phase
close all; clc ;

%% set the default text interpreter so that text isn't odd
set(groot, 'DefaultTextInterpreter', 'none')
set(groot, 'DefaultLegendInterpreter', 'none')
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')

%% load and correct Anna Grace's excel structure file
structureLumper = AGfileParser('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;

%% calculate Ela's peak/value ratio for all structures. Also filter structures according to their corresponding P2V ratios. Filter according to highRatioThreshold and lowRatioThreshold
highRatioThreshold = 5;
lowRatioThreshold = 2 ;
elasPeakToValleyRatios = collectAllPeakToVallyRatios(phase, structureLumper, highRatioThreshold, lowRatioThreshold) ;

%% create new table for all units, based on gria.singleALL. This will force the order of all other unit data to conform to the order of gria.singleALL
reorderedTablePlaceHolder = createReOrderedTablePlaceHolder(elasPeakToValleyRatios.gria.singleALL.perCycle.Filtered) ;

%% reorder table according to order in reordedTable (i.e. gria.singleALL)
allReorderedTables = collectAllReorderedTables(elasPeakToValleyRatios, reorderedTablePlaceHolder) ;

%% create heat map of histograms
histHeatMaps.gria.singleALL = makeHeatMapOfPhaseHists(allReorderedTables.gria.singleAll) ;
histHeatMaps.gria.singleEX = makeHeatMapOfPhaseHists(allReorderedTables.gria.singleEX) ;
histHeatMaps.gria.singleIN = makeHeatMapOfPhaseHists(allReorderedTables.gria.singleIN) ;
histHeatMaps.gria.multi = makeHeatMapOfPhaseHists(allReorderedTables.gria.multi) ;

histHeatMaps.stargazer.singleALL = makeHeatMapOfPhaseHists(allReorderedTables.stargazer.singleAll) ;
histHeatMaps.stargazer.singleEX = makeHeatMapOfPhaseHists(allReorderedTables.stargazer.singleEX) ;
histHeatMaps.stargazer.singleIN = makeHeatMapOfPhaseHists(allReorderedTables.stargazer.singleIN) ;
histHeatMaps.stargazer.multi = makeHeatMapOfPhaseHists(allReorderedTables.stargazer.multi) ;

%%   plot heat maps for histograms
subPlotParams = [3,6] ;
plotTheHistoHeats(histHeatMaps.gria.singleALL, allReorderedTables.gria.singleAll.ElasStructureName, 'Y', [subPlotParams, 1], 'Gria',  'All Single Units')
plotTheHistoHeats(histHeatMaps.gria.singleEX, allReorderedTables.gria.singleEX.ElasStructureName, 'N', [subPlotParams, 2], 'Gria',  'Excitatory Single Units')
plotTheHistoHeats(histHeatMaps.gria.singleIN, allReorderedTables.gria.singleIN.ElasStructureName, 'N', [subPlotParams, 3], 'Gria', 'Inhibitory Single Units')
plotTheHistoHeats(histHeatMaps.gria.multi, allReorderedTables.gria.multi.ElasStructureName, 'N', [subPlotParams, 4], 'Gria', 'Multi Units')

plotTheHistoHeats(histHeatMaps.stargazer.singleALL, allReorderedTables.stargazer.singleAll.ElasStructureName, 'Y', [subPlotParams, 7], 'Stargazer', 'All Single Units')
plotTheHistoHeats(histHeatMaps.stargazer.singleEX, allReorderedTables.stargazer.singleEX.ElasStructureName, 'N', [subPlotParams, 8], 'Stargazer ', 'All Excitatory Units')
plotTheHistoHeats(histHeatMaps.stargazer.singleIN, allReorderedTables.stargazer.singleIN.ElasStructureName, 'N', [subPlotParams, 9], 'Stargazer', 'All Inhibitory Units')
plotTheHistoHeats(histHeatMaps.stargazer.multi, allReorderedTables.stargazer.multi.ElasStructureName, 'N', [subPlotParams, 10], 'Stargazer', 'Multi Units')

%% plot example histos for LD Thal and VB Thal
plotHistoExamples(histHeatMaps.gria.singleALL(2,:), histHeatMaps.gria.singleALL(17,:), [subPlotParams, 5], 'LD vs VB', 'All Gria Single Units', 'LD', 'VB', 'red', 'blue')

%% plot example histos for excitatory and inhibitory neurons of the same structure: CA3
plotHistoExamples(histHeatMaps.gria.singleEX(3,:), histHeatMaps.gria.singleIN(3,:), [subPlotParams, 6], 'Excitatory vs Inhibitory', 'Gria CA3', 'Excit.', 'Inhib.', 'DarkGreen', 'red')


%% plot example histos for Gria VS Stargazer of the same structure: S1
plotHistoExamples(histHeatMaps.gria.singleALL(7,:), histHeatMaps.stargazer.singleALL(7,:), [subPlotParams, 13], 'Gria vs Stargazer', 'S1: All Single Units', 'Gria', 'STG',  'black', 'DarkOrange')

%% plot example histos for Gria VS Stargazer of the same structure: CL thalamus
plotHistoExamples(histHeatMaps.gria.singleALL(6,:), histHeatMaps.stargazer.singleALL(6,:), [subPlotParams, 14], 'Gria vs Stargazer', 'CL: All Single Units', 'Gria', 'STG',  'black', 'DarkOrange')
  
%% plot example histos for Gria VS Stargazer of the same structure: LP thalamus
plotHistoExamples(histHeatMaps.gria.singleALL(15,:), histHeatMaps.stargazer.singleALL(15,:), [subPlotParams, 15],  'Gria vs Stargazer', 'CA3: All Single Units', 'Gria', 'STG',  'black', 'DarkOrange')
  

%% position the figure
set(gcf, 'units', 'normalized', 'position', [0.05, 0.05, 0.5, 0.9])



%% OLD CODE:
%% 3D line plot
% subplot(1,2,1)
%     plot3(allX, allY, normHists)
%     axis([50, 150, -inf, inf, -inf, inf])