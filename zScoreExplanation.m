function  zScoreExplanation(baselineMatrix,seizureMatrix,zScores)
% parent function: need to run MasterFunctionZscore.m for one of the
% structures and then get baseline Matrix, seizureMatrix, and zScores 

% iStructure =  26; VPM 

% pick one neuron for explanation 
iRow = 45; % pick one neuron, all events 
% display Neuron's ID:
display(uniqueNeurons(iRow)) 

% create colormap 
customColormap = [
    linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1);   % Blue to Gray
    ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)'    % Gray to Red
];
 

figure; 
    subplot(1,5,1); % baseline FR 
        % prepare data 
        oneRow = baselineMatrix(iRow,:); 
        % remove NaN values and Inf 
        %oneRow = oneRow(~isnan(oneRow) & ~isinf(oneRow)); % Remove NaN and Inf values
        numBins = size(oneRow, 2); % Get the total number of bins after removing NaNs
        numEvents = numBins / 24; % Calculate the number of events (each event has 24 bins)
        % Reshape into rows where each row corresponds to a seizure (24 bins)
        reshapedBaseline = reshape(oneRow, 24, numEvents)'; 
        % plot 
        h = heatmap(reshapedBaseline);
        h.XLabel = 'Time'; 
        title('Baseline');
        h.Colormap = jet;
        h.ColorLimits = [0, 50]; % Set color limits from 0 to 50
        colorbar;
        h.GridVisible = 'off';    % Remove the gridlines

    subplot(1,5,2); % 
        RowMean = mean(reshapedBaseline,2); 
        hh = heatmap(RowMean); 
        hh.XLabel = 'Time'; 
        title('Baseline mean');
        hh.Colormap = jet;
        hh.ColorLimits = [0, 50]; % Set color limits from 0 to 50

    subplot(1,5,3); % seizure FR 
        % prepare data 
        oneRow = seizureMatrix(iRow,:); 
        % remove NaN values and Inf 
        %oneRow = oneRow(~isnan(oneRow) & ~isinf(oneRow)); % Remove NaN and Inf values
        numBins = size(oneRow, 2); % Get the total number of bins after removing NaNs
        numEvents = numBins / 24; % Calculate the number of events (each event has 24 bins)
        % Reshape into rows where each row corresponds to a seizure (24 bins)
        reshapedSeizure = reshape(oneRow, 24, numEvents)'; 
        % plot 
        h = heatmap(reshapedSeizure);
        h.XLabel = 'Time'; 
        title('Seizure');
        h.Colormap = jet;
        h.ColorLimits = [0, 50]; % Set color limits from 0 to 50
        colorbar;
        h.GridVisible = 'off';  % Remove the gridlines

    subplot(1,5,4); 
        oneRow = zScores(iRow,:); 
        % remove NaN values and Inf 
        %oneRow = oneRow(~isnan(oneRow) & ~isinf(oneRow)); % Remove NaN and Inf values
        numBins = size(oneRow, 2); % Get the total number of bins after removing NaNs
        numEvents = numBins / 24; % Calculate the number of events (each event has 24 bins)
        % Reshape into rows where each row corresponds to a seizure (24 bins)
        reshapedZscores = reshape(oneRow, 24, numEvents)'; 
        % plot 
        h = heatmap(reshapedZscores);
        h.XLabel = 'Time'; 
        title('Z-score');
        h.Colormap = customColormap; % Apply the custom colormap
        h.ColorLimits = [-2, 2]; % Set z-score limits
        h.GridVisible = 'off';  % Remove the gridlines
        colorbar;

   subplot(1,5,5); % plot z score ordered 
        % Find the maximum value and its column index for each row
        [~, peakIndices] = max(reshapedZscores, [], 2);  % peakIndices is 21x1
        
        % Sort the rows based on the column index of the peak (earliest peaks first)
        [~, sortOrder] = sort(peakIndices);
        
        % Reorder the rows of reshapedZscores based on the sorted peak indices
        sortedZscores = reshapedZscores(sortOrder, :);
        hy = heatmap(sortedZscores); 
        title('sorted Z-score');
        hy.Colormap = customColormap; % Apply the custom colormap
        hy.ColorLimits = [-2, 2]; % Set z-score limits
        hy.GridVisible = 'off';  % Remove the gridlines
        colorbar;
    
forDataPath =('/media/elaX/Publications/Figures/Figure2_FiringRate/Z-scoreExplanation/');

svgFileName = fullfile(forDataPath, ['HeatmapExpl.svg']);
        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
