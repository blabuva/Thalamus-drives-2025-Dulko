function plotMultipleAnatomicalGraphs(rowMeans,LabelsBigHeatmap_DiffSorted)

%% 1. Prepare brain structure names and mean correlation values for each pair 
% grab all names of the brain structures 
edgeNames = cell(length(rowMeans), 2); % Store node names
for i = 1:length(rowMeans)
    % Store node names
    edgeNames{i,1} = LabelsBigHeatmap_DiffSorted{i,1};  
    edgeNames{i,2} = LabelsBigHeatmap_DiffSorted{i,2}; 
end

[x,y,brainStructures] = establishRealXYcoordsForStructures; % anatomical x,y coordinates for each node 
 
meanCorrelations = rowMeans; % grab correlations
thresholds = linspace(0, 0.26, 4); % thresholds to be tested 

filteredCorrelations = cell(size(thresholds,2),1); % Store meanCorrelations for each threshold


%% 2. Plot a graph with correlations > threshold 
figure; 

% Iterate over thresholds
for iTr = 1:size(thresholds,2)
    currentThreshold = thresholds(iTr); 
    rowsToKeep = meanCorrelations >= currentThreshold;% Find indices where values are above or equal to the threshold

    % Store filtered results
    filteredCorrelations{iTr,1} = meanCorrelations(rowsToKeep);  
    filteredNames{iTr,1} = edgeNames(rowsToKeep, :);
    edgeNamesFiltered = edgeNames(rowsToKeep,:); 
    % Extract correlations above the threshold 
    correlations = filteredCorrelations{iTr,1}; % Extract correlations 

    subplot(2,2,iTr); % plot the graph 
        plotAnatomicalGraph(correlations,brainStructures,edgeNamesFiltered,y,x)
    
    % Create graph object with only existing edges
        % G = graph(structure1, structure2, correlations);
        
    correlations = []; 
    edgeNamesFiltered = []; 

end


end % function end 