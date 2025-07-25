function  [Seizures] = countSeizures(allDataBases)

whatMice = unique(allDataBases.MouseID); % mice for this specific brain structure
SeizuresCount = zeros(length(whatMice),1); % initiate variable for storing 

for iMouse = 1:length(whatMice)
    targetMouse = whatMice{iMouse}; % extract the ID 
    MouseIndex = strcmp(allDataBases.MouseID,targetMouse); % index in the list of all mice 
    MouseDatabase = allDataBases(MouseIndex,:); % extract data for one mouse 
    seizures = unique(MouseDatabase.SeizureNumber); % 
    numSeizures = size(seizures,1); % how many seizures are there 
    SeizuresCount(iMouse) = numSeizures; % assign # of seizures to the mouse 
end
% create a table 
Seizures = table(whatMice,SeizuresCount); 

display(Seizures)
TotalNoOfSeizures = sum(Seizures.SeizuresCount); 
display(TotalNoOfSeizures)
end