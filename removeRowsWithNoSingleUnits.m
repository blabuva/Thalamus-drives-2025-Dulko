function MouseDatabase = removeRowsWithNoSingleUnits(MouseDatabase)

% Initialize a logical index to identify rows to keep
rowsToKeep = false(size(MouseDatabase, 1), 1);

% Loop through each row to check the number of single units
for iRow = 1:size(MouseDatabase,1)
    
    oneRow = MouseDatabase.SingleUnitsSWD{iRow,1}.all; 
    numSUs = size(oneRow,1); % check the number of single units 
    
    if numSUs > 0
        rowsToKeep(iRow) = true; % Mark rows with single units to keep
    end

end 


% Filter MouseDatabase to only include rows to keep
MouseDatabase = MouseDatabase(rowsToKeep, :);

end 
   