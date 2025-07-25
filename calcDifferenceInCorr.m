function [difference] = calcDifferenceInCorr(averageMatrices,averageMatricesBefore)
% parent function: MasterCodeSynchrony_241109.m

% Calculate the difference between correlations during seizures vs before  
difference = zeros(size(averageMatrices)); % Initialize a cell array to store the differences

    % Iterate through each cell and calculate the difference
    for i = 1:size(averageMatrices, 1)
        for j = 1:size(averageMatrices, 2)
            % Check if the cell contains a non-empty matrix
            if ~isempty(averageMatrices{i, j}) || numel(averageMatrices{i,j}) > 1
                % During = tril(averageMatrices{i, j},-1);
                % DuringInd = tril(true(size(During)),-1);
                % During = During(DuringInd);
    
    
                % Before = tril(averageMatricesBefore{i, j},-1);
                % BeforeInd = tril(true(size(Before)),-1);
                % Before = Before(BeforeInd);
                % 
                % % Perform the element-wise subtraction
                % difference{i, j} = During-Before;
                 During = averageMatrices{i,j}; 
                 meanD = nanmean(During,"all"); % get one value for correlations during seizures 
    
                 Before = averageMatricesBefore{i,j};
                 meanB = nanmean(Before,"all"); % get one value for correlations before seizures 
                 DiffValue = meanD-meanB;    
    
                 difference(i,j) = DiffValue; % store the difference 
            % else
            %     % Handle the case where one or both matrices are empty
            %     difference{i, j} = [];  % You can choose an appropriate value for empty cases
            % end
                continue
            end
        end
    end


end 


