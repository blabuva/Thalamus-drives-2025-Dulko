function [MeanCorrelations] = computeMeanCorrelation(CorrelationsAllSeizures, Labels,numSeizures,numUniqueStr, UniqueStructures)
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m


% Compute mean correlation between neurons from different brain structures
% for each seizure separately 

% INPUTS:
    % CorrelationsAllSeizures 
% OUTPUT: 
    % MeanCorrelations - Table with mean correlation values between each pair of structures

% Find all brain structures
structureNames = cellfun(@(x) x{1}, Labels, 'UniformOutput', false);

%% Initialize results

% Initialize results with structure pairs and seizure columns
MeanCorrelations = cell(nchoosek(numUniqueStr, 2), 2 + numSeizures); % Preallocate

% Populate the first two columns with all unique structure pairs
row = 1;
for i = 1:numUniqueStr
    for j = i+1:numUniqueStr % Ensure j > i 
        if i == j
            continue; % Skip comparisons within the same structure
        end
        MeanCorrelations{row, 1} = UniqueStructures{i};
        MeanCorrelations{row, 2} = UniqueStructures{j};
        row = row + 1;
    end
end

%% 
for iSeizure = 1:numSeizures
    
    corrMatrix = CorrelationsAllSeizures{1,iSeizure}; % grab data for one seizure 
    row = 1; 
    % Loop through all pairs of brain structures
    for i = 1:numUniqueStr % 1st brain structure 
        for j = i+1:numUniqueStr % 2nd brain structure 
            % Skip identical pairs - comparisons between the same brain
            % structures 
            if i == j
                continue;
            end
           
            %% Grab the right values - prepare for MEAN calculcation 
            % Get the names of the two structures
            structure1 = UniqueStructures{i};
            structure2 = UniqueStructures{j};

            % Get the indices of neurons belonging to these structures
            indices1 = strcmp(structureNames, structure1);
            indices2 = strcmp(structureNames, structure2);

            % Extract correlations between the two structures
            pairwiseCorrelations = corrMatrix(indices1, indices2);
            
            % Exclude "1" and double values. Grab only lower triangle of
            % the matrix to calculate the mean 
            %LowerTCorrValues = tril(pairwiseCorrelations,-1); % values - keep values that are below diagonal of "1" 
            %nonZeroValues = LowerTCorrValues(LowerTCorrValues ~= 0); % Mask out zeros by keeping only non-zero values

            %% Compute the mean correlation
            meanCorrelation = nanmean(pairwiseCorrelations(:));

            % Store the result
            %MeanCorrelations = [MeanCorrelations; {structure1, structure2, meanCorrelation}];

            % Compute mean correlation and store it
            MeanCorrelations{row, 2 + iSeizure} = meanCorrelation;
            row = row + 1;
        end
    end

    % Convert results to a table
    %outputTable = cell2table(results, 'VariableNames', {'Structure1', 'Structure2', 'MeanCorrelation'});
end

end % function end 
