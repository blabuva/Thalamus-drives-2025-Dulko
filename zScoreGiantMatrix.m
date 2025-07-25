function [allNeuronsMatrix,zScores] = zScoreGiantMatrix(baselineMatrix,seizureMatrix,uniqueNeurons,targetStructure,folderName,allLabels)

% Calculate row-wise mean and standard deviation for baselineMatrix
baselineRowMean = nanmean(baselineMatrix, 2); % 54x1 (mean for each row)
baselineRowStd = nanstd(baselineMatrix, 0, 2); % 54x1 (std for each row)

% Expand row-wise mean and std to match the size of seizureMatrix
baselineRowMean = repmat(baselineRowMean, 1, size(seizureMatrix, 2)); % 54x480
baselineRowStd = repmat(baselineRowStd, 1, size(seizureMatrix, 2)); % 54x480

% Compute z-scores for seizureMatrix
zScores = (seizureMatrix - baselineRowMean) ./ baselineRowStd;

% Replace NaN and Inf values if baselineRowStd is 0
%zScores(isnan(zScores) | isinf(zScores)) = 0;
%% PLOT OPTION 1 
    % Rows - neurons,Columns - seizures 
    % Plot the heatmap
    % figure;
    %     h = heatmap(zScores);
    %     h.XLabel = 'Time Points';
    %     h.YLabel = 'Neurons';
    %     h.YDisplayLabels = uniqueNeurons; 
    %     h.Title = 'Z-Score Heatmap - Seizure vs Baseline (Row-Wise Baseline)';
    %     h.Colormap = jet; % Use the "jet" colormap
    %     h.ColorLimits = [-2, 2]; % Set z-score limits

%% PLOT OPTION 2 <- THIS ONE FOR NOW 
numNeurons = size(zScores,1); 
[allNeuronsMatrix] = concatenateNeuronsPlotHeatmap(numNeurons,zScores,folderName,targetStructure,allLabels); 







end 