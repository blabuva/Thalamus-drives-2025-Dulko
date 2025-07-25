function [TIME,highRatioIndices,numHighRatios] = phaseLocked(RATIOS,RatioThreshold,MeansAllMice,labelsBigTable)
% parent function: Phase_ela.m

% Identify the structures with ratios higher than RatioThreshold
highRatioIndices = find(RATIOS > RatioThreshold);
numHighRatios = length(highRatioIndices);

TIME = zeros(numHighRatios,2); % initialize to store time when the peak occurs

% Create a new figure with subplots for selected structures
fig = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);

for i = 1:numHighRatios
    iStructure = highRatioIndices(i);
    currentRow = MeansAllMice(iStructure,:);

    subplot(numHighRatios, 1, i);
    darkGrayColor = [0.1 0.1 0.1]; % Dark gray RGB triplet
    bar(currentRow,'FaceColor',darkGrayColor);
    hold on;

    % Smooth data and plot smoothed as red line on the top of the histogram
    winSize = 6;
    smoothed = smoothdata(currentRow, 'gaussian', winSize);
    plot(smoothed, 'r', 'LineWidth', 2);
    % PEAK 1 - FIRST part of the analyzed time 
        Peak1 = max(smoothed(:,1:40));
        columnIndex1 = find(smoothed(:,1:40) == Peak1); % at what time does the peak occur??
        TIME(i,1) = columnIndex1;% store column index to order histograms accordingly
    % PEAK 2 - SECOND part of the analyzed time 
        Peak2 = max(smoothed(:,41:80));
        columnIndex2 = find(smoothed(:,41:80) == Peak2); % at what time does the peak occur??
        TIME(i,2) = columnIndex2;% store column index to order histograms accordingly 
    % Display the ratio
    Ratio = RATIOS(iStructure);
    title(['Peak to valley ratio: ', num2str(Ratio)]);
    xlabel('Bins)');
    ylabel('Mean Spike Count');

    % Set the title for each brain structure
    extractedTitle = labelsBigTable(iStructure);
    titleText = [num2str(extractedTitle{1,1})]; % set the title of the raster as name of brain structure
    xLimits = xlim;
    yLimits = ylim;
    text(xLimits(2) + 1, mean(yLimits), titleText, 'Rotation', 0, 'HorizontalAlignment', 'left');

    hold off;
end
% Set the title for the entire figure
sgtitle('Brain Structures with High Ratios');
end
