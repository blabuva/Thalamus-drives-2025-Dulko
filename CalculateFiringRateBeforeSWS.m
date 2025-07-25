function [spikesBeforeSeizures,numClusters] = CalculateFiringRateBeforeSWS(StructureMouseDatabase,binSize)

% 12/24 Issue that sometimes appears after lumping structures 
% Check if ther is an issue 
seizureNumbers = StructureMouseDatabase.SeizureNumber;

% Find unique numbers and their counts
[uniqueNumbers, ~, indices] = unique(seizureNumbers); % Unique numbers and indices
counts = histcounts(indices, 1:max(indices)+1); % Count occurrences of each number

% Check if any number appears more than once - THIS WILL DEFINE WHAT CODE
% WILL RUN LATER 
if any(counts > 1)
    disp('There are seizures that appear more than once - dealing with this issue now.');
    numSeizures = length(uniqueNumbers); 
    spikesBeforeSeizures = []; 
    for iSeizure = 1:numSeizures 
           % analyze seizure by seizure starting from the first one 
            iSeizure = uniqueNumbers(iSeizure); % choose the first seizure from unique ones 
            seizureLog = StructureMouseDatabase.SeizureNumber == iSeizure; % index to  all rows that include data for this seizure
            seizureData = StructureMouseDatabase(seizureLog,:); % extract rows for this data  
            allNeuronsFR = []; 
            
            seizureStartTime = seizureData.SeizureStartTime(1,:); % seizure start 
            seizureDuration = seizureData.SeizureDuration(1); % seizure duration

            for iRow = 1:size(seizureData,1) % loop through lumped structures  
                   spikeTimes = seizureData.SingleUnitsAll{iRow,1}.all.CurrentSWD.SpikeTimesSec; 
                   numClusters = size(spikeTimes,1); 
                    % Loop through clusters
                    for iCluster = 1:numClusters
                        % Your existing code for extracting spike times and calculating firing rate
                        oneSpikeTimes = spikeTimes{iCluster, 1};
                        relativeOneSpikeTimes = oneSpikeTimes - seizureStartTime;
            
                        % Logical indexing to extract spikes that are within the
                        % seizure duration (length different for every seizure) 
                        spikesInRange = relativeOneSpikeTimes <= 0 & relativeOneSpikeTimes >= -seizureDuration;
            
                        % Extract spike times within the time range
                        spikeTimesInRange = relativeOneSpikeTimes(spikesInRange);
            
                        % Calculate the firing rate
                        edges = -seizureDuration:binSize:0;
                        firingRate = histcounts(spikeTimesInRange, edges);
            
                        % Store firing rate in the corresponding cell
                        allNeuronsFR = [allNeuronsFR; firingRate];
                    end
            end
            spikesBeforeSeizures{iSeizure} = allNeuronsFR; % Store
            
    end
    numClusters = size(spikesBeforeSeizures{1,1},1); % get final number of clusters 
    
    % % re-organize data so the output is in the same format as function after "else" below  
    [spikesBeforeSeizures] = reOrganizeSpikesBeforeSeizures(spikesBeforeSeizures,numSeizures,numClusters);

     

  
else
    disp('All numbers are unique.');
    % Analyze as usual 
    numClusters = height(StructureMouseDatabase.SingleUnitsAll{1,1}.all.CurrentSWD);
    numSeizures = size(StructureMouseDatabase,1);

    % Get spikes 

    % Initialize cell array to store spikes
    spikesBeforeSeizures = cell(numClusters, numSeizures);

    % Loop through seizures
    for iSeizure = 1:numSeizures
        display(iSeizure)
        spikeTimes = StructureMouseDatabase.SingleUnitsAll{iSeizure,1}.all.CurrentSWD.SpikeTimesSec;
        seizureStartTime = StructureMouseDatabase.SeizureStartTime(iSeizure,:);
        seizureDuration = StructureMouseDatabase.SeizureDuration(iSeizure);
        % Loop through clusters
        for iCluster = 1:numClusters
            % Your existing code for extracting spike times and calculating firing rate
            oneSpikeTimes = spikeTimes{iCluster, 1};
            relativeOneSpikeTimes = oneSpikeTimes - seizureStartTime;

            % Logical indexing to extract spikes that are within the
            % seizure duration (length different for every seizure) 
            spikesInRange = relativeOneSpikeTimes <= 0 & relativeOneSpikeTimes >= -seizureDuration;

            % Extract spike times within the time range
            spikeTimesInRange = relativeOneSpikeTimes(spikesInRange);

            % Calculate the firing rate
            edges = -seizureDuration:binSize:0;
            firingRate = histcounts(spikeTimesInRange, edges);

            % Store firing rate in the corresponding cell
            spikesBeforeSeizures{iCluster, iSeizure} = firingRate;
        end
    end

end




end