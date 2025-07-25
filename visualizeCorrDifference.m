function [allValuesDifference,MeanDifference] = visualizeCorrDifference(numSeizures,MeanCorrelations,MeanCorrelationsNonSWSs,numUniqueStr,UniqueStructures)
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m

% Prepare data for plotting

% Prepare data for plotting
x = 1:numSeizures; % X-axis: Seizure indices

% Create a figure with specific size
figure('Units', 'centimeters', 'Position', [0, 0, 29.7, 29.7]); % Increased height for 3 rows of subplots

%% PLOT SEIZURE DATA FIRST
% Subplot 1: Line Graph
subplot(2,3,2); % Line graph
hold on;
allValuesSeizures = []; % This will be used for a heatmap
labelsSeizures = {}; % Labels for legend and heatmap rows

% Loop through each row in the table (each structure pair)
for row = 1:height(MeanCorrelations)
    % Extract mean correlation values for all seizures
    y = cell2mat(MeanCorrelations(row, 3:end)); % Columns 3 to end contain the seizure data
    allValuesSeizures = [allValuesSeizures; y]; 

    % Generate label for this row (e.g., "Dentate_Gyrus - CA1")
    structure1 = MeanCorrelations{row, 1};
    structure2 = MeanCorrelations{row, 2};
    label = strcat(structure1, ' - ', structure2);
    labelsSeizures{end+1} = label; % Add to labels

    % Plot a line for this structure pair
    plot(x, y, '-o', 'DisplayName', label); % Add label to the line
end

% Customize the line plot
xlabel('Seizure Number'); ylabel('Mean Correlation'); title('Mean Correlations Across Seizures');
legend('off'); %legend('show', 'Location', 'bestoutside'); % Add a legend to identify structure pairs
ylim([0 1]); grid on; hold off;

% Subplot 2: Heatmap
subplot(2,3,5); % Heatmap
h = heatmap(allValuesSeizures); 
colormap(hot); 
h.ColorLimits = [0 1];
ylabel('Structure Pair');
title('Heatmap of Mean Correlations (Seizures)');
%h.YDisplayLabels = labelsSeizures; % Assign labels to heatmap rows

%% PLOT NON-SEIZURE DATA NEXT
subplot(2,3,1); % Line graph for non-seizures
hold on;
allValuesNonSWSs = []; % This will be used for a heatmap
labelsNonSWSs = {}; % Labels for legend and heatmap rows

% Loop through each row in the table (each structure pair)
for row = 1:height(MeanCorrelationsNonSWSs)
    % Extract mean correlation values for non-seizures
    y = cell2mat(MeanCorrelationsNonSWSs(row, 3:end)); % Columns 3 to end contain the non-seizure data
    allValuesNonSWSs = [allValuesNonSWSs; y]; 

    % Generate label for this row (e.g., "Dentate_Gyrus - CA1")
    structure1 = MeanCorrelationsNonSWSs{row, 1};
    structure2 = MeanCorrelationsNonSWSs{row, 2};
    label = strcat(structure1, ' - ', structure2);
    labelsNonSWSs{end+1} = label; % Add to labels

    % Plot a line for this structure pair
    plot(x, y, '-o', 'DisplayName', label); % Add label to the line
end

% Customize the line plot
xlabel('Seizure Number'); ylabel('Mean Correlation'); title('Mean Correlations Across Non-Seizures');
legend('off'); %legend('show', 'Location', 'bestoutside'); % Add a legend to identify structure pairs
ylim([0 1]); grid on; hold off;

% Subplot 4: Heatmap
subplot(2,3,4); % Heatmap
h = heatmap(allValuesNonSWSs); 
colormap(hot); 
h.ColorLimits = [0 1];
ylabel('Structure Pair');
title('Heatmap of Mean Correlations (Non-Seizures)');
h.YDisplayLabels = labelsNonSWSs; % Assign labels to heatmap rows

%% PLOT DIFFERENCE (SEIZURES - NON-SEIZURES)
% Calculate the difference
if isequal(size(allValuesSeizures), size(allValuesNonSWSs))
    allValuesDifference = allValuesSeizures - allValuesNonSWSs; % Element-wise difference
else
    error('MeanCorrelations and MeanCorrelationsNonSWSs must have the same size for difference calculation.');
end


% Subplot 6: Heatmap for difference
subplot(2,3,6); % Heatmap
h = heatmap(allValuesDifference); 
colormap(hot); 
h.ColorLimits = [0 1]; % Allow for negative differences
ylabel('Structure Pair');
title('Difference (Seizures - Non-Seizures)');
%h.YDisplayLabels = labelsSeizures; % Use labels from seizures (assuming the same structures)


%% Store allValuesDifference 
% Initialize results with structure pairs and seizure columns
MeanDifference = cell(nchoosek(numUniqueStr, 2), 2 + numSeizures); % Preallocate

% Populate the first two columns with all unique structure pairs
row = 1;
for i = 1:numUniqueStr
    for j = i+1:numUniqueStr % Ensure j > i 
        if i == j
            continue; % Skip comparisons within the same structure
        end
        MeanDifference{row, 1} = UniqueStructures{i};
        MeanDifference{row, 2} = UniqueStructures{j};
        row = row + 1;
    end
end

% Ensure MeanDifference is a cell array and allValues is a matrix
if iscell(MeanDifference) && isnumeric(allValuesDifference)
    % Assign allValues to columns 3 to 20 of MeanDifference
    MeanDifference(:, 3:end) = num2cell(allValuesDifference);
else
    error('MeanDifference must be a cell array and allValuesDifference must be a numeric matrix.');
end



end % function end 