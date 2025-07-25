function [neatDataWithPInh] = masterInhPlotter(lumpedAllResultsInhTable,rowOrder,emptyRows)
% parent function: MasterCodePhaseEla20250212.m 
% organize data for Inhibitory neurons 

[organizedDataInh,uniqueStructures] = organizeDataByStructureINH(lumpedAllResultsInhTable); % organize by structure 
visualizeOrganizedDataInh(organizedDataInh,uniqueStructures); % plot histograms for non SWDs and SWDs 
[DataWithPInh] = rankSumPhaseInh(organizedDataInh,uniqueStructures); %  % calculate p values 
[sortedUniqueStructures,neatDataWithPInh] = orderAndPlotPhaseHeatmapsInh(uniqueStructures,DataWithPInh,rowOrder,emptyRows); % plot heatmap for all units (nonSWD vs SWD)- MAIN FIG 


end 