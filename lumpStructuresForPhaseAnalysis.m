function [lumpedAllResultsTable,lumpedAllResultsInhTable,lumpedAllResultsExcTable] = lumpStructuresForPhaseAnalysis(AllResultsTable, AllResultsInhTable, AllResultsExcTable)
% parent function: MasterCodePhaseEla20250212.m 

% input: 3 tables 
% Store tables in a cell array with corresponding variable names
tables = {AllResultsTable, AllResultsInhTable, AllResultsExcTable};
tableNames = {'AllResultsTable', 'AllResultsInhTable', 'AllResultsExcTable'};

structureLumper = readtable('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;

% Preallocate a structure to store the results
lumpedResults = struct();

% Loop through each table and apply the function
for iTable = 1:numel(tables)
    lumpedTable = tables{1,iTable}; 
    
    for iRow = 1:size(lumpedTable,1)

        extractedName = lumpedTable(iRow,1); 
        originalName = extractedName.BrainStructure{1,1};  % as character 
        indexToNewName = strcmp(originalName,structureLumper.NameUsedByCode); 
        newName = structureLumper.KeepAs_name__Don_tAnalyse(indexToNewName); 
        lumpedTable(iRow,1) = newName; 
       
    end 
    % store 
   lumpedResults.(tableNames{iTable}) = lumpedTable; 
   
end

% Extract results into separate variables 
lumpedAllResultsTable = lumpedResults.AllResultsTable;
lumpedAllResultsInhTable = lumpedResults.AllResultsInhTable;
lumpedAllResultsExcTable = lumpedResults.AllResultsExcTable;


end % function end 