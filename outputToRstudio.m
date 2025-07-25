function outputToRstudio(sortedLocked,sortedNotLocked,sortedLockedStructureNames,sortedNotLockedStructureNames,numBins)
% parent function: Phase_ela.m

% combine the names 
brainStructures = [sortedLockedStructureNames';sortedNotLockedStructureNames']; 

% combine the values 
spikeCounts = [sortedLocked;sortedNotLocked]; 

%% Normalize before exporting 
minVals = min(spikeCounts, [], 2); % Minimum per row
maxVals = max(spikeCounts, [], 2); % Maximum per row
normalizedCounts = (spikeCounts - minVals) ./ (maxVals - minVals); % Normalize to [0,1]

brainStructuresTable = cell2table(brainStructures, 'VariableNames', {'BrainStructure'}); % Convert brain structure names to a table
spikeCountsTable = array2table(normalizedCounts, 'VariableNames', compose('Trial%d', 1:numBins)); % Convert normalized spike counts to a table
finalTable = [brainStructuresTable, spikeCountsTable]; % Combine both tables

%% Save as excel file 
% Gria4 
%writetable(finalTable, '/media/elaX/Publications/Figures/Figure4_PhaseForGria/RstudioPlots/NormalizedSpikeCounts1stCycleOnly.xlsx');
% STG 
writetable(finalTable, '/media/elaX/Publications/Figures/SuppFigure4_PhaseNonSeizures/STGphase/NormalizedCountsFirstCycle_STG.xlsx');
end 