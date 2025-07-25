function investigateNumberOfNeuronsAndCorrelation(averageMatrices)

% parent function: MasterCodeSynchrony_241109.m 

NumNeuronsAll = []; 
MeanCorrelation = []; 

numRows = size(averageMatrices,1); % how many rows 
numColumns = size(averageMatrices,2); % how many columns 

for i = 1:numRows 
    for j = 1:numColumns
        OneField = averageMatrices{i,j}; 
        if isempty(OneField) 
            continue
        else 
            % CORRELATION 
                % extract lower triangle (avoid repeated values)             
                % Extract the lower triangle excluding the diagonal
                lowerTriangle = tril(OneField, -1); % -1 excludes the diagonal
                % Convert the result to a column vector excluding zeros
                lowerTriangleValues = nonzeros(lowerTriangle); % Keeps only non-zero values
                % calculate the mean  
                meanCorr = mean(lowerTriangleValues); 
                if isnan(meanCorr)
                    continue 
                end
                MeanCorrelation = [MeanCorrelation; meanCorr]; % store mean Correlation
           % NUM NEURONS 
                numNeurons = size(OneField,1);
                NumNeuronsAll = [NumNeuronsAll; numNeurons]; % store
        
        end
    end
end

%% PLOT 
% Scatter plot of Number of Neurons (x) vs Mean Correlation (y)
figure;
scatter(NumNeuronsAll, MeanCorrelation, 40, [0.5, 0.5, 0.5],'filled');
xlabel('Number of Neurons');
ylabel('Mean correlation during seizure');
title('Scatter Plot of Number of Neurons vs Mean Correlation');
grid off;
hold on;

ylim([0 0.5]); 
% Perform linear regression
p = polyfit(NumNeuronsAll, MeanCorrelation, 1); % Fit a linear model
xFit = linspace(min(NumNeuronsAll), max(NumNeuronsAll), 100); % Generate x values for the fit line
yFit = polyval(p, xFit); % Generate y values using the fit

% Plot the regression line
plot(xFit, yFit, 'k-', 'LineWidth', 2);
legend('Data Points', 'Linear Fit');

% Display R-squared value
yPredicted = polyval(p, NumNeuronsAll); % Predicted values from the model
SSres = sum((MeanCorrelation - yPredicted).^2); % Residual sum of squares
SStot = sum((MeanCorrelation - mean(MeanCorrelation)).^2); % Total sum of squares
R2 = 1 - (SSres / SStot); % R-squared value

disp(['R-squared: ', num2str(R2)]);



end % end of function  