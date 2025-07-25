function [sortedNotLocked,sortedNotLockedStructureNames] = NOTphaseLocked(RATIOS,RatioThreshold,MeansAllMice,labelsBigTable,howFarBack,howFarInto)
% parent function: Phase_ela.m

% Identify the structures with ratios higher than 5
    lowRatioIndices = find(RATIOS <= RatioThreshold);
    numLowRatios = length(lowRatioIndices);
   
    TIME = zeros(numLowRatios,2); % initialize to store time when the peak occurs

    % Create a new figure with subplots for selected structures
    fig = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);
    
    for i = 1:numLowRatios
        iStructure = lowRatioIndices(i);
        currentRow = MeansAllMice(iStructure,:); 
        
        subplot(numLowRatios, 1, i); 
        bar(currentRow);
        hold on; 
        
        % Smooth data and plot smoothed as red line on the top of the histogram
        winSize = 6;
        smoothed = smoothdata(currentRow, 'gaussian', winSize); 
        plot(smoothed, 'r', 'LineWidth', 2);
      
        % Store times of peak (300 ms before the seizure) and at the time
        % of the high amplitude peak 
        % PEAK 1 - FIRST part of the analyzed time 
            Peak1 = max(smoothed(:,1:40));
            columnIndex1 = find(smoothed(:,1:40) == Peak1); % at what time does the peak occur??
            % sometimes it can't find time because there was no firing 
            if size(columnIndex1,2)>1 
                columnIndex1 = 80; % just put 80 so it goes to the end 
            end
            TIME(i,1) = columnIndex1;% store column index to order histograms accordingly
            
        % PEAK 2 - SECOND part of the analyzed time 
            Peak2 = max(smoothed(:,41:80));
            columnIndex2 = find(smoothed(:,41:80) == Peak2); % at what time does the peak occur??
            if size(columnIndex2,2) >1 
                columnIndex2 = 80 ;
            end
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
    sgtitle('Brain Structures with Low Ratios');


    %% plot again but now plot them sorted based on the peak
    % Sort indices based on peak times
    [~, sortedIndices] = sort(TIME(:,2)); % sort according to 2nd peaks (real seizure start)

    % initiate "sortedNotLocked" to store all values and output 
    sortedNotLocked = []; 
    % initiate to store names of brain structures 
    sortedNotLockedStructureNames = []; 

    % Create a new figure with subplots for selected structures
    figSorted = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);

    for i = 1:numLowRatios
        sortedStructureIndex = lowRatioIndices(sortedIndices(i));
        currentRow = MeansAllMice(sortedStructureIndex,:);
        
        % store (function output) 
        sortedNotLocked = [sortedNotLocked;currentRow];

        % Set the title for each brain structure
        extractedTitle = labelsBigTable(sortedStructureIndex);
    
        % store the brain structure name 
        sortedNotLockedStructureNames = [sortedNotLockedStructureNames,extractedTitle]; 


        subplot(numLowRatios, 1, i);
        darkGrayColor = [0.1 0.1 0.1]; % Dark gray RGB triplet
        bar(currentRow,'FaceColor',darkGrayColor)
        %bar(currentRow);
        hold on;

        % Smooth data and plot smoothed as red line on the top of the histogram
        winSize = 6;
        smoothed = smoothdata(currentRow, 'gaussian', winSize);
        plot(smoothed, 'r', 'LineWidth', 2);
        % P E A K   1
        Peak1 = max(smoothed(:,1:40));  % Plot the location of peak 1
        columnIndex1 = find(smoothed == Peak1);
        % Plot a vertical line at the peak location
        yLimits = ylim;
        % if length(columnIndex1) == 1  
        %     line([columnIndex1 columnIndex1], yLimits, 'Color', 'c', 'LineWidth', 4, 'LineStyle', '-');
        % 
        % else 
        %     continue 
        % end
        %     % P E A K   2
        % Peak2 = max(smoothed(:,41:80));  % Plot the location of peak 1
        % columnIndex2 = find(smoothed == Peak2);
        % Plot a vertical line at the peak location
        yLimits = ylim;
        
        % line([columnIndex2 columnIndex2], yLimits, 'Color', 'g', 'LineWidth', 4, 'LineStyle', '-');
        % % Display the ratio
        Ratio = RATIOS(sortedStructureIndex);
        title(['Peak to valley ratio: ', num2str(Ratio)]);
        % xlabel('Time to first trough (ms)');
        ylabel('Mean Spike Count');

        % Set the title for each brain structure
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


end



