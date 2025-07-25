function [reorderedAllFieldsLabels] = orderedHeatmap(homeFolder, heatmapLabels,newHeatmapLabels,allFields,f)
% parent function: StartHere.m

% Initialize the reordered matrix for all fields and labels 
reorderedAllFields = [];
reorderedAllFieldsLabels = [];

% Loop through newHeatmapLabels and find corresponding columns in allFields
for iStruct = 1:length(newHeatmapLabels)
    % Extract the current brain structure name (before the dash)
    currentStruct = newHeatmapLabels{iStruct};

    % Find the columns in allFields corresponding to this brain structure
    matchingCols = find(contains(heatmapLabels, currentStruct));

    % Append these columns to reorderedAllFields
    reorderedAllFields = [reorderedAllFields, allFields(:, matchingCols)];

    % extract the name for these columns and store in
    % "reorderedAllFieldsLabels" and append:
    reorderedAllFieldsLabels = [reorderedAllFieldsLabels;  heatmapLabels(matchingCols,:)]; % Store as a cell array of strings
end

% At this point, reorderedAllFields contains the data re-ordered by the
% brain structure coherence values.


% Now plot the reordered allFields as a heatmap
fig = figure;
    imagesc(reorderedAllFields'); % Transpose to match orientation
    colormap("hot");
    caxis([0 0.5]); % Adjust color axis as needed
    colorbar;
    
    % Adjust x and y axis labels
    xlim([0 32]); % Assuming you have 53 frequency bins (adjust as necessary)
    %xticks(1:53);
    %xticklabels(f(1:53)); % Replace 'f' with your actual frequency values
    newXTickValues = 0:2.5:30; % 0 to 50 with 2.5 Hz step 
    xticks(linspace(1, 32, length(newXTickValues))); % Set tick positions evenly
    xticklabels(newXTickValues); % Label the ticks with 0, 2.5, 5, 7.5, ..., 50 Hz
   

    % Set y-ticks and apply the sorted labels as y-axis labels with 'Interpreter', 'none'
    yticks(1:length(reorderedAllFieldsLabels));
    set(gca, 'YTickLabel', reorderedAllFieldsLabels, 'TickLabelInterpreter', 'none');
    
    xlabel('Frequency in Hz');
    ylabel('Brain Structures');
    title('Brain Structure ordered based on mean coherence');


    % save the figure 
    % figFileName = fullfile(mouseFolderPath, ['Spectra_' num2str(iSeizure) '.fig']);
    svgFileName = fullfile(homeFolder, ['OrderedHeatmap.svg']);
    %pngFileName = fullfile(homeFolder, ['Spectra_' num2str(iSeizure) '.png']);
    
    % savefig(figFileName); % Save the figure in .fig format
    saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
    %print(figure, pngFileName, '-dpng', '-r600'); % '-r600' sets the resolution to 600 dpi% Save the figure in .png format
    
    % Check if fig is a valid handle before closing
    if ishandle(fig)
        close(fig); % Close the figure
    end

end