function [avgNumberSeizures] = calcSeizureFrequency(animalData,recDurations) 


% parent function:  SeizureFeaturesMaster_2024_08_29

% INPUT: 
% recLength - recording length in minutes
% OUTPUT: 
% avgNumberSeizures - # of seizures / minute for each mouse 

miceIDs = unique(animalData.MouseID); 

avgNumberSeizures = [];
for iMouse = 1:size(miceIDs,1)
        % figure out the recording length for this mouse 
        index = strcmp(recDurations.Var1,miceIDs{iMouse}); % index to the right mouse 
        RecordingLength = recDurations.Var2(index,1); 

       % index to one mouse  
        targetMouse = miceIDs{iMouse};
        ind = strcmp(animalData.MouseID,targetMouse);
        mouseData = animalData(ind,:); 
        % find the number of seizures 
        numSeizures = length(unique(mouseData.SeizureNumber));
        avgNumber = numSeizures/RecordingLength;
        avgNumberSeizures = [avgNumberSeizures;avgNumber];  

        % Plot seizures as separate figures for this mouse 
        %plotSeizureExamples(mouseData); 
end


           
end
