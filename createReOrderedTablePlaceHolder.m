function reorderedTable = createReOrderedTablePlaceHolder(originalTable) 
% parent function: extractAndPlotPhaseFromDataBase.m

%% create table
reorderedTable = originalTable ;

%% create empy column for inserting
emptyColumn = repmat({[]}, size(originalTable,1), 1);

%% enter empty columns
reorderedTable.Histogram = emptyColumn ;
reorderedTable.NonLumpP2Vratio = emptyColumn ;
reorderedTable.LumpedHistogram = emptyColumn ;
reorderedTable.LumpedP2Vratio = emptyColumn ;
reorderedTable.PeakBin = emptyColumn ;