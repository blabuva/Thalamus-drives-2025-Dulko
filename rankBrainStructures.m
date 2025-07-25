function [newHeatmapLabels,sortedCoherenceValues] = rankBrainStructures(allFields,heatmapLabels) 
% parent function: StartHere.m 

%% what does this function do? 
% this function calculates the mean coherence in frequency of interest across all mice 
% for each brain structure and outputs sorted values (from the highest to
% lowest) and sorted structures names that later will be used to plot an
% ordered heatmap 

% allFields: rows - coherence values, columns - brain structure in 1 mouse 
% heatmapLabels: nx1 cell array of strings, e.g. {"Posterior_complex_of_the_thalamus - 0053", ...}

% Extract brain structure names without the subject identifiers (e.g., "- 0053")
% Split the labels by "-" and take the first part for grouping
bStructures = cellfun(@(x) strtok(x, '-'), heatmapLabels, 'UniformOutput', false);

uStructures = unique(bStructures); % Get the unique brain structure names

% Initialize a matrix to store the averaged data
meanFields = zeros(1, length(uStructures)); % 513 x (number of unique structures)

% Loop through each unique structure and compute the mean for specific bins
% NOTE: as of now I am hardcoding which bins to look at. It could change later. 
% But I am specifing bins around 5 Hz 

for iStruct = 1:length(uStructures)
    % Find the indices of columns belonging to the same brain structure
    matchingCols = find(strcmp(bStructures, uStructures{iStruct}));

        all = []; 
       % extract the bins of interest for each brain structure  
        for iColumn = 1:size(matchingCols,1) 
            dataOfInterest = allFields(6:9,matchingCols(iColumn)); 
            all = [all; dataOfInterest];  
        end 
        meanFields(1,iStruct) = mean(all); % calc mean and store 
end

    % Sort from the highest to lowest value 
    [~, sortIdx] = sort(meanFields, 'descend'); % Sort the brain structures based on their maximum values
    sortedCoherenceValues = meanFields(:, sortIdx); % Sort meanFields based on the sorted indices
    newHeatmapLabels = uStructures(sortIdx); % Sort the unique structures as well

end
