function plotBarGraphZscores(ZforBarGraph,whatStructures)

% parent function: MasterFunctionZscore.m
% this function grabs mean z-score for each brain structure (all z scores
% for seizure matrix (data from first four seconds of the seizure) averaged
% from all the neurons. 

% Sort ZforBarGraph in ascending order and get sorting indices
%[sortedZscores, sortIdxZmean] = sort(ZforBarGraph, 'ascend');

% Use the same indices to sort whatStructures
%sortedStructures = whatStructures(sortIdxZmean);

% Plot the sorted values as a bar graph
figure;
bar(ZforBarGraph);
set(gca, 'XTickLabel', whatStructures, 'XTick', 1:length(ZforBarGraph));
xtickangle(45); % Rotate labels for better visibility if needed
xlabel('Brain Structures');
ylabel('Mean firing rate change z-scored');
%title('Sorted Bar Graph of ZforBarGraph');

end 