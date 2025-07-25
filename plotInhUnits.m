function plotInhUnits(lumpedAllResultsInhTable,rowOrder) 
% parent function: MasterCodePhaseEla20250212.m 

%% Organize data by structure 
[organizedDataInhOnly,uniqueStructures] = organizeDataByStructureINHonly(lumpedAllResultsInhTable); 

%% Organize data into a matrix (rows - structures, columns- time) 
heatmapInhNON_SWDs = []; 
heatmapInhSWDs = []; 

for iUniqBrain = 1:size(uniqueStructures,1)
    x = organizedDataInhOnly{iUniqBrain,2}; % non SWDs 
    heatmapInhNON_SWDs = [heatmapInhNON_SWDs;x];
    y = organizedData{iUniqBrain,3}; % SWDs 
    heatmapInhSWDs = [heatmapInhSWDs;y];
end 

%figure; subplot(1,2,1); heatmap(heat_map_NON_SWDs); colormap("parula"); 
%subplot(1,2,2); heatmap(heat_map_SWDs); colormap("parula");  

%% Normalize data 
normInhSWD = heatmapInhSWDs ./ max(heatmapInhSWDs, [], 2); % SWDs - Normalize each row independently
normInhNON_SWDs = heatmapInhNON_SWDs ./max(heatmapInhNON_SWDs, [], 2); % Non SWDs - Normalize each row independently 

%% PLOT phase for Exc units (inh and exc) 
 
% Reorganize SWD data 
    % split in half and stitch (for SWDs) 
    leftSide = normInhSWD(:,51:100); rightSide = normInhSWD(:,1:50); normalizedInhSWD = [leftSide, rightSide]; % stitch 

% Reorganize Non SWD data  
    leftSideNonSWDs = normInhNON_SWDs(:, 51:100); rightSideNonSWDs = normInhNON_SWDs(:, 1:50); normalizedInhNON_SWDs = [leftSideNonSWDs, rightSideNonSWDs]; % stitch 

%% Order based on seizure data 
%  use previously established order (for all units) to re-order the rows  
    sortedInhSWD = normalizedInhSWD(rowOrder, :); % Reorder rows in seizure data
    sortedInhNONSWD = normalizedInhNON_SWDs(rowOrder,:); % Reorder rows in non seizure data 
    sortedUniqueStructures = uniqueStructures(rowOrder,:); % re-order the names as well 

%% Plot both (non seizure and seizure) based on the new order 
figure;   
subplot(1,2,1); imagesc(sortedInhNONSWD); % plot non seizure data 
    yticks(1:size(sortedUniqueStructures,1)); % Set tick position 
    colormap(parula); yticklabels(sortedUniqueStructures); title('Inh units - Non seizures'); xlabel('normalized Phase'); 

subplot(1,2,2); imagesc(sortedInhSWD); 
    yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
    yticklabels(sortedUniqueStructures); xlabel('normalized Phase'); 
    colormap(parula); title('Inh units - Seizures'); 
    % calculate statistics and plot stars 
    PvalsInh = statsForInhUnits(sortedUniqueStructures,sortedInhNONSWD,sortedInhSWD); 
    % Add asterisks on the right side of each row
    for i = 1:length(PvalsInh)
        T = PvalsInh(i,4); % extract stars for this structure 
        text(size(sortedInhSWD, 2) + 1, i, T, 'FontSize', 10, 'FontWeight', 'normal', 'Color', 'k');
    end




end