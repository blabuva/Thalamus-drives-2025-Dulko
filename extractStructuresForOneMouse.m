function [whatStructures] = extractStructuresForOneMouse(MouseDatabase)
% parent function: StartHere.m

% Assuming MouseDatabase.LumpedStructure is a cell array containing unique structure names
LumpedStructure = MouseDatabase.LumpedStructure;

% Initialize an empty cell array to store unique structure names
uniqueNames = {};

% Loop through each cell in LumpedStructure
for i = 1:numel(LumpedStructure)
    % Get the inner cell containing the structure name
    innerCell = LumpedStructure{i};
    % Check if the inner cell is not empty and contains a single element
    if ~isempty(innerCell) && numel(innerCell) == 1
        % Get the structure name from the inner cell and add it to uniqueNames
        structureName = innerCell{1};
        uniqueNames{end+1} = structureName;
    end
end

% Display unique structure names
disp('Unique Structure Names:');
disp(uniqueNames');

whatStructures = unique(uniqueNames)

end



