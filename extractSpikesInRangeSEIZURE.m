function [allCountsSeizure,seizureMatrix,uniqueNeurons,allLabels] = extractSpikesInRangeSEIZURE(StructureDatabase,PreSeizure,binSize,MinimumSeizureDuration,numBins)

allCountsSeizure = []; 
% 12/14 
allLabels = []; 

for iRow = 1:size(StructureDatabase,1)
    currentRow = StructureDatabase(iRow,:); % extract one row at the time
    % extract all spike times
    allSpikesAllNeurons = currentRow.SingleUnitsAll{1,1}.all.CurrentSWD.SpikeTimesSec; % rows- neurons
        if isempty(allSpikesAllNeurons) 
            SpikeCounts = cell(0,1); % Ensure empty case matches
            neuronLabels = cell(0,1); % No neurons, no labels                
        else % for each neuron extract spike times that happen within the range of
            % interest 
            % when did the seizure start ?
            seizureStart = currentRow.SeizureStartTime; % will be used as right edge
            leftEdge = seizureStart+PreSeizure;
            rightEdge = seizureStart+MinimumSeizureDuration; 
        
            allSpikesAllNeurons_inRange = cell(size(allSpikesAllNeurons,1),1);
            for iNeuron = 1:size(allSpikesAllNeurons,1)
                extractedSpikes = allSpikesAllNeurons{iNeuron,:};
                InRangeIndex = extractedSpikes >=leftEdge & extractedSpikes <= rightEdge;
                spikesInRange = extractedSpikes(InRangeIndex);
                allSpikesAllNeurons_inRange{iNeuron,1} = spikesInRange; % store
            end
            % spike times - >> binned firing rate 
            edges = leftEdge:binSize:rightEdge; % Bin edges
            SpikeCounts = cell(size(allSpikesAllNeurons_inRange,1),1); % initialize cell for storing 
                for iNeuron = 1:size(allSpikesAllNeurons,1)
                    SpikeCounts{iNeuron,1} = histcounts(allSpikesAllNeurons_inRange{iNeuron,1}, edges);
                end
           % store labels for these neurons 
            neuronIDs = currentRow.SingleUnitsAll{1,1}.all.CurrentSWD.ClusterID; 
            [neuronLabels] = createLabels(currentRow,neuronIDs); % make labels for each neuron 
        end
        % Append spike counts and labels 
        allCountsSeizure = [allCountsSeizure;SpikeCounts]; % Store and concatenate
        allLabels = [allLabels; neuronLabels]; 
        % Code below help making sure the # of labels matches # of trials 
        fprintf('Number of SpikeCounts rows: %d\n', size(SpikeCounts, 1));
        fprintf('Number of neuronLabels rows: %d\n', size(neuronLabels, 1));

end

% 12/14 
[reorganizedData,uniqueNeurons] = ReOrganizeDataForGiantHeatmap(allLabels,allCountsSeizure);
numNeurons = size(reorganizedData,1); 
numSeizures = size(reorganizedData,2); 
[heatmapMatrix] = concatenate_ED(reorganizedData,numNeurons,numSeizures); 
% save the heatmapMatrix as Seizure 
seizureMatrix = heatmapMatrix; 

% Plot the detailed heatmap 
figure;
h = heatmap(seizureMatrix);
h.XLabel = 'Time Points';
h.YLabel ='Neurons';
h.YDisplayLabels = uniqueNeurons; 
title('Concatenated Neuron Activity - Seizure');
h.Colormap = jet; 
% colorbar;
h.ColorLimits = [0, 70]; 




% commented on 4/23 - IDK if this is necessary 

% calculate one mean based on all the neurons 
% Initialize a vector to store the sum of each bin across all cells
% sumBins = zeros(1, numBins);
% 
% % Loop through each cell in the array
% for i = 1:length(allCountsSeizure)
%     currentData = allCountsSeizure{i}; % Extract the 1 x 24 vector from the current cell
%     sumBins = sumBins + currentData; % Add the current vector to the sum vector
% end
% 
% % Calculate the average for each bin
% averageBins = sumBins / length(allCountsSeizure); % Divide by the number of cells
% 

% visualize counts for all neurons in this structure 
% figure; 
% for iRow = 1:size(allCountsSeizure,1)
%     firing = allCountsSeizure{iRow};
%     plot(firing); 
%     hold on
% end 
% 
% % 
% plot(averageBins,'-k','LineWidth',3); % mean across all neurons 
% hold off 

end