function  [AllNeuronsAllSeizures,AllLabelsAllSeizures,newStructures]=ProcessSeizureDataForSFC(MouseDatabase,numSeizures,whatSeizures,numStructures,filteredStructures,EEGTable)
% parent function: StartHere.m

% this code loops through all seizures in this recording and calculates
% binned firing for all valid brain structures in this seizure. Output combinedData includes rows: 
% neurons from different brain regions, and labels that include information about neuron assingment to a brain region 
% INPUT 
% numSeizures - how many seizures are there 
% MouseDatabase - seizures, neurons for one mouse only 

% OUTPUT 
AllNeuronsAllSeizures = cell(1, numSeizures);  % Initialize cell array for storing binned spikes for multiple brain structures 
AllLabelsAllSeizures = cell(1,numSeizures); % Initialize cell array for storing labels for neurons 
% newStructures - some structures will not fire during. If they are empty they will be removed from valid_pairs  

% Parameters to change: 
%binSize = 0.005; 


for iSeizure = 1:numSeizures
    display(iSeizure)
    oneSeizureInd = (MouseDatabase.SeizureNumber == whatSeizures(iSeizure)); % get index for one seizure
    OneSeizure = MouseDatabase(oneSeizureInd, :); % grab data for one seizure
    %seizureStart = OneSeizure.SeizureStartTime(1); % when did this seizure start
    %seizureEnd = OneSeizure.SeizureEndTime(1); % when did this seizure start
    seizureBeggining = OneSeizure.SWD_Props{1,1}.SWD_startTime; % when did the seizure start??
    seizureEnd = seizureBeggining + OneSeizure.SeizureDuration(1); % when did this seizure end??
    SeizureTimeData = EEGTable.Time{iSeizure,1}; 
    lengthNeeded = size(SeizureTimeData,1);
    binSize = OneSeizure.SeizureDuration(1)/lengthNeeded; 
    
    edges = seizureBeggining: binSize: seizureEnd; % specify the edges
    SeizureQ = {}; % initialize Q matrix

    Labels =[]; %
    for i = 1:numStructures
        x = filteredStructures(i);
        % Index to one structure
        name = x{1,1};  % 
        nestedStructures = [OneSeizure.LumpedStructure{:}]; % Access the nested cell array containing the structure names
        % Find the indices where the nested structure names match the specified name
        indexToStructure = strcmp(nestedStructures, name);
        OneSeizureOneStructure = OneSeizure(indexToStructure,:);
        AllSpikes = OneSeizureOneStructure.SingleUnitsAll; % all, ihn, exc neurons / structure
        spikes = AllSpikes{1,1}.all.CurrentSWD;
        numNeurons = numel(spikes(:, 1)); % Number of neurons for the current structure
        % Repeat the structure name based on the number of neurons
        structureLabel = repmat({filteredStructures(i)}, 1, numNeurons);
        Labels = [Labels, structureLabel]; % Append to the "Labels" cell array
        Binned = NaN(size(spikes,1), numel(edges)-1); % pre-popullate data with NaN
        for ni = 1:numel(spikes(:,1)); %% will look at neurons from 1 to the end
            Binned(ni,:) = histcounts(spikes.SpikeTimesSec{ni,:}, edges); % calculate how many spikes happen within each bin
        end
        %AllBinned{iStructure} = Binned;
        SeizureQ{i} = Binned; % append current structure to Q matrix for this seizure
    end

    %[neuron1,neuron2] = explanation_ED_1(Q) % code used for analysis explanation

        reorganizedQ = {};
        reorganizedQ = SeizureQ';

        % Vertically concatenate 
        combinedData = vertcat(reorganizedQ{:}); % combinedData includes binned firing rates for all neurons across all brain structures in this seizure
        AllNeuronsAllSeizures{iSeizure} = combinedData;
        AllLabelsAllSeizures{iSeizure} = Labels';
end

% Identify brain structures with non-empty data in reorganizedQ
nonEmptyIndices = ~cellfun('isempty', reorganizedQ);
% Filter filteredStructures to keep only non-empty structures
newStructures = filteredStructures(nonEmptyIndices);

end 