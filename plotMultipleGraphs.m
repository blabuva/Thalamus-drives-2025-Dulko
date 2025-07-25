function plotMultipleGraphs(rowMeans,LabelsBigHeatmap_DiffSorted)

%% 1. Prepare brain structure names and mean correlation values for each pair 
% grab and shorten names of the brain structures 
edgeNames = cell(length(rowMeans), 2); % Store node names
for i = 1:length(rowMeans)
    % Store node names
    edgeNames{i,1} = LabelsBigHeatmap_DiffSorted{i,1};  
    edgeNames{i,2} = LabelsBigHeatmap_DiffSorted{i,2}; 
end
% shorten node names for easier plotting (shorten each name to 10 characters
%shortenedNames = cellfun(@(x) strtrim(x(1:min(10, end))), edgeNames, 'UniformOutput', false);

% grab correlations 
meanCorrelations = rowMeans; 

% thresholds to be tested 
thresholds = linspace(0, 0.26, 10); 

filteredCorrelations = cell(size(thresholds,2),1); % Store meanCorrelations for each threshold
filteredNames = cell(size(thresholds,2),1); % Store shortenedNames for each threshold

nodeDegreeSum = containers.Map('KeyType', 'char', 'ValueType', 'double'); % Store summed degrees
 % initialize degree storage 
%% 2. Plot 

figure; 

% Step 1: Create the full graph to determine fixed positions
G_full = graph(edgeNames(:,1), edgeNames(:,2), meanCorrelations);
h_full = plot(G_full, 'Layout', 'circle'); 

% Store fixed node positions
allNodes = G_full.Nodes.Name; % Get all unique nodes
fixedPositions = containers.Map(allNodes, num2cell([h_full.XData; h_full.YData], 1)); % Store positions as a dictionary

% Compute global node degrees based on the full graph
globalNodeDegrees = degree(G_full);
globalMinDegree = min(globalNodeDegrees);
globalMaxDegree = max(globalNodeDegrees);
cmap = spring(256); 
colormap(cmap); % apply colormap to the figure 

% Iterate over thresholds
for iTr = 1:size(thresholds,2)
    currentThreshold = thresholds(iTr); 
    rowsToKeep = meanCorrelations >= currentThreshold;% Find indices where values are above or equal to the threshold

    % Store filtered results
    filteredCorrelations{iTr,1} = meanCorrelations(rowsToKeep);  
    filteredNames{iTr,1} = edgeNames(rowsToKeep, :);

    % Extract brain structure names for each pair
    structure1 = filteredNames{iTr,1}(:,1); % First brain structure
    structure2 = filteredNames{iTr,1}(:,2); % Second brain structure
    % Extract correlations above the threshold 
    correlations = filteredCorrelations{iTr,1}; % Extract correlations 

    subplot(2,5,iTr); % plot the graph 
        % Create graph object with only existing edges
        G = graph(structure1, structure2, correlations);
        
        % % Ensure only existing nodes get plotted with the fixed positions
        existingNodes = G.Nodes.Name; 
        coords = cellfun(@(n) fixedPositions(n), existingNodes, 'UniformOutput', false);
        % Reorganize the coordinates for easier plotting 
            coordsOrganized = zeros(size(coords,1),2);
            for iC = 1:size(coords,1)
               coordsOrganized(iC,1) = coords{iC}(1,:); % grab X coordinate
               coordsOrganized(iC,2) = coords{iC}(end,:); % grab y coordinate
            end
            X = coordsOrganized(:,1); % Extract X positions
            Y = coordsOrganized(:,2); % Extract Y positions
        % Compute outward label positions 
        labelOffsetFactor = 1.15; 
        angles = atan2(Y,X); 
        X_label = X* labelOffsetFactor;
        Y_label = Y* labelOffsetFactor; 

        % Plot with fixed node positions
        h = plot(G,'XData',X,'YData',Y); 
    
        % Compute node degrees based on the full graph
        nodeDegrees = degree(G);
        
        % Update cumulative degrees
        for j = 1:length(existingNodes)
            node = existingNodes{j};
            if isKey(nodeDegreeSum, node)
                nodeDegreeSum(node) = nodeDegreeSum(node) + nodeDegrees(j);
            else
                nodeDegreeSum(node) = nodeDegrees(j);
            end
        end

        % Normalize degrees for colormap
        % Normalize degrees using global min/max from the full graph
        colormapValues = (nodeDegrees - globalMinDegree) / (globalMaxDegree - globalMinDegree);
        %colormapValues = rescale(nodeDegrees, 0, 1);
        
        nodeColors = interp1(linspace(0, 1, size(cmap, 1)), cmap, colormapValues);
        
        % Apply node styles
        %h.NodeColor = nodeColors; h.MarkerSize = 6 ; 
        
        % Add node labels: 
        % Add labels slightly outside the circle
        %text(X_label, Y_label, existingNodes, 'HorizontalAlignment', 'center', ...
           %  'VerticalAlignment', 'middle', 'FontSize', 10, 'FontWeight', 'bold');
        
       


        % Apply edge styles
        h.EdgeColor = 'k'; h.EdgeAlpha = 0.6; h.LineWidth = normalize(G.Edges.Weight, 'range', [0.5, 3]); 
        title(['Threshold: ', num2str(currentThreshold)]);


end


% 
% --- ADD COLORBAR ---
colorbarHandle = colorbar; % Create colorbar
caxis([globalMinDegree, globalMaxDegree]); % Set color limits to the full graph's node degree range
ylabel(colorbarHandle, 'Node Degree'); % Label colorbar

%% 3. Sort and display sum of degrees 
% I want to know which brain structures have the most degrees 

% Convert nodeDegreeSum map to a sorted list
nodeNames = keys(nodeDegreeSum);
nodeDegrees = cell2mat(values(nodeDegreeSum));

% Sort in descending order
[sortedDegrees, sortIdx] = sort(nodeDegrees, 'descend');
sortedNodes = nodeNames(sortIdx);

% Create table for easier viewing
finalDegreeTable = table(sortedNodes', sortedDegrees', 'VariableNames', {'Node', 'TotalDegree'});

disp(finalDegreeTable); % Display the sorted node degrees in the command window

end % function end 