function NodeGraphsByEventType(DifferencesBig,CorrelationsCombinedBig,CorrelationsCombinedBig_NonSWSs,rowMeans)
% parent function: VisualizeAllCorrelationsAsHeatmaps.m 

%% Calculate mean correlations for non-seizures, seizures, and difference 
[rowMeansNonSWS,rowMeansSWS,rowMeansDiff] = CalculateMeanCorrelationsNonSWS_SWS_and_DIFF(DifferencesBig,...,
    CorrelationsCombinedBig,CorrelationsCombinedBig_NonSWSs); 

%% Store node names (they will be the same for all node graphs) 
edgeNames = cell(length(rowMeans), 2); % Store node names
for i = 1:length(rowMeans)
    % Store node names
    edgeNames{i,1} = LabelsBigHeatmap_Diff{i,1};  
    edgeNames{i,2} = LabelsBigHeatmap_Diff{i,2}; 
end

%% Grab anatomical coordinates for each brain structure 
[x,y,brainStructures] = establishRealXYcoordsForStructures; % anatomical x,y coordinates for each node 
 
%meanCorrelations = rowMeans; % grab correlations

figure; 
subplot(1,4,1); % node graph for non-seizures 
    correlations = rowMeansNonSWS; 
    edgeNamesFiltered = edgeNames; 
    plotAnatomicalGraph(correlations,brainStructures,edgeNamesFiltered,y,x);
    ylim([-2 2.5]); 
    set(gca, 'Color', [0.3 0.3 0.3]); % Set background to dark gray (RGB) for brighter, icrease the numbers 
    title('Non Seizures');
    correlations = []; 
    
subplot(1,4,2); 
    correlations = rowMeansSWS; 
    plotAnatomicalGraph(correlations,brainStructures,edgeNamesFiltered,y,x);
    ylim([-2 2.5]); 
    set(gca, 'Color', [0.3 0.3 0.3]); % Set background to dark gray (RGB) for brighter, icrease the numbers 
    title('Seizures'); 
    correlations = []; 
    %clear title
subplot(1,4,3);
    correlations = rowMeansDiff; 
    plotAnatomicalGraph(correlations,brainStructures,edgeNamesFiltered,y,x); 
    ylim([-2 2.5]); 
    set(gca, 'Color', [0.3 0.3 0.3]); % Set background to dark gray (RGB) for brighter, icrease the numbers 
    title('Difference'); 
    correlations = []; 
    %clear title 
subplot(1,4,4); % Only keep correlations > 0.17
    threshold = 0.17;
    correlations = rowMeansDiff; 
    keepIdx = correlations > threshold;

    % Filter everything accordingly
    correlations = correlations(keepIdx);
    edgeNamesFiltered = edgeNamesFiltered(keepIdx,:);  % if edgeNamesFiltered is a cell array

    % Plot
    plotAnatomicalGraph(correlations, brainStructures, edgeNamesFiltered, x, y); 
    
    ylim([-2 2.5]); 
    set(gca, 'Color', [0.3 0.3 0.3]); 
    title('Difference > 0.17'); 
    correlations = [];

        


    



end 