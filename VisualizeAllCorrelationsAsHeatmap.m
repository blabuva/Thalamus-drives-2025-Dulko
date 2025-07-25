function VisualizeAllCorrelationsAsHeatmap(CorrelationsDuringSWSs,CorrelationsDuringNonSWSs,Differences,combinations)  
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m

numColumns = 100; % pre-define how many columns to make (depends on the number of seizures
% total across all animals); if too small throws an error  

%% re-organize data for heatmap plotting 
% - SWS:
[CorrelationsCombinedBig,LabelsBigHeatmap] = prepareSWSdataForHeatmap(CorrelationsDuringSWSs,combinations,numColumns); 
% - nonSWS:
[CorrelationsCombinedBig_NonSWSs,LabelsBigHeatmap_NonSWSs] = prepareNonSWSdataForHeatmap(CorrelationsDuringNonSWSs,combinations,numColumns); 
% - difference: 
[DifferencesBig,LabelsBigHeatmap_Diff] = prepareDiffdataForHeatmap(Differences,combinations,numColumns); 

%%  Plot heatmaps without sorting (based on structure name - alphabetically): 
% - non seizures:  
figure; subplot(1,3,1); h = heatmap(CorrelationsCombinedBig_NonSWSs); h.Colormap = hot; h.ColorLimits = ([0 1]); grid("off"); 
h.Title = ('Non Seizures');h.YDisplayLabels = strcat(LabelsBigHeatmap_NonSWSs(:, 1), ' - ', LabelsBigHeatmap_NonSWSs(:, 2));
% - seizures: 
subplot(1,3,2); z = heatmap(CorrelationsCombinedBig); z.Colormap = hot; z.ColorLimits = ([0 1]); grid("off"); 
z.Title = ('Seizures'); %z.YDisplayLabels = strcat(LabelsBigHeatmap(:, 1), ' - ', LabelsBigHeatmap(:, 2));
% - difference: 
subplot(1,3,3); x = heatmap(DifferencesBig); x.Colormap = hot; x.ColorLimits = ([0 1]); grid("off"); 
x.Title = ('Difference'); %x.YDisplayLabels = strcat(LabelsBigHeatmap_Diff(:, 1), ' - ', LabelsBigHeatmap_Diff(:, 2));

%% Calculate the mean 
%  sort (highest mean to lowest) for difference: 
[DifferencesBigSorted,LabelsBigHeatmap_DiffSorted,sortIdx,rowMeans] = sortBasedOnHighestMean(DifferencesBig,LabelsBigHeatmap_Diff);
% Plot data as node graphs (with different thresholds) 
plotMultipleGraphs(rowMeans,LabelsBigHeatmap_DiffSorted); 

% Plot data sa node graphs including their anatomical location - DIFF ONLY 
PlotMultipleAnatomicalGraphs(LabelsBigHeatmap_DiffSorted,rowMeans); 

% Plot node graphs (non-seizures, seizures, difference) 
NodeGraphsByEventType(DifferencesBig,CorrelationsCombinedBig,CorrelationsCombinedBig_NonSWSs, rowsMeans); 




%% Plot sorted heatmaps  
% Plot sorted heatmap ( DIFFERENCES ) 
figure;
subplot(1,3,3); 
y = heatmap(DifferencesBigSorted); y.Colormap = hot;
y.ColorLimits = [0 1]; % Set the color limits to the range [0, 1]
xlabel(y, 'Seizure event'); % Use the xlabel function for the heatmap
%y.YDisplayLabels = strcat(LabelsBigHeatmap_DiffSorted(:, 1), ' - ', LabelsBigHeatmap_DiffSorted(:, 2));% Add the sorted Y-axis labels
title('Differences - sorted based on the mean corr'); 

% Sort + Plot sorted heatmap ( NON SEIZURES ) 
    % Rearrange the data and labels based on established order 
    CorrelationsCombinedBig_NonSwsSorted = CorrelationsCombinedBig_NonSWSs(sortIdx, :);
    LabelsBigHeatmap_NonSWSsSorted = LabelsBigHeatmap_NonSWSs(sortIdx,:);
    
    % Plot heatmap 
    %figure;
    subplot(1,3,1); % 1st heatmap
    a = heatmap(CorrelationsCombinedBig_NonSwsSorted); a.Colormap = hot;
    a.ColorLimits = [0 1]; % Set the color limits to the range [0, 1]
    xlabel(a, 'Seizure event'); % Use the xlabel function for the heatmap
    a.YDisplayLabels = strcat(LabelsBigHeatmap_NonSWSsSorted(:, 1), ' - ', LabelsBigHeatmap_NonSWSsSorted(:, 2));% Add the sorted Y-axis labels
    title('Non Seizures - sorted based on the mean difference'); 

% Sort + Plot sorted heatmap ( SEIZURES ) 
% Rearrange the data and labels based on established order 
    CorrelationsCombinedBigSorted = CorrelationsCombinedBig(sortIdx, :);
    LabelsBigHeatmapSorted = LabelsBigHeatmap(sortIdx,:);
    
    % Plot heatmap 
    %figure;
    subplot(1,3,2); 
    b = heatmap(CorrelationsCombinedBigSorted); b.Colormap = hot;
    b.ColorLimits = [0 1]; % Set the color limits to the range [0, 1]
    xlabel(b, 'Seizure event'); % Use the xlabel function for the heatmap
    %b.YDisplayLabels = strcat(LabelsBigHeatmapSorted(:, 1), ' - ', LabelsBigHeatmapSorted(:, 2));% Add the sorted Y-axis labels
    title('Seizures - sorted based on the mean difference'); 





        
   % Plot only interaction that have a high mean     
        % % Filter rows with mean >= 0.2
        % validIdx = rowMeans >= 0.02; % Logical index of rows that meet the condition
        % CorrelationsCombinedBigFiltered = CorrelationsCombinedBig(validIdx, :);
        % YLabelsFiltered = YLabels(validIdx);
        % 
        % % Sort the remaining rows by their mean values in descending order
        % [~, sortIdx] = sort(rowMeans(validIdx), 'descend');
        % CorrelationsCombinedBigSorted = CorrelationsCombinedBigFiltered(sortIdx, :);
        % YLabelsSorted = YLabelsFiltered(sortIdx);
        % 
        % % Plot sorted and filtered heatmap
        % figure; 
        % title('Interactions with mean corr higher than 0.02')
        % h = heatmap(CorrelationsCombinedBigSorted);
        % colormap(jet); % Get the default jet colormap
        % 
        % % Add sorted Y-axis labels
        % ax = gca; % Get current axes
        % ax.YDisplayLabels = YLabelsSorted; % Assign sorted Y-axis labels


end 


