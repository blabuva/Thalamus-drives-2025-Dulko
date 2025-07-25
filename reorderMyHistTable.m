function reorderedTable = reorderMyHistTable(originalTable, reorderedTable) 
%parent function: extractAndPlotPhaseFromDataBase.m

%%
save('/home/mark/matlab_temp_variables/phaseHEETER')
% ccc
% load('/home/mark/matlab_temp_variables/phaseHEETER')

%% convert cells containing strings into just strings
originalTable.ElasStructureName = string(originalTable.ElasStructureName) ;
reorderedTable.ElasStructureName = string(reorderedTable.ElasStructureName) ;

%% loop through table
for iRow = 1:size(reorderedTable,1)
    currentStructure = reorderedTable.ElasStructureName(iRow) ;
    matchingRowNum = find(strcmp(originalTable.ElasStructureName, currentStructure));
    if ~isempty(matchingRowNum)
        matchingRowContents = originalTable(matchingRowNum, :) ;
        reorderedTable.Histogram(iRow) = matchingRowContents.Histogram ;
        reorderedTable.NonLumpP2Vratio(iRow) = matchingRowContents.NonLumpP2Vratio ;
        reorderedTable.LumpedHistogram(iRow) = matchingRowContents.LumpedHistogram ;
        reorderedTable.LumpedP2Vratio{iRow} = matchingRowContents.LumpedP2Vratio ;
        reorderedTable.PeakBin{iRow} = matchingRowContents.PeakBin ;
    end
end
