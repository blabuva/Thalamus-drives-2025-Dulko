function orderedDominantFrequencyOnly(heatmapLabels,newHeatmapLabels,allFields)
% parent function StartHere.m 

% DominantFrequency - rows (mice), columns (structures) 

% Initialize the reordered matrix for all fields and labels 
reorderedAllFieldsDF = [];
reorderedAllFieldsLabelsDF = [];

% Loop through newHeatmapLabels and find corresponding columns in allFields
for iStruct = 1:length(newHeatmapLabels)
    % Extract the current brain structure name (before the dash)
    currentStruct = newHeatmapLabels{iStruct};

    % Find the columns in allFields corresponding to this brain structure
    matchingCols = find(contains(heatmapLabels, currentStruct));

    % data: 
    data = allFields(matchingCols,:); 
    % Append these columns to reorderedAllFields
    reorderedAllFieldsDF = [reorderedAllFieldsDF; data];

    data = []; % clean before next step 

    % extract the name for these columns and store in
    % "reorderedAllFieldsLabels" and append:
    %reorderedAllFieldsLabels = [reorderedAllFieldsLabels;  heatmapLabels(matchingCols,:)]; % Store as a cell array of strings
end

%% Plot the figure 
figure;
imagesc(reorderedAllFieldsDF);
colorbar;

% Adjust x and y axis labels
xlim([0 32]); % Assuming you have 53 frequency bins (adjust as necessary)
%xticks(1:53);
%xticklabels(f(1:53)); % Replace 'f' with your actual frequency values
newXTickValues = 0:2.5:30; % 0 to 50 with 2.5 Hz step
xticks(linspace(1, 32, length(newXTickValues))); % Set tick positions evenly
xticklabels(newXTickValues); % Label the ticks with 0, 2.5, 5, 7.5, ..., 50 Hz


% Set y-ticks and apply the sorted labels as y-axis labels with 'Interpreter', 'none'
yticks(1:length(heatmapLabels));
set(gca, 'YTickLabel', heatmapLabels, 'TickLabelInterpreter', 'none');

xlabel('Frequency in Hz');
ylabel('Brain Structures');
title('Dom frequency for all brain structures ordered based on mean coherence');

% save the figure 
Path = '/media/elaX/Publications/Figures/Figure3_SpikeFieldCoherence'; 
svgFileName = fullfile(Path, ['DominantFrequencyOnly_ordered' '.svg']);        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format





end

