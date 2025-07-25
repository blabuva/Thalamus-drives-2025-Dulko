function [spikesAfterSeizures] = CalculateFiringRateAfterSWS(StructureMouseDatabase, binSize)

numClusters = height(StructureMouseDatabase.SingleUnitsAll{1,1}.all.CurrentSWD);
numSeizures = size(StructureMouseDatabase,1);

% Get spikes 

    % Initialize cell array to store spikes
    spikesAfterSeizures = cell(numClusters, numSeizures);

    % Loop through seizures
    for iSeizure = 1:numSeizures
        spikeTimes = StructureMouseDatabase.SingleUnitsAll{iSeizure,1}.all.CurrentSWD.SpikeTimesSec;
        seizureStartTime = StructureMouseDatabase.SeizureStartTime(iSeizure,:);
        seizureDuration = StructureMouseDatabase.SeizureDuration(iSeizure);
        % Loop through clusters
        for iCluster = 1:numClusters
            % Your existing code for extracting spike times and calculating firing rate
            oneSpikeTimes = spikeTimes{iCluster, 1};
            relativeOneSpikeTimes = oneSpikeTimes - seizureStartTime;

            % Logical indexing to extract spikes that are within the range (here after the seizure has ended but not too far than 2*seizureDuration) 
            %spikesInRange = relativeOneSpikeTimes >= seizureDuration & relativeOneSpikeTimes <= 2*seizureDuration;
            spikesInRange = relativeOneSpikeTimes >= seizureDuration & relativeOneSpikeTimes <= 2*seizureDuration;


            % Extract spike times within the time range
            spikeTimesInRange = relativeOneSpikeTimes(spikesInRange);

            % Calculate the firing rate
            edges = seizureDuration:binSize:2*seizureDuration;
            firingRate = histcounts(spikeTimesInRange, edges);

            % Store firing rate in the corresponding cell
            spikesAfterSeizures{iCluster, iSeizure} = firingRate;
        end
    end
end