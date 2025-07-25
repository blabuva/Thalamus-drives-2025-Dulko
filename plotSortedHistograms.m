function [sortedLocked,sortedLockedStructureNames] = plotSortedHistograms(TIME,MeansAllMice,RATIOS,labelsBigTable,numHighRatios,highRatioIndices, howFarBack, howFarInto,AvgEEGAllMice,XaxisLim)
% parent function: Phase_ela.m

sortedLocked = []; % initiate to store values (will be exported and plotted in R) 
sortedLockedStructureNames = []; % initiate to store the name of brain structures 

% Sort indices based on peak times
%[~, sortedIndices] = sort(TIME(:,2)); % sort according to 2nd peaks (real seizure start) 

% sort based on the ratio value (HIGHEST ---> LOWEST) 
% filter to only keep RATIOS that are high 
RATIOSfiltered = RATIOS(highRatioIndices,:); 
[~, sortedIndices] = sort(RATIOSfiltered,'descend'); 

% Create a new figure with sorted subplots
figSorted = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);
meanEEG = mean(AvgEEGAllMice,1); 
subplot(numHighRatios+1,1,1); 
plot(meanEEG,'LineWidth',2,'Color','k'); % plot average EEG across all mice 
xlim([0,XaxisLim]); % stretch EEG 

for i = 1:numHighRatios
    sortedStructureIndex = highRatioIndices(sortedIndices(i));
    currentRow = MeansAllMice(sortedStructureIndex,:);
    
    % append this row in "sortedLocked" 
    sortedLocked = [sortedLocked; currentRow]; 

    subplot(numHighRatios+1, 1, i+1);
    darkGrayColor = [0.1 0.1 0.1]; % Dark gray RGB triplet
    bar(currentRow,'FaceColor',darkGrayColor)
    %bar(currentRow);
    hold on;

    % Smooth data and plot smoothed as red line on the top of the histogram
    % winSize = 6;
    % smoothed = smoothdata(currentRow, 'gaussian', winSize);
    % plot(smoothed, 'r', 'LineWidth', 2);
    %     % P E A K   1 
    %     Peak1 = max(smoothed(:,1:40));  % Plot the location of peak 1 
    %     columnIndex1 = find(smoothed == Peak1);
    %     % Plot a vertical line at the peak location 
    %     yLimits = ylim;
    %     line([columnIndex1 columnIndex1], yLimits, 'Color', 'c', 'LineWidth', 4, 'LineStyle', '-');
    %     % P E A K   2 
    %     Peak2 = max(smoothed(:,41:80));  % Plot the location of peak 1 
    %     columnIndex2 = find(smoothed == Peak2);
    %     % Plot a vertical line at the peak location 
    %     yLimits = ylim;
    %     line([columnIndex2 columnIndex2], yLimits, 'Color', 'g', 'LineWidth', 4, 'LineStyle', '-');
    % % Display the ratio
    Ratio = RATIOS(sortedStructureIndex);
    title(['Peak to valley ratio: ', num2str(Ratio)]);
    % xlabel('Time to first trough (ms)');
    %ylabel('Mean Spike Count');

    % Set the title for each brain structure
    extractedTitle = labelsBigTable(sortedStructureIndex);
    sortedLockedStructureNames = [sortedLockedStructureNames,extractedTitle]; 

    titleText = [num2str(extractedTitle{1,1})]; % set the title of the raster as name of brain structure
    xLimits = xlim;
    yLimits = ylim;
    text(xLimits(2) + 1, mean(yLimits), titleText, 'Rotation', 0, 'HorizontalAlignment', 'left');
    % set the x axis ticks to relfect time to seizure start 
    numBins = length(currentRow);
    xTicks = linspace(1, numBins, 5); % 5 tick marks
    xTickLabels = linspace(-howFarBack, howFarInto, 5); % Labels from -300 ms to 100 ms
    set(gca, 'XTick', xTicks, 'XTickLabel', xTickLabels);
    hold off;
end

% Set the title for the entire figure
sgtitle('Brain Structures with High Ratios Ordered by Peak Time');
end