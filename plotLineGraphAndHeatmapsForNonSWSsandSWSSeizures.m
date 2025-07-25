function plotLineGraphAndHeatmapsForNonSWSsandSWSSeizures(MeanCorrelations,MeanCorrelationsNonSWSs,numSeizures)
% for visualizing mean correlation values in one recording 
% parent function MasterCodeBetweenNucleiCorrelation_2025_01_21.m 

% Prepare data for plotting
x = 1:numSeizures; % X-axis: Seizure indices

% Create a figure with specific size
figure('Units', 'centimeters', 'Position', [0, 0, 29.7, 21.0]);
%% PLOT SEIZURE DATA FIRST 
% Subplot 1: Line Graph
subplot(2,2,2); % Line graph
    hold on;
    allValues = []; % This will be used for a heatmap
    labels = {}; % Labels for legend and heatmap rows
    
    % Loop through each row in the table (each structure pair)
    for row = 1:height(MeanCorrelations)
        % Extract mean correlation values for all seizures
        y = cell2mat(MeanCorrelations(row, 3:end)); % Columns 3 to end contain the seizure data
        allValues = [allValues; y]; 
    
        % Generate label for this row (e.g., "Dentate_Gyrus - CA1")
        structure1 = MeanCorrelations{row, 1};
        structure2 = MeanCorrelations{row, 2};
        label = strcat(structure1, ' - ', structure2);
        labels{end+1} = label; % Add to labels
    
        % Plot a line for this structure pair
        plot(x, y, '-o', 'DisplayName', label); % Add label to the line
    end
    
    % Customize the line plot
    xlabel('Seizure Number'); ylabel('Mean Correlation'); title('Mean Correlations Across Seizures');
    legend('off'); %legend('show', 'Location', 'bestoutside'); % Add a legend to identify structure pairs
    ylim([0 1]); grid on; hold off;

% Subplot 2: Heatmap
    subplot(2,2,4); % Heatmap
    h = heatmap(allValues); 
    colormap(hot); 
    h.ColorLimits = ([0 1]); %clim([0 1]); xlabel('Seizure Number');
    ylabel('Structure Pair');
    title('Heatmap of Mean Correlations');
    h.YDisplayLabels = labels; % Assign labels to heatmap rows

%%  PLOT NON SEIZURE DATA NEXT 

subplot(2,2,1); % Line graph for non seizures 
    hold on;
    allValues = []; % This will be used for a heatmap
    labels = {}; % Labels for legend and heatmap rows
    
    % Loop through each row in the table (each structure pair)
    for row = 1:height(MeanCorrelationsNonSWSs)
        % Extract mean correlation values for all seizures
        y = cell2mat(MeanCorrelationsNonSWSs(row, 3:end)); % Columns 3 to end contain the seizure data
        allValues = [allValues; y]; 
    
        % Generate label for this row (e.g., "Dentate_Gyrus - CA1")
        structure1 = MeanCorrelationsNonSWSs{row, 1};
        structure2 = MeanCorrelationsNonSWSs{row, 2};
        label = strcat(structure1, ' - ', structure2);
        labels{end+1} = label; % Add to labels
    
        % Plot a line for this structure pair
        plot(x, y, '-o', 'DisplayName', label); % Add label to the line
    end
    
    % Customize the line plot
    xlabel('Seizure Number'); ylabel('Mean Correlation'); title('Mean Correlations Across Non Seizures');
    legend('off'); %legend('show', 'Location', 'bestoutside'); % Add a legend to identify structure pairs
    ylim([0 1]); grid on; hold off;

% Subplot 2: Heatmap
    subplot(2,2,3); % Heatmap
    h = heatmap(allValues); 
    colormap(hot); 
    h.ColorLimits = ([0 1]); %clim([0 1]); xlabel('Seizure Number');
    ylabel('Structure Pair');
    title('Heatmap of Mean Correlations');
    h.YDisplayLabels = labels; % Assign labels to heatmap rows


end % function end 