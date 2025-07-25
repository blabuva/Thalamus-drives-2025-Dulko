function [MouseDatabase,numSeizures,whatSeizures] = reformatMouseDataBase(MouseDatabase,BadSeizuresIndices)
% parent function: Phase_ela.m

% BadSeizuresIndices; -> Seizure numbers that should be deleted

% Initialize a logical index array for rows to keep
rowsToKeep = true(size(MouseDatabase, 1), 1);

% Loop through each seizure number in the MouseDatabase table
for i = 1:size(MouseDatabase, 1)
    if ismember(MouseDatabase.SeizureNumber(i), BadSeizuresIndices)
        rowsToKeep(i) = false; % Mark row for deletion
    end
end

MouseDatabase = MouseDatabase(rowsToKeep, :); % Delete the rows that do not meet the criteria
whatSeizures = unique(MouseDatabase.SeizureNumber); % Extract new seizure IDs 
numSeizures = size(unique(MouseDatabase.SeizureNumber),1); % Recalculate the new number of seizures 

end 