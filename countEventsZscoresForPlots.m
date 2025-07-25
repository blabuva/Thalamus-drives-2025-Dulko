function [sumSeizures,sumNeurons] = countEventsZscoresForPlots(StructureDatabase)

uniqueMice = unique(StructureDatabase.MouseID); 
numMice = size(uniqueMice,1);

totalNoSeizures = [];  % initiate the variable for collecting seizure numbers 
totalNoNeurons = []; % initiate the variable for collecting number of neurons 

% index to one mouse only 
for iMouse = 1:numMice
    mouseID = uniqueMice{iMouse};  
    OneMouseLog = strcmp(StructureDatabase.MouseID, mouseID);
    OneMouseDatabase = StructureDatabase(OneMouseLog,:); % keep only one mouse 
    % count seizures for each mouse  
        numSeizures = size(OneMouseDatabase,1); % how many seizures?
        totalNoSeizures = [totalNoSeizures,numSeizures]; % concatenate 
    % count the number of neurons (for the 1st seizure, becasue the number will be the same across all of them)  
        numNeurons = size(OneMouseDatabase.SingleUnitsAll{1,1}.all.CurrentSWD,1); 
        totalNoNeurons = [totalNoNeurons,numNeurons]; % concatenate 


end 

sumSeizures =  sum(totalNoSeizures(:,:)); 
sumNeurons = sum(totalNoNeurons(:,:)); 

end 