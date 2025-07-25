function [whatStructures,allDataBases] = LumpStructuresForSynchronyCode(allDataBases)

originalDB = allDataBases;
structureLumper = readtable('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;
for iRow = 1:size(originalDB,1)
    currentStructure= strrep(originalDB.Structure{iRow}, ' ', '_') ;
    originalDB.LumpedStructure{iRow} = structureLumper.KeepAs_name__Don_tAnalyse(find(contains(structureLumper.NameUsedByCode, currentStructure))) ;
end

% What structures are in this database: 
uniqueStructuresAll = {}; % Initialize an empty cell array to store unique structures

% Iterate over each cell in originalDB.LumpedStructure
for i = 1:numel(originalDB.LumpedStructure)
    innerCell = originalDB.LumpedStructure{i}; % Extract the inner cell content
    stringArray = string(innerCell);  % Convert cell array elements to strings
    uniqueStructuresCell = unique(stringArray); % Extract unique strings from the current cell  
    uniqueStructuresAll = [uniqueStructuresAll; uniqueStructuresCell]; % Append unique structures from the current cell to the overall list
end
% change the name from originalDB to allDataBases 
allDataBases = originalDB; % allDataBases should have 25 columns now 

uniqueBrainStructures = unique(uniqueStructuresAll); % Extract unique structures from the combined list
whatStructures = cellstr(uniqueBrainStructures); % change strings to cells

end 