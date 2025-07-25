function [avgDuration,avgCycleDuration,AvgNumCycles] = calcSeizureDuration(animalData) 

% parent function:  SeizureFeaturesMaster_2024_08_29

% INPUT: 
% data for all mice 
% OUTPUT: 
% avgDuration - seizure duration in seconds 
% avgCycleDuration (in seconds) calculated based on all seizures for this
% mouse 

miceIDs = unique(animalData.MouseID); 

avgDuration = [];
avgCycleDuration = []; 
AvgNumCycles = []; 
for iMouse = 1:size(miceIDs,1)
        % index to one mouse  
        targetMouse = miceIDs{iMouse};
        ind = strcmp(animalData.MouseID,targetMouse);
        mouseData = animalData(ind,:); 
        % index to one brain structure - all of them will have the same
        % seizure info 
        whatStructures = unique(mouseData.Structure); 
        targetStructure = whatStructures{1}; % grab the first one 
        % focus on seizure duration 
        StructureIndex = strcmp(mouseData.Structure,targetStructure); 
        Structure = mouseData(StructureIndex,:); 
        AllDurations = Structure.SeizureDuration; % ALL DURATIONS (if needed for later) 
        avgDurationPerMouse = mean(AllDurations); % calculate average duration  
        avgDuration = [avgDuration; avgDurationPerMouse]; 
        % focus on cycle duration, loop through seizures 
        cycleDurationsOneMouse = []; % mean cycle duration for each seizure 
        numCyclesMouse = []; 
        for iSeizure = 1:size(Structure,1)
            cycles = Structure.SWD_Props{iSeizure,1}.SWD_troughTimes{1,1}; % extract cycle info for each seizure 
            differences = diff(cycles); 
            avgDifference = mean(differences); % calculate mean cycle length for 1 seizure 
            cycleDurationsOneMouse = [cycleDurationsOneMouse;avgDifference]; 
            % figure out the # of cycles 
            numCycles = size(cycles,1); 
            numCyclesMouse = [numCyclesMouse; numCycles]; 
        end
        avgCycleDurationMouse = mean(cycleDurationsOneMouse); % calculate one mean per mouse (in seconds) and store 
        avgCycleDuration = [avgCycleDuration; avgCycleDurationMouse]; % -> part of the output 
        meanNumCycles = mean(numCyclesMouse); % calculate one mean per mouse and store 
        AvgNumCycles = [AvgNumCycles; meanNumCycles]; % -> part of the output 
end


           
end

