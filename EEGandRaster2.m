function [firingRates,avgVoltage,uniqueStructures,numBins,XaxisLim] = EEGandRaster2(howFarBack,howFarInto, MouseDatabase,filteredStructures, AllNeuronsAllSeizures, AllLabelsAllSeizures, numSeizures, EEGs, folderPath,binSize, numStructures)
% parent function: Phase_ela.m

%% Plot combined figure (average EEG and firing of all neurons) 

% Create variable "labels"
%labels = AllLabelsAllSeizures;  
% create variable "labels"
labels = AllLabelsAllSeizures{1, 1};
if iscell(labels)
   labels = string(labels); % Convert to string array if necessary
end
uniqueStructures = unique(labels);

numStructures = size(uniqueStructures,1); 

numRows = numStructures+1; % number of rows depends on how many brain structures are there (+1 because the first one is EEG)
numColumns = 2;

fig = figure; 
 
% Loop through each brain structure  
for iStructure = 1:numStructures
    structureIndices = find(labels == uniqueStructures(iStructure)); % find indexes to each structure
    
    % Create a subplot for the current brain structure
    subplot(numRows, numColumns, iStructure*2 + 1); % RASTER
    hold on;

    
    % Loop through each seizure
    for iSeizure = 1:numSeizures

        % Initialize an array to store spike counts for seizure (rows -
        % neurons, columns time bins) 
        numBins = (howFarBack+howFarInto)/binSize; 
        spikeCountsSeizure = zeros(length(structureIndices), round(numBins)); % initialize the table 

        OneSeizure = AllNeuronsAllSeizures{1, iSeizure}; % extract data for one seizure  
        OneStructure = OneSeizure(structureIndices); % extract neurons for this structure
        smallLabels = labels(structureIndices); % extract labels for this structure
        numNeurons = size(OneStructure, 1); % how many neurons total are there
        
        % oneSeizureInd = (MouseDatabase.SeizureNumber == whatSeizures(iSeizure)); % get index for one seizure
        % OnlyOneSeizure = MouseDatabase(oneSeizureInd, :); % grab data for one seizure
        % 
        % % what is the time of first trough 
        % TroughTimes = OnlyOneSeizure.SWD_Props{1,1}.SWD_troughTimes; 
        % OnlyOneSeizure.SWD_Props{1,1}
        % firstTrough = TroughTimes{1,1}(1) 
        leftEdge = -howFarBack; 
        rightEdge = howFarInto; 
        % Loop through each neuron
        for neuron = 1:numNeurons
            spikeTimes = OneStructure{neuron, 1};
            if ~isempty(spikeTimes) % if no spike times, skip this neuron
                % Loop through each spike time for the current neuron
                for spike = spikeTimes
                    % Plot a vertical line for each spike time
                    line([spike spike], [neuron-0.5 neuron+0.5], 'Color', 'k');
                end
               % Count spikes in 5ms bins
                spikeCountsSeizure(neuron, :) = histcounts(spikeTimes, leftEdge:binSize:rightEdge);
            end
        end
        SeizureSum = sum(spikeCountsSeizure,1); % calculate how many action potentials had happened
        firingRates{iStructure,iSeizure} = SeizureSum; % store the sum 
        SeizureSum = [];
    end

    % Set the y-axis to display each neuron
    yticks(1:numNeurons); yticklabels(1:numNeurons); 

    % Adjust the plot limits
    ylim([0.5, numNeurons + 0.5]); xlim([-howFarBack,howFarInto]); 

    % Label axes
    xlabel('Time (s)'); ylabel('Neuron ID');
    title([num2str(uniqueStructures(iStructure))]); % set the title of the raster as name of brain structure  
    hold off;
end

%% Plot firing distribution in the second column \
avgVoltage = calcAvgVoltage(EEGs,numSeizures);
XaxisLim = (size(avgVoltage,2)-1); 
plotHistograms(uniqueStructures,firingRates,numStructures,numSeizures,avgVoltage,numRows,numColumns,XaxisLim)
% Save the combined figure
combinedFigName = fullfile(folderPath, 'Combined_Seizures_Figure');
saveas(fig, combinedFigName, 'png');  % Save as PNG format
%saveas(fig, combinedFigName, 'svg');  % Save as SVG format
close(fig);  % Close the figure to avoid memory leaks
%% Plot the individual figures
for iSeizure = 1:numSeizures
    OneSeizure = AllNeuronsAllSeizures{1, iSeizure}; % extract data for one seizure  

    fig = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);
    subplot(numRows, 1, 1); % EEG  
    voltage = EEGs{iSeizure, 1};
    time = EEGs{iSeizure, 2};
    %plot(time, voltage);
    plot(voltage);
    xlim([0,XaxisLim]); 

    % Loop through each brain structure  
    for iStructure = 1:numStructures
        structureIndices = find(labels == uniqueStructures(iStructure)); % find indexes to each structure
        OneStructure = OneSeizure(structureIndices); % extract neurons for this structure
        smallLabels = labels(structureIndices); % extract labels for this structure
        numNeurons = size(OneStructure, 1); % how many neurons total are there

        subplot(numRows, 1, iStructure + 1); % RASTER
        % Loop through each neuron
        for neuron = 1:numNeurons
            spikeTimes = OneStructure{neuron, 1};
            if ~isempty(spikeTimes) % if no spike times, skip this neuron
                % Loop through each spike time for the current neuron
                for spike = spikeTimes
                    % Plot a vertical line for each spike time
                    line([spike spike], [neuron-0.5 neuron+0.5], 'Color', 'k');
                end
            end
        end
        % Set the y-axis to display each neuron
        yticks(1:numNeurons);
        yticklabels(1:numNeurons); 
        %yticklabels(smallLabels);

        % Adjust the plot limits
        ylim([0.5, numNeurons + 0.5]); xlim([-howFarBack,howFarInto]);
        % Label axes
        xlabel('Time (s)');
        ylabel('Neuron ID');
        title([num2str(uniqueStructures(iStructure))]); % set the title of the raster as name of brain structure  

    end

    % Save each figure 
    figName = fullfile(folderPath, ['_Seizure_' num2str(iSeizure) '_Figure']);
    saveas(fig, figName, 'png');  % Save as PNG format
    %saveas(fig, figName, 'svg');  % Save as SVG format
    close(fig);  % Close the figure to avoid memory leaks
end
end