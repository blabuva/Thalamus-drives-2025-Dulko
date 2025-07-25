function [rowOrder,sortedUniqueStructures,neatDataWithP,emptyRows] = orderAndPlotPhaseHeatmaps(uniqueStructures,DataWithP)
% parent function: MasterCodePhaseEla20250212.m 
% INPUT: DataWithP (is not normalized, not sorted) 
% OUTPUT: neatDataWithP (normalized, sorted) 

%% Remove empty rows - brain structures that don't have any spikes during seizures or non seizures 
% and update uniqueStructures now 

emptyRows = cellfun(@isempty, DataWithP(:,2)); % Find the indices of rows where the 2nd column is empty
DataWithP(emptyRows, :) = []; % Remove those rows from DataWithP 
uniqueStructures(emptyRows, :) = []; % Remove the corresponding rows from uniqueStructures

%% Concatenate and normalize data 
% concatenate 
    normalizedNON_SWDs = []; 
    normalizedSWDs = []; 
    
    for iUniqBrain = 1:size(uniqueStructures,1) 
        x = DataWithP{iUniqBrain,2}; % non SWDs 
        normalizedNON_SWDs = [normalizedNON_SWDs;x];
        y = DataWithP{iUniqBrain,3}; % SWDs 
        normalizedSWDs = [normalizedSWDs;y];
    end 
% normalize 
    normalizedData = normalizedSWDs ./ max(normalizedSWDs, [], 2); % normalize SWD data 
    normDataNonSWDs = normalizedNON_SWDs ./max(normalizedNON_SWDs, [], 2); % normalize NON SWD data 

%% Order based on seizure data 
% establish the order: 
    % Find the order of rows (from where "1" occurs earliest to latest) 
    columnNumbers = []; 
    
    for iRow = 1:size(normalizedData,1)
        oneRow = normalizedData(iRow,:); 
        columnNo = find(oneRow == 1); 
        
        if numel(columnNo) == 1
            % If only one column has value 1, store it as usual
            columnNumbers = [columnNumbers; columnNo]; 
        elseif numel(columnNo) == 2
            % If exactly two columns have value 1, pick the middle one
            columnNo = mean(columnNo); % Get the middle column index
            columnNumbers = [columnNumbers; round(columnNo)]; % Store the rounded middle column
        else
            % If more than two, keep the first one as before
            columnNo = columnNo(1); 
            columnNumbers = [columnNumbers; columnNo];  
        end 
    end

% Sort  
    % sort columns from the lowest to highest 
    [~, rowOrder] = sort(columnNumbers); % Get sorting indices
    sortedData = normalizedData(rowOrder, :); % Reorder rows in data (SEIZURES) 
    sortedNONSWDData = normDataNonSWDs(rowOrder, :); % Reorder rows in data (NON SEIZURES) 
    sortedUniqueStructures = uniqueStructures(rowOrder,:);  % Reorder brain structures 
%% Plot histograms but now they are organized 
numSubplots = size(normDataNonSWDs,1);

figure; sgtitle('Non-SWDs norm ordered'); % for non seizure 
for iUniqBrain = 1:numSubplots 
    currentStructure = sortedUniqueStructures{iUniqBrain}; % which structure now 
    values = sortedNONSWDData(iUniqBrain,:); % extract NON seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'b'); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left
    xlim([0 100]); 
end

figure; sgtitle('SWDs'); % for seizures 
for iUniqBrain = 1:numSubplots 
    currentStructure = sortedUniqueStructures{iUniqBrain}; % which structure now 
    values = sortedData(iUniqBrain,:); % extract seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'b'); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left
    xlim([0 100]); 
end

[neatDataWithP] = createNeatDataWithP(DataWithP,sortedNONSWDData,sortedData,rowOrder); % Reorganize DataWithP 

%% Plot both (non seizure and seizure) based on the new order 
figure;   
subplot(1,2,1); imagesc(sortedNONSWDData); 
yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
yticklabels(sortedUniqueStructures); 
title('Non seizures'); xlabel('normalized Phase'); 
subplot(1,2,2); imagesc(sortedData); 
yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
yticklabels(sortedUniqueStructures); xlabel('normalized Phase'); 
colormap(parula); 
title('Seizures'); 


%% Generate aterisks based on p values and add them to the plot 
  
for iP = 1:size(neatDataWithP,1) 
    pValue = neatDataWithP{iP,4};
    if isnan(pValue) 
       neatDataWithP{iP,6} = NaN; 
    elseif pValue < 0.001
       neatDataWithP{iP,6} = '***'; % Highly significant
    elseif pValue < 0.01
        neatDataWithP{iP,6} = '**';  % Very significant
    elseif pValue < 0.05
        neatDataWithP{iP,6} = '*';   % Significant
    else
       neatDataWithP{iP,6} = 'n.s.'; % Not significant
    end
end 

% add to the plot 
% Add asterisks on the right side of each row
    for i = 1:size(neatDataWithP,1)
        T = neatDataWithP{i,6}; % extract stars for this structure 
        text(size(neatDataWithP, 2) + 1, i, T, 'FontSize', 10, 'FontWeight', 'normal', 'Color', 'k');
    end






end % function end 
