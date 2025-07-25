function [neatDataWithPExc] = masterExcPlotter(lumpedAllResultsExcTable,rowOrder,emptyRows)
% parent function: MasterCodePhaseEla20250212.m 
% organize data for Excitatory neurons 

[organizedDataExc,uniqueStructures] = organizeDataByStructureEXC(lumpedAllResultsExcTable); % organize by structure 
visualizeOrganizedDataExc(organizedDataExc,uniqueStructures); % plot histograms for non SWDs and SWDs 
[DataWithPExc] = rankSumPhaseExc(organizedDataExc,uniqueStructures); % calculate p values
[sortedUniqueStructures,neatDataWithPExc] = orderAndPlotPhaseHeatmapsExc(uniqueStructures,DataWithPExc,rowOrder,emptyRows); % plot heatmap for all units (nonSWD vs SWD)- MAIN FIG 


end 