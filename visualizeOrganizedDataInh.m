function visualizeOrganizedDataInh(organizedDataInh,uniqueStructures)
% parent function: masterInhPlotter.m 

% plots bar graphs for all structures (one figure for non seizures and one
% for seizures) 

numSubplots = size(organizedDataInh,1);

figure; % for non seizures
sgtitle('Non-SWDs');
for iUniqBrain = 1:numSubplots 
    currentStructure = uniqueStructures{iUniqBrain}; % which structure now 
    values = organizedDataInh{iUniqBrain,2}; % extract NON seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'b'); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left
    xlim([0 100]); 
end



figure; % for seizures 
sgtitle('SWDs');
for iUniqBrain = 1:numSubplots 
    currentStructure = uniqueStructures{iUniqBrain}; % which structure now 
    values = organizedDataInh{iUniqBrain,3}; % extract seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'k'); 
    xlim([0 100]); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left

end

 

end 
