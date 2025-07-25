function MouseDatabase = removeDontAnalyzeStructure(MouseDatabase) 
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m 

% Sometimes LumpedStructure is empty. The next few lines of code take care
% of this: 
    % Filter out empty rows
    nonEmptyIndices = cellfun(@(x) ~isempty(x) && ~isempty(x{1}), MouseDatabase.LumpedStructure);
    
    % Keep only non-empty entries
    nonEmptyMouseDatabase = MouseDatabase(nonEmptyIndices,:);

% Extract the strings from the non-empty, nested cell arrays
structureNames = cellfun(@(x) x{1}, nonEmptyMouseDatabase.LumpedStructure, 'UniformOutput', false);


% Extract the strings from the nested cell arrays
%structureNames = cellfun(@(x) x(1), MouseDatabase.LumpedStructure, 'UniformOutput', false);

% Find the rows where the structure is 'DontAnalyze'
DontAnalyzeIndex = strcmp(structureNames, 'DontAnalyze');

% Remove these rows from the database
nonEmptyMouseDatabase(DontAnalyzeIndex, :) = [];

MouseDatabase = nonEmptyMouseDatabase; 
 

end 