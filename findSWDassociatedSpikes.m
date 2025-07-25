function SWDspikeTable = findSWDassociatedSpikes(searchStart, searchEnd, mappedKSUnits, unitType)
% parent function: spikesAndSeizures.m

% save('/home/mark/matlab_temp_variables/neuronTable') ;
% ccc
% load('/home/mark/matlab_temp_variables/neuronTable') ;

%% extract relevant units
units = mappedKSUnits.(unitType) ;

if ~isempty(units)
    %% search (remember, 'clusters' are 'neurons')
    for iCluster = 1:size(units,1)
        clusterSpikeTimes = units.SpikeTimesSec{iCluster} ;
        SWDspikeIDX{iCluster,1} = find(clusterSpikeTimes >= searchStart & clusterSpikeTimes <= searchEnd)  ;
        if ~isempty(SWDspikeIDX{iCluster,1})
            SWDspikeTimes{iCluster,1} = clusterSpikeTimes(SWDspikeIDX{iCluster,1}) ;
        else
            SWDspikeTimes{iCluster,1} = [] ;
        end
    end
else
    SWDspikeTimes = [] ;
end

%% SWD spike table
SWDspikeTable = units ;
SWDspikeTable = removevars(SWDspikeTable, {'SpikeTimesSec'; 'IDXofUncuratedSpikeVector'}) ;
SWDspikeTable.SWD_Spikes = SWDspikeTimes ;