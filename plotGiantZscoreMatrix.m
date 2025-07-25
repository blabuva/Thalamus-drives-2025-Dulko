function plotGiantZscoreMatrix(GiantZscoreMatrix,folderName)
% parent function: MasterFunctionZscore.m

% create colormap 
customColormap = [
    linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1);   % Blue to Gray
    ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)'    % Gray to Red
];

% Create the heatmap
figure;
h = heatmap(GiantZscoreMatrix); grid("off"); 

% h.XLabel = 'Time Points';
% h.YLabel = 'Neurons';
%h.YDisplayLabels = allLabels; % Label for each neuron
h.Title = 'Z-Score Heatmap';
h.Colormap = customColormap; % Apply the custom colormap
h.ColorLimits = [-2, 2]; % Set z-score limits
% Remove the gridlines
h.GridVisible = 'off';%h.MissingDataColor = [0.5, 0.5, 0.5]; % Gray for NaN


% Saving as .svg: 
svgFileName = fullfile(folderName,['AllStructuresZscores-increase' '.svg']); 
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

end 