function investigateFiringRateAndCorrelation(masterFiringData, binSize, averageMatrices)

% parent function: MasterCodeSynchrony_241109.m

%% Calculate mean firing rate 
meanFR = []; % store mean here 
% 
numRows = size(masterFiringData,1); % how many rows 
numColumns = size(masterFiringData,2); % how many columns 

for i = 1:numRows 
    for j = 1:numColumns
        OneField = masterFiringData{i,j}; 
        if isempty(OneField) 
            continue
        else 
            % CALCULATE MEAN FR (action potentials / second)  
            averagesForOneField = []; 
            % loop through neurons and seizures and calculate an average  
            numNeurons = size(OneField,1); 
            numSeizures = size(OneField,2); 
            for k = 1:numNeurons 
                for l = 1:numSeizures 
                    oneNeuron = OneField{k,l}; % firing for one neuron during one event 
                    seizureDuration = binSize*size(oneNeuron,2); % seizure duration in seconds 
                    noAPs = sum(oneNeuron,"all"); 
                    meanFRoneNeuron = noAPs/seizureDuration; % firing rate as number of action potentials / second 
                    averagesForOneField = [averagesForOneField;meanFRoneNeuron];  % store 
                end
            end 
                % Calculate ONE average for the whole field 
                OneMean = mean(averagesForOneField); % mean FF across all neurons and all seizures 
                meanFR{i,j} = OneMean; % i - row index, j - column index 
                
        end
    end
end

%% Calculate mean correlation and collect the firing rate calculated earlier 
 
meanFRall = []; 
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
           % FIRING DURING SEIZURES  
                firingRate = meanFR{i,j};
                meanFRall = [meanFRall; firingRate]; % store
        
        end
    end
end
%% PLOT 

% Scatter plot of Number of Neurons (x) vs Mean Correlation (y)
figure;
scatter(meanFRall, MeanCorrelation, 100, [0.5, 0.5, 0.5],'filled');
xlabel('Mean firing during seizure (APs/sec)');
ylabel('Mean correlation during seizure');
title('Scatter Plot of Mean Firing vs Mean Correlation');
grid off;
hold on;

ylim([0 0.6]); 
% Perform linear regression
p = polyfit(meanFRall, MeanCorrelation, 1); % Fit a linear model
xFit = linspace(min(meanFRall), max(meanFRall), 100); % Generate x values for the fit line
yFit = polyval(p, xFit); % Generate y values using the fit

% Plot the regression line
plot(xFit, yFit, 'k-', 'LineWidth', 2);
legend('Data Points', 'Linear Fit');

% Display R-squared value
yPredicted = polyval(p, meanFRall); % Predicted values from the model
SSres = sum((MeanCorrelation - yPredicted).^2); % Residual sum of squares
SStot = sum((MeanCorrelation - mean(MeanCorrelation)).^2); % Total sum of squares
R2 = 1 - (SSres / SStot); % R-squared value

disp(['R-squared: ', num2str(R2)]);

end % end of function  