function plotAnatomicalGraph(correlations,brainStructures,edgeNamesFiltered,y,x)

% check no of connections - needed for color of each node 
[nodeColors,colorMap15] = countNumberOfConnections(brainStructures,edgeNamesFiltered);

% Plot dots with color based on connectivity
scatter(x, y, 100, nodeColors, 'filled'); 

% % Label brain structures
% for i = 1:length(brainStructures)
%     text(x(i), y(i), brainStructures{i}, 'FontSize', 10, 'HorizontalAlignment', 'right');
% end

%figure; 
hold on;

% % Scatter plot for brain structures
% scatter(x, y, 50, 'k', 'filled'); % Black dots, size 100
xlim([-2 1]); 
ylim([-1.5 2]); 

% % Label brain structures
% for i = 1:length(brainStructures)
%     text(x(i), y(i), brainStructures{i}, 'FontSize', 10, 'HorizontalAlignment', 'right');
% end


% Normalize correlation values for line width scaling
minLineWidth = 1; % Minimum line width
maxLineWidth = 10; % Maximum line width
normCorr = abs(correlations); % Absolute values of correlations (0 to 1)
lineWidths = minLineWidth + (maxLineWidth - minLineWidth) * normCorr; % Scale line widths

% Plot lines between connected structures
for i = 1:size(edgeNamesFiltered,1)
    node1 = edgeNamesFiltered{i,1};
    node2 = edgeNamesFiltered{i,2};

    % Find indices of these nodes
    idx1 = find(strcmp(brainStructures, node1));
    idx2 = find(strcmp(brainStructures, node2));

    if ~isempty(idx1) && ~isempty(idx2)
        
        %corrValue = meanCorrelations(i); % Get correlation value for coloring   
        lineWidth = lineWidths(i); % Get line thickness

        % Plot line with thickness and color based on correlation
        %plot([x(idx1), x(idx2)], [y(idx1), y(idx2)], 'LineWidth', lineWidth, 'Color',[0 0 0]);
           

         %Plot line with color based on correlation
        plot([x(idx1), x(idx2)], [y(idx1), y(idx2)], 'LineWidth', lineWidth, ...
             'Color', [1 1 1] * (1 - abs(normCorr(i)))); % Gray scale based on |corr|
    end
end

%title('Brain Structure Correlation Map');
xlabel('X Position');
ylabel('Y Position');
axis equal;
hold off; 

% Display the colorbar 
colormap(colorMap15); 
caxis([0 15]);
colorbar; 
cb = colorbar; 
cb.Ticks = linspace(0, 15, 16); % Set 16 discrete tick marks
cb.TickLabels = string(0:15); % Label them from 0 to 15
xlabel(cb, 'Number of Connections'); % Label the colorbar




end 