function [SingleUnits] = countUnits(allDataBases,whatStructures,mouseIDs)

% initiate table for storing the number of neurons per brain structure 
numStructures = length(whatStructures);
neuronsPerStructure = zeros(numStructures,1);

for iStructure = 1:numStructures
    targetStructure = whatStructures{iStructure}; 
    [StructureDatabase] = indexToOneBrainStructure(allDataBases,targetStructure); % index to one brain structure 
    [filteredStructureDatabase] = filterOutRowsWithoutSUs(StructureDatabase); % filter out the rows where there is no single units 

    localMice = unique(filteredStructureDatabase.MouseID); % mice in this brain structure;
    numMice = size(localMice,1); % how many mice? 
    AllNeuronsPerMouse = []; 
    for iMouse = 1:length(localMice)
        display(iMouse)
        BigMouse = strcmp(mouseIDs,localMice{iMouse}); % index in the list of all mice 
        MouseIndex = find(BigMouse); 
        logicalIndex = strcmp(filteredStructureDatabase.MouseID,localMice{iMouse}); % 
        StructureMouseDatabase = filteredStructureDatabase(logicalIndex,:); 
        % only 1st seizure because the number of neurons is the same across
        % all seizures
        data = StructureMouseDatabase.SingleUnitsAll{1,1}.all.CurrentSWD; 
        numNeurons = size(data,1); 
        AllNeuronsPerMouse = [AllNeuronsPerMouse,numNeurons]; 
    end
    neuronsPerStructure(iStructure,1) = sum(AllNeuronsPerMouse(:,:)); 
    NumMice(iStructure,1) = numMice; 
end
% make and display the table that summarizes the number of single units and mice per
% brain structure 
SingleUnits = table(whatStructures,neuronsPerStructure,NumMice); 
display(SingleUnits)




