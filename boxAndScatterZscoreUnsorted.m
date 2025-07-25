function boxAndScatterZscoreUnsorted(numStructures, allZscores)
% parent function: MasterFunctionZscore.m 

% Initialize
structureNames = allZscores(:, 1);
numStructures = size(allZscores, 1); 

% Store for valid data
allY = [];
allGroup = [];
validNames = {};
plottedIndex = 0;

figure; hold on;

for iStructure = 1:numStructures
    if isempty(allZscores{iStructure,2})
        continue
    end

    plottedIndex = plottedIndex + 1;
    validNames{plottedIndex} = structureNames{iStructure};

    allValues = allZscores{iStructure,2};
    valuesDuringSeizures = allValues(:,21:24);
    y = mean(valuesDuringSeizures,2);

    % Store for boxplot
    allY = [allY; y];
    allGroup = [allGroup; repmat(plottedIndex, size(y))];

    % Scatter overlay (100% of points)
    nPoints = numel(y); 
    nSelect = round(0.5 * nPoints); 
    idx = randperm(nPoints, nSelect); 
    scatter(repmat(plottedIndex, nSelect, 1), y(idx), 30, 'k', 'filled', ...
        'jitter','on', 'jitterAmount', 0.3);
end

% Create boxplot (only for non-empty structures)
h = boxplot(allY, allGroup, 'Colors', [0.2 0.2 0.8], 'Symbol', '', 'Widths', 0.5);

% Transparent boxes
set(findobj(gca, 'Tag', 'Box'), 'LineWidth', 1.5, 'Color', [0.2 0.2 0.8]);
set(findobj(gca, 'Tag', 'Median'), 'LineWidth', 1.5);
set(findobj(gca, 'Tag', 'Whisker'), 'LineWidth', 1.2);
set(findobj(gca, 'Tag', 'Outliers'), 'Marker', 'none');

% Make patch transparent
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
    patch(get(h(j), 'XData'), get(h(j), 'YData'), [0.6 0.6 0.9], ...
        'FaceAlpha', 0.3, 'EdgeColor', [0.2 0.2 0.8], 'LineWidth', 1.5);
end

% Horizontal lines at ±2
yline(-2, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); 
yline(2, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); 

% Final formatting
xticks(1:length(validNames));
xticklabels(validNames);
xtickangle(45);
ylabel('Z-score');
title('Z-scores - Stargazer');
box on;

end
