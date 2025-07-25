function investigateChangeInFiringAndCorrelation(whatStructures,numMice,averageMatricesBefore,averageMatrices,masterFiringDataBefore,masterFiringData) 

% parent function: MasterCodeSynchrony_241109.m

%% Calculate the CHANGE in mean firing rate (During Seizure vs Before Seizure)  
allDifferencesInFR = cell(length(whatStructures),numMice); % store difference here 
% 
numRows = size(masterFiringData,1); % how many rows 
numColumns = size(masterFiringData,2); % how many columns 

for i = 1:numRows 
    for j = 1:numColumns

        OneField = masterFiringData{i,j}; 
        if isempty(OneField) 
            continue
        else 
            % CALCULATE MEAN FR DURING SEIZURE (action potentials / second)  
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
                %meanFR{i,j} = OneMean; % i - row index, j - column index 

        BeforeOneField = masterFiringDataBefore{i,j};
        % CALCULATE MEAN FR BEFORE SEIZURE (action potentials / second)
        averagesForOneField_Before = []; 
            % loop through neurons and seizures and calculate an average  
            numNeurons = size(BeforeOneField,1); 
            numNonSeizures = size(BeforeOneField,2); 
            for k = 1:numNeurons 
                for l = 1:numNonSeizures 
                    oneNeuron = BeforeOneField{k,l}; % firing for one neuron during one event 
                    NonSeizureDuration = binSize*size(oneNeuron,2); % seizure duration in seconds 
                    noAPs = sum(oneNeuron,"all"); 
                    meanFRoneNeuron = noAPs/NonSeizureDuration; % firing rate as number of action potentials / second 
                    averagesForOneField_Before = [averagesForOneField_Before;meanFRoneNeuron];  % store 
                end
            end 

                % Calculate ONE average for the whole field (BEFORE
                % SEIZURE) 
                MeanBefore = mean(averagesForOneField_Before); % mean FF across all neurons and all seizures 
                
        % Calculate change in firing 
        FRdifference = OneMean-MeanBefore; 
        allDifferencesInFR{i,j} = FRdifference; % store 
        end
    end
end

%% Calculate mean correlation and collect the firing rate calculated earlier 
 
meanFRchangeAll = []; 
CorrelationChange = []; 

numRows = size(averageMatrices,1); % how many rows 
numColumns = size(averageMatrices,2); % how many columns 

for i = 1:numRows 
    for j = 1:numColumns
        OneField = averageMatrices{i,j}; 
        if isempty(OneField) 
            continue
        else 
            % CORRELATION DURING SEIZURE  
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
                
                % CORRELATION BEFORE SEIZURE 
                OneFieldBefore = averageMatricesBefore{i,j}; 
                % Extract lower triange 
                lowerTriangleBefore = tril(OneFieldBefore, -1); % -1 excludes the diagonal
                % Convert the result to a column vector excluding zeros
                lowerTriangleValuesBefore = nonzeros(lowerTriangleBefore); % Keeps only non-zero values
                % calculate the mean  
                meanCorrBefore = mean(lowerTriangleValuesBefore); 


               % DIFFERENCE (during seizure - before seizure) 
               CorrChange = meanCorr-meanCorrBefore; 
               CorrelationChange = [CorrelationChange; CorrChange]; % store change


           % CHANGE IN FIRING (DURING SEIZURE VS BEFORE)  
                firingRate = allDifferencesInFR{i,j};
                meanFRchangeAll = [meanFRchangeAll; firingRate]; % store
        
        end
    end
end

%% PLOT 
% Prepare data for plotting 
% Find rows in CorrelationChange that have NaN values
nanRows = isnan(CorrelationChange);

% Remove NaNs from CorrelationChange
CorrelationChange(nanRows) = [];

% Remove corresponding rows from meanFRchangeAll
meanFRchangeAll(nanRows) = [];
 

% Scatter plot of Number of Neurons (x) vs Mean Correlation (y)
figure;
scatter(meanFRchangeAll, CorrelationChange, 40, [0.5, 0.5, 0.5],'filled');
xlabel('Firing change compared to pre-seizure (APs/sec)');
ylabel('Correlation change compared to pre-seizure');
title('Scatter Plot of Firing Change vs Correlation Change');
grid off;
hold on;

ylim([0 0.5]); 
% Perform linear regression
p = polyfit(meanFRchangeAll, CorrelationChange, 1); % Fit a linear model
xFit = linspace(min(meanFRchangeAll), max(meanFRchangeAll), 100); % Generate x values for the fit line
yFit = polyval(p, xFit); % Generate y values using the fit

% Plot the regression line
plot(xFit, yFit, 'k-', 'LineWidth', 2);
legend('Data Points', 'Linear Fit');

% Display R-squared value
yPredicted = polyval(p, meanFRchangeAll); % Predicted values from the model
SSres = sum((CorrelationChange - yPredicted).^2); % Residual sum of squares
SStot = sum((CorrelationChange - mean(CorrelationChange)).^2); % Total sum of squares
R2 = 1 - (SSres / SStot); % R-squared value

disp(['R-squared: ', num2str(R2)]);







end 
