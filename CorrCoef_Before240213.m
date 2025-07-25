function   [correlationMatricesBefore, averageMatrixBefore] = CorrCoef_Before240213(spikesBeforeSeizures)
% parent function: MasterCodeSynchrony_241109.m

% Get the number of seizures (columns)
numSeizures = size(spikesBeforeSeizures, 2);

% Initialize a cell array to store correlation matrices for each seizure
correlationMatricesBefore = cell(1, numSeizures);

% Iterate over each seizure (column)
for iSeizure= 1:numSeizures
    % Extract the data for the current seizure (column) and handle empty cells
    dataSeizure = spikesBeforeSeizures(:, iSeizure);
    numClusters = length(dataSeizure);
    % Initialize a matrix to store correlation coefficients
    correlation_matrix = zeros(numClusters);
        % Calculate Pearson correlation coefficient for each pair of clusters
        for i = 1:numClusters
           for j = 1:numClusters
              % Extract data from cell array
              data1 = dataSeizure{i};
              data2 = dataSeizure{j};
        
        % Calculate Pearson correlation coefficient
        correlation_matrix(i, j) = corr(data1', data2');
           end
        end
   correlationMatricesBefore{1,iSeizure} = correlation_matrix;     
end
%% Calculate average correlation from all seizures 
sumMatrix = zeros(size(correlationMatricesBefore{1, 1})); % Initialize a matrix to accumulate the values
%countValidMatrices = 0;

cm = cell2mat(correlationMatricesBefore);
cm = reshape(cm,numClusters,numClusters,numSeizures);
% Loop through each seizure matrix and accumulate the values
% for i = 1:numel(correlationMatricesBefore)
%     currentMatrix = correlationMatricesBefore{i};
%     
%     % Check if the current matrix is not empty
%     if ~isempty(currentMatrix)
%         % Check for NaN values and add only valid numbers
%         validValues = ~isnan(currentMatrix);
%         sumMatrix(validValues) = sumMatrix(validValues) + currentMatrix(validValues);
%         
%         % Count the valid matrices
%         countValidMatrices = countValidMatrices + 1;
%     end
% end

% Calculate the average matrix
%averageMatrixBefore = sumMatrix / countValidMatrices;

averageMatrixBefore = nanmean(cm,3);
% Display the result
disp('Average Matrix:');
disp(averageMatrixBefore);

end

