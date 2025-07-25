function  [StructureDatabase] = indexToOneBrainStructure(allDataBases,targetStructure) 

LumpedStructure = allDataBases.LumpedStructure; 

% Initialize logical index array
logicalIndex = false(size(LumpedStructure));

% Loop through each cell in LumpedStructure to compare with targetStructure
for i = 1:numel(LumpedStructure)
    innerCell = LumpedStructure{i};
    if ~isempty(innerCell) && numel(innerCell) == 1
        % Compare the inner cell content with the target structure
        if strcmp(innerCell{1}, targetStructure)
            logicalIndex(i) = true;
        end
    end
end

% Display logicalIndex
disp(logicalIndex);
 
StructureDatabase = allDataBases(logicalIndex, :);

end 