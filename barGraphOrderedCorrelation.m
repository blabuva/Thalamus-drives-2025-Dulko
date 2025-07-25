function barGraphOrderedCorrelation(numStructures, difference, whatStructures, binSize) 
% parent function: MasterCodeSynchrony_241109.m

% Calculate mean values for each structure and filter out structures with mean = 0
meanValues = nan(numStructures, 1);
validIndices = []; % To store indices of structures with mean != 0
for iStructure = 1:numStructures
    values = difference(iStructure, :); % Extract the values for the current brain structure
    values = values(~isnan(values) & values ~= 0); % Filter out NaN and zero values
    meanValues(iStructure) = mean(values); % Calculate the mean
    if meanValues(iStructure) ~= 0
        validIndices = [validIndices, iStructure]; % Store valid indices
    end
end

% Filter data and sort by mean values
meanValues = meanValues(validIndices); % Only keep valid mean values
[sortedMeans, sortIdx] = sort(meanValues); % Sort the mean values (ascending)
sortedStructures = whatStructures(validIndices(sortIdx)); % Sort structure names
sortedDifference = difference(validIndices(sortIdx), :); % Sort the difference matrix

% Generate a colormap from parula with the same number of colors as structures
numColors = length(sortedMeans);
barColors = turbo(numColors); % Generate colors for the bars

% Initialize a figure for the plot
figure;
hold on;

% Loop through each brain structure (sorted order)
for iSorted = 1:numColors
    values = sortedDifference(iSorted, :); % Extract the values for the current structure
    values = values(~isnan(values) & values ~= 0); % Filter out NaN and zero values

    % Plot mean difference as a bar graph
    meanValue = sortedMeans(iSorted);
    bar(iSorted, meanValue, 'FaceColor', barColors(iSorted, :)); % Set bar color using colormap
    
    % Make a brighter version of the bar color for the dots
    dotColor = min(barColors(iSorted, :) + 0.3, 1); % Increase brightness (capped at 1)
    
    % Plot the values as dots with black borders
    scatter(repmat(iSorted, size(values)), values, 'filled', ...
        'MarkerFaceColor', dotColor, 'MarkerEdgeColor', 'k'); % Add black borders
end

% Set plot aesthetics
xlabel('Brain Structure');
ylabel('Difference Value');
ylim([-0.1 0.5]); 
title('Dot Plot of Difference Values Grouped by Brain Structure (Sorted)');
xticks(1:numColors);  % Set x-axis ticks to match the sorted brain structures
xticklabels(sortedStructures);  % Set x-axis labels to sorted structure names
xlim([0, numColors + 1]);  % Set x-axis limits
hold off;

display(binSize)

end