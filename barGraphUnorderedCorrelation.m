function barGraphUnorderedCorrelation(difference,whatStructures)
% parent function: MasterCodeSynchrony_241109.m

numStructures = size(difference, 1); % Number of brain structures (rows)

% Initialize a figure for the plot
figure;
hold on;

% Loop through each brain structure (row)
for iStructure = 1:numStructures
   
    values = difference(iStructure,:); % Extract the values for the current brain structure
    values = values(~isnan(values) & values ~= 0); % Filter out NaN and zero values
    % Plot mean difference as a bar graph 
    meanValue = mean(values); 
    bar(iStructure,meanValue); 
    hold on 
    % Plot the values as dots, offset horizontally by the structure index
    scatter(repmat(iStructure, size(values)), values, 'filled');
    
end

% Set plot aesthetics
xlabel('Brain Structure');
ylabel('Difference Value');
ylim([-0.1 0.5]); 
title('Dot Plot of Difference Values Grouped by Brain Structure');
xticks(1:numStructures);  % Set x-axis ticks to match the number of brain structures
% remove dont analyze from the list of structures 
%whatStructures(strcmp(whatStructures, 'DontAnalyze')) = [];
xticklabels(whatStructures);  % Replace with actual names if available
xlim([0, numStructures + 1]);  % Set x-axis limits
hold off;

end 