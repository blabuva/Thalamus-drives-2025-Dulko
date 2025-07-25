function sortedBoxAndScatterZscore(allZscores)
% parent function: MasterFunctionZscore.m 

% Plot boxplots + scatter for all data, sorted by mean Z-score

% Initialize
structureNames = allZscores(:, 1);
numStructures = size(allZscores, 1); 

means = [];
validData = {};
validNames = {};

% Step 1: Filter and compute means
for i = 1:numStructures
    data = allZscores{i,2};
    if isempty(data)
        continue
    end
    values = data(:, 21:24); % seizure window
    trialMeans = mean(values, 2); % mean per trial
    structureMean = mean(trialMeans); % mean across trials
    
    validData{end+1} = trialMeans;
    means(end+1) = structureMean;
    validNames{end+1} = structureNames{i};
end

% Step 2: Sort by mean Z-score
[sortedMeans, sortIdx] = sort(means);
sortedData = validData(sortIdx);
sortedNames = validNames(sortIdx);

% Step 3: Prepare data for boxplot and scatter
allY = [];
allGroup = [];

figure; hold on;

for i = 1:length(sortedData)
    y = sortedData{i};

    % Add all data (not just 50%) to plot
    scatter(repmat(i, numel(y), 1), y, 30, 'k', 'filled', ...
        'MarkerFaceAlpha', 0.5 ,'jitter','on', 'jitterAmount', 0.3);

    allY = [allY; y];
    allGroup = [allGroup; repmat(i, numel(y), 1)];
end

% Step 4: Boxplot
h = boxplot(allY, allGroup, 'Colors', [0.2 0.2 0.8], ...
    'Symbol', '', 'Widths', 0.5);

% Transparent patches
set(findobj(gca, 'Tag', 'Box'), 'LineWidth', 1.5, 'Color', [0.2 0.2 0.8]);
set(findobj(gca, 'Tag', 'Median'), 'LineWidth', 1.5);
set(findobj(gca, 'Tag', 'Whisker'), 'LineWidth', 1.2);
set(findobj(gca, 'Tag', 'Outliers'), 'Marker', 'none');

hBox = findobj(gca, 'Tag', 'Box');
for j = 1:length(hBox)
    patch(get(hBox(j), 'XData'), get(hBox(j), 'YData'), [0.6 0.6 0.9], ...
        'FaceAlpha', 0.3, 'EdgeColor', [0.2 0.2 0.8], 'LineWidth', 1.5);
end

% Step 5: Add horizontal lines
yline(-2, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); 
yline(2, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); 

% Step 6: Format plot
xticks(1:length(sortedNames));
xticklabels(sortedNames);
xtickangle(45);
ylabel('Z-score');
title('Z-scores - Sorted by Mean');
box on;

end
