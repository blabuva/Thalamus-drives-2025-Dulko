function [allNeuronsMatrix,sortedAllLabels] = sortAllNeuronsMatrix(allNeuronsMatrix,allLabels,folderName,targetStructure) 
    
% sort rows based on where the biggest z-score is

% Find the column index of the maximum value in each row
[~, maxColIndices] = max(allNeuronsMatrix, [], 2);

% Sort rows based on the column index of the maximum value
[~, sortOrder] = sort(maxColIndices);
sortedMatrix = allNeuronsMatrix(sortOrder, :);
allNeuronsMatrix = sortedMatrix; 

% Display the sorted matrix
%disp(sortedMatrix);


% Sort labels as well 
sortedAllLabels = allLabels(sortOrder); 




% plot to check if it works 
% figure; 
% subplot(1,2,1);
% heatmap(allNeuronsMatrix,GridVisible="off");
% subplot(1,2,2); 
% heatmap(sortedMatrix,GridVisible="off")

% Define a custom colormap for the heatmap
customColormap = [
    linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1);   % Blue to Gray
    ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)'    % Gray to Red
];

% Create the heatmap
figure;
h = heatmap(sortedMatrix);
%h = heatmap(GiantZscoreMatrix);
h.XLabel = 'Time Points';
h.YLabel = 'Neurons';
%h.YDisplayLabels = allLabels; % Label for each neuron 
h.Title = 'Z-Score Heatmap sorted';
h.Colormap = customColormap; % Apply the custom colormap
h.ColorLimits = [-2, 2]; % Set z-score limits
h.MissingDataColor = [0.5, 0.5, 0.5]; % Gray for NaN
%h.GridVisible("off"); 

% Saving as .svg: 
svgFileName = fullfile(folderName,[targetStructure '.svg']); 
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

close all 
end

