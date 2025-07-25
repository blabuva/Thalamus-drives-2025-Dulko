function [sortedUniqueStructures,neatDataWithPInh] = orderAndPlotPhaseHeatmapsInh(uniqueStructures,DataWithPInh,rowOrder,emptyRows)
% parent function: masterInhPlotter.m 

% INPUT: DataWithPInh (is not normalized, not sorted) 
% OUTPUT: neatDataWithPInh (normalized, sorted) 

%% Remove empty rows - same empty rows that were removed for all units 
DataWithPInh(emptyRows, :) = []; % Remove those rows from DataWithPInh 
uniqueStructures(emptyRows, :) = []; % Remove the corresponding rows from uniqueStructures 

%% Concatenate and normalize data 
% concatenate 
    normalizedNON_SWDs = []; 
    normalizedSWDs = []; 
    
    for iUniqBrain = 1:size(uniqueStructures,1) 
        x = DataWithPInh{iUniqBrain,2}; % non SWDs 
        normalizedNON_SWDs = [normalizedNON_SWDs;x];
        y = DataWithPInh{iUniqBrain,3}; % SWDs 
        normalizedSWDs = [normalizedSWDs;y];
    end 
% normalize 
    normalizedData = normalizedSWDs ./ max(normalizedSWDs, [], 2); % normalize SWD data 
    normDataNonSWDs = normalizedNON_SWDs ./max(normalizedNON_SWDs, [], 2); % normalize NON SWD data 

%% Order based on seizure data - use the order that was previously established 
    sortedData = normalizedData(rowOrder, :); % Reorder rows in data (SEIZURES) 
    sortedNONSWDData = normDataNonSWDs(rowOrder, :); % Reorder rows in data (NON SEIZURES) 
    sortedUniqueStructures = uniqueStructures(rowOrder,:);  % Reorder brain structures 
%% Plot histograms but now they are organized 
numSubplots = size(normDataNonSWDs,1);

figure; sgtitle('Non-SWDs norm ordered inh only'); % for non seizure 
for iUniqBrain = 1:numSubplots 
    currentStructure = sortedUniqueStructures{iUniqBrain}; % which structure now 
    values = sortedNONSWDData(iUniqBrain,:); % extract NON seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'b'); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left
    xlim([0 100]); 
end

figure; sgtitle('SWDs norm ordered inh only'); % for seizures 
for iUniqBrain = 1:numSubplots 
    currentStructure = sortedUniqueStructures{iUniqBrain}; % which structure now 
    values = sortedData(iUniqBrain,:); % extract seizure sums 
    subplot(numSubplots,1,iUniqBrain); 
    bar(values, 'FaceColor', 'k'); 
    ylabel(currentStructure, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % Label on the left
    xlim([0 100]); 
end

[neatDataWithPInh] = createNeatDataWithPInh(DataWithPInh,sortedNONSWDData,sortedData,rowOrder); % Reorganize DataWithPInh 

%% Plot both (non seizure and seizure) based on the new order 
figure;   
subplot(1,2,1); imagesc(sortedNONSWDData); 
yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
yticklabels(sortedUniqueStructures); 
title('Non seizures - Inh'); xlabel('normalized Phase'); 
subplot(1,2,2); imagesc(sortedData); 
yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
yticklabels(sortedUniqueStructures); xlabel('normalized Phase'); 
colormap(parula); 
title('Seizures - Inh'); 


%% Generate aterisks based on p values and add them to the plot 
  
for iP = 1:size(neatDataWithPInh,1) 
    pValue = neatDataWithPInh{iP,4};
    if isnan(pValue) 
       neatDataWithPInh{iP,6} = NaN; 
    elseif pValue < 0.001
       neatDataWithPInh{iP,6} = '***'; % Highly significant
    elseif pValue < 0.01
        neatDataWithPInh{iP,6} = '**';  % Very significant
    elseif pValue < 0.05
        neatDataWithPInh{iP,6} = '*';   % Significant
    else
       neatDataWithPInh{iP,6} = 'n.s.'; % Not significant
    end
end 

% add to the plot 
% Add asterisks on the right side of each row
for i = 1:size(neatDataWithPInh,1)
    T = neatDataWithPInh{i,6}; % extract stars for this structure
    if isnan(T)
        T = 'NaN'; % if T is NaN change to a character variable NaN
    else
        T = neatDataWithPInh{i,6}; % if not, keep as it is
    end
    text(size(neatDataWithPInh, 2) + 1, i, T, 'FontSize', 10, 'FontWeight', 'normal', 'Color', 'k');
end






end % function end 
