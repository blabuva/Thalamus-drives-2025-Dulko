function [EEG_Time_NonSeizures,allNeuronsOneStructureNonS,baselineMatrix] = extractEEGandSpikesZscore(StructureDatabase,PreSeizure,MinimumSeizureDuration,binSize,numBins)

numRows = size(StructureDatabase,1);
EEG_Time_NonSeizures = cell(numRows,2); % first col - EEG, second col - Time 
allNeuronsOneStructureNonS = []; 

% 12/14 
allLabels = []; 

for iRow = 1:numRows % loop through each row of structure database 
    currentRow = StructureDatabase(iRow,:); % extract one row at the time
    % extract EEG halfway the pre-seizure period 
    [EEG,tEEG,leftEdge,rightEdge,times,voltage,edges] = grabEEGZscore(currentRow,PreSeizure,MinimumSeizureDuration,binSize); 
    % check if this time period doesn't include any seizures, if necessary
    % adjust the edges 
    [edges] = checkThisEventZscore(tEEG,EEG,leftEdge,rightEdge,times,voltage,edges,binSize,numBins); 
        if isempty(edges) % if edges couldn't be find make these variables below empty 
           EEG = []; 
           TIME = []; 
           allCounts = []; 
           cluster = []; % no cluster information

        else % if edges were succesfully found, extract EEG, TIME, and SPIKES, and store 
            % now extract EEG and use the same edges to extract spikes 
            [EEG,TIME] = extractEEG(currentRow,edges); 
            % now extract spikes 
            [allCounts,neuronIDs] = extractSPIKES(edges,currentRow); % extract spikes in range for 
            
            % regardless, empty or not, store 
            allNeuronsOneStructureNonS = [allNeuronsOneStructureNonS;allCounts]; % Store and concatenate
            EEG_Time_NonSeizures{iRow,1} = EEG; % store EEG for this iRow
            EEG_Time_NonSeizures{iRow,2} = TIME; % store time for this iRow 
    
            [neuronLabels] = createLabels(currentRow,neuronIDs); % make labels for each neuron 
            allLabels = [allLabels; neuronLabels]; 
        end   
      
end 

% 12/14 
[reorganizedData,uniqueNeurons] = ReOrganizeDataForGiantHeatmap(allLabels,allNeuronsOneStructureNonS); 
numNeurons = size(reorganizedData,1); 
numSeizures = size(reorganizedData,2); 
[heatmapMatrix] = concatenate_ED(reorganizedData,numNeurons,numSeizures); 
% save the heatmapMatrix as baseline 
baselineMatrix = heatmapMatrix; 

% Plot the detailed heatmap 
figure;
h = heatmap(heatmapMatrix);
h.XLabel = 'Time Points';
h.YLabel ='Neurons';
h.YDisplayLabels = uniqueNeurons; 
title('Concatenated Neuron Activity - Baseline');
h.Colormap = jet;
colorbar;

close all

end