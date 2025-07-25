function  [AllNeuronsAllSeizures,AllLabelsAllSeizures,newStructures]=ProcessSeizureData_phase(binSize,MouseDatabase,numSeizures,whatSeizures,numStructures,filteredStructures,howFarBack,howFarInto)
% parent function: Phase_ela.m

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

 


for iSeizure = 1:numSeizures
    display(iSeizure)
    oneSeizureInd = (MouseDatabase.SeizureNumber == whatSeizures(iSeizure)); % get index for one seizure
    OneSeizure = MouseDatabase(oneSeizureInd, :); % grab data for one seizure
    %seizureStart = OneSeizure.SeizureStartTime(1); % when did this seizure start
    %seizureEnd = OneSeizure.SeizureEndTime(1); % when did this seizure start

    % what is the time of first trough 
    TroughTimes = OneSeizure.SWD_Props{1,1}.SWD_troughTimes; 
    relTime = TroughTimes{1,1}(1); % THIS FOR SEIZURE START 
   % relTime = TroughTimes{1,1}(end); % THIS FOR SEIZURE END 

    leftEdge = relTime-howFarBack; % left edge is specified so we look 200 ms before the first trough 
    rightEdge = relTime+howFarInto; % right edge is specified so we look 200 ms into the seizure 
    edges = leftEdge: binSize: rightEdge; % specify the edges
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
        % Loop through neurons and calculate spike times relative to first
        % trough 
        RelativeTimes = cell(numNeurons, 1);
        for ni = 1:numel(spikes(:,1))
            relativeSpikeTimes = (spikes.SpikeTimesSec{ni,1} - relTime)';
            % keep spike times that fall into specified range
            % relative to first trough 
            RelativeTimes{ni} = relativeSpikeTimes(relativeSpikeTimes >= -howFarBack & relativeSpikeTimes <= howFarInto);
        end 
        % Include only the spikes that fall into specified range
        % within the first trough 
        for ni = 1:numel(RelativeTimes(:,1))
            
        end


        SeizureQ{i} = RelativeTimes; % append current structure to Q matrix for this seizure

        
        % if needed i can bin this data 
        % Binned = NaN(numNeurons, numel(edges)-1); % pre-populate data with NaN
        % for ni = 1:numNeurons
        %     Binned(ni, :) = histcounts(spikes.SpikeTimesSec{ni, :}, edges); % calculate how many spikes happen within each bin
        % end
        
        % AllBinned{i} = Binned;
        % SeizureQ{i} = Binned; % append current structure to Q matrix for this seizure
    end

    %[neuron1,neuron2] = explanation_ED_1(Q) % code used for analysis explanation

        reorganizedQ = {};
        reorganizedQ = SeizureQ';

        % Vertically concatenate 
        combinedData = vertcat(reorganizedQ{:}); % combinedData includes relative spike times of all neurons across all brain structures in this seizure
        AllNeuronsAllSeizures{iSeizure} = combinedData;
        AllLabelsAllSeizures{iSeizure} = Labels';
end

% Identify brain structures with non-empty data in reorganizedQ
nonEmptyIndices = ~cellfun('isempty', reorganizedQ);
% Filter filteredStructures to keep only non-empty structures
newStructures = filteredStructures(nonEmptyIndices);

end 