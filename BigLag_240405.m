function  [originalDB,numMice,whatMice] = BigLag_240405(logicalIndexStrain,allDataBases) % ver updated 2024-07-29 

% This code grabs allDataBase (multiple mice combined), and then: 
% extracts one strain, lumps brain structures together if necessary, and 
% gives information like number of mice and mice IDs 

allDataBases = allDataBases(logicalIndexStrain, :); % now allDataBases includes one strain

%% Lump structures based on Mark's code;
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

% Extract unique structures from the combined list
uniqueBrainStructures = unique(uniqueStructuresAll);

% Mice and bin size 
whatMice = unique(originalDB.MouseID); % what mice are here 
numMice = length(whatMice); % how many mice are here

end 