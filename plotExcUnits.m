function plotExcUnits(lumpedAllResultsExcTable,rowOrder) 
% parent function: MasterCodePhaseEla20250212.m 

%% Organize data by structure 
[organizedDataExcOnly,uniqueStructures] = organizeDataByStructureEXConly(lumpedAllResultsExcTable); 

%% Organize data into a matrix (rows - structures, columns- time) 
heatmapExcNON_SWDs = []; 
heatmapExcSWDs = []; 

for iUniqBrain = 1:size(uniqueStructures,1)
    x = organizedDataExcOnly{iUniqBrain,2}; % non SWDs 
    heatmapExcNON_SWDs = [heatmapExcNON_SWDs;x];
    y = organizedData{iUniqBrain,3}; % SWDs 
    heatmapExcSWDs = [heatmapExcSWDs;y];
end 

%figure; subplot(1,2,1); heatmap(heat_map_NON_SWDs); colormap("parula"); 
%subplot(1,2,2); heatmap(heat_map_SWDs); colormap("parula");  

%% Normalize data 
normExcSWD = heatmapExcSWDs ./ max(heatmapExcSWDs, [], 2); % SWDs - Normalize each row independently
normExcNON_SWDs = heatmapExcNON_SWDs ./max(heatmapExcNON_SWDs, [], 2); % Non SWDs - Normalize each row independently 

%% PLOT phase for Exc units 
 
% Reorganize SWD data 
    % split in half and stitch (for SWDs) 
    leftSide = normExcSWD(:,51:100); rightSide = normExcSWD(:,1:50); normalizedExcSWD = [leftSide, rightSide]; % stitch 

% Reorganize Non SWD data  
    leftSideNonSWDs = normExcNON_SWDs(:, 51:100); rightSideNonSWDs = normExcNON_SWDs(:, 1:50); normalizedExcNON_SWDs = [leftSideNonSWDs, rightSideNonSWDs]; % stitch 

%% Order based on seizure data 
%  use previously established order (for all units) to re-order the rows  
    sortedExcSWD = normalizedExcSWD(rowOrder, :); % Reorder rows in seizure data
    sortedExcNONSWD = normalizedExcNON_SWDs(rowOrder,:); % Reorder rows in non seizure data 
    % re-order the names as well 
    sortedUniqueStructures = uniqueStructures(rowOrder,:); 

%% Plot both (non seizure and seizure) based on the new order 
figure;   
subplot(1,2,1); imagesc(sortedExcNONSWD); % plot non seizure data 
    yticks(1:size(sortedUniqueStructures,1)); % Set tick position 
    colormap(parula); yticklabels(sortedUniqueStructures); title('Exc units - Non seizures'); xlabel('normalized Phase'); 

subplot(1,2,2); imagesc(sortedExcSWD); 
    yticks(1:size(sortedUniqueStructures,1)); % Set tick positions
    yticklabels(sortedUniqueStructures); xlabel('normalized Phase'); 
    colormap(parula); title('Exc units - Seizures'); 
    % calculate statistics and plot stars 
    PvalsExc = statsForExcUnits(sortedUniqueStructures,sortedExcNONSWD,sortedExcSWD); 
    % Add asterisks on the right side of each row
    for i = 1:length(PvalsExc)
        T = PvalsExc(i,4); % extract stars for this structure 
        text(size(sortedExcSWD, 2) + 1, i, T, 'FontSize', 10, 'FontWeight', 'normal', 'Color', 'k');
    end









end