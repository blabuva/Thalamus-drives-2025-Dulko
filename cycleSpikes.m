function spikeTimes = cycleSpikes(neuron, troughTimes) 
% parent function: calculatePhaseFromDataBase.m

% save('/home/mark/matlabTemp/cycleP')
% ccc
% load('/home/mark/matlabTemp/cycleP')

 spikeTimesWithinStartEndSWDidx = find(neuron.SpikeTimes{1} >= troughTimes(1) & neuron.SpikeTimes{1} <= troughTimes(end)) ;
 spikesSWD = neuron.SpikeTimes{1}(spikeTimesWithinStartEndSWDidx) ;

%% loop through individual neurons (ClusterID)
spikeCount = 1 ;
if ~isempty(spikesSWD)
   
    % extract spike times
    spikeTimes = array2table(spikesSWD, 'VariableNames', {'SpikeTimes'}) ;

    % loop through cycles
    for iCycle = 1:length(troughTimes)-1
        % get cycle info
        cycleStart = troughTimes(iCycle) ;
        cycleEnd = troughTimes(iCycle+1) ;
        cyclePeriod = cycleEnd - cycleStart ;
    
        % extract spikes occurring within a cycle
        if iCycle < length(troughTimes)-1
            spikesWithinCycle = find(spikeTimes.SpikeTimes >= cycleStart & spikeTimes.SpikeTimes < cycleEnd) ;
        else
            spikesWithinCycle = find(spikeTimes.SpikeTimes >= cycleStart & spikeTimes.SpikeTimes <= cycleEnd) ;
        end

        if iCycle == 1
            c = 1;
        end
        % calculate phase of spikes
        if ~isempty(spikesWithinCycle)
            for iSpike = 1:length(spikesWithinCycle)
                absSpikeTime = spikeTimes.SpikeTimes(spikesWithinCycle(iSpike)) ;
                relSpikeTime = absSpikeTime - cycleStart ;
                spikeTimes.CycleNumber(spikeCount) = iCycle ;
                spikeTimes.CycleStart(spikeCount) = cycleStart ;
                spikeTimes.CycleEnd(spikeCount) = cycleEnd ;
                spikeTimes.Phase(spikeCount) = relSpikeTime/cyclePeriod ;
                spikeCount = spikeCount +1 ;
            end        
        end
        clear spikesWithinCycle cycleStart cycleEnd cyclePeriod
    end
else
    spikeTimes = [] ;
end

