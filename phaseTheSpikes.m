function currentSeziure = phaseTheSpikes(currentSeizure, totalSubPlots, subPlotNums, fontSize)

% save('/home/mark/matlab_temp_variables/PhaseSpikes')
% ccc
% load('/home/mark/matlab_temp_variables/PhaseSpikes')

%%
SWDspikeTimes = currentSeizure.theSeizure.TroughTimes{1} ;

%%
for iNeuron = 1:size(currentSeizure.SWD_SingleUnits,1)
    currentSpikes = currentSeizure.SWD_SingleUnits.units{iNeuron} ;
    for iSWDspike = 1:length(SWDspikeTimes)-1
        earlySWDspike = SWDspikeTimes(iSWDspike) ;
        lateSWDspike = SWDspikeTimes(iSWDspike+1) ;
        cyclePeriod = lateSWDspike - earlySWDspike ;
        spikesInCylceIDX = find(currentSpikes>earlySWDspike & currentSpikes<lateSWDspike) ;
        if ~isempty(spikesInCylceIDX)
            for numSpikes  = 1:length(spikesInCylceIDX)                
                spikeLatency = currentSpikes(spikesInCylceIDX(numSpikes)) - earlySWDspike ;
                spikePhase(numSpikes) = spikeLatency/cyclePeriod ;
            end
            thePhases{iSWDspike} = spikePhase ;
        else
            thePhases{iSWDspike} = [] ;
        end
        numSpikesPerCycle(iSWDspike,:)  = length(thePhases{iSWDspike}) ;
    end
    currentSeizure.SpikePhases.RawPhases(iNeuron,:)= thePhases ;
    currentSeizure.SpikePhases.NumSpikesPerCycle.RawNumbers(iNeuron,:) = numSpikesPerCycle ;
    currentSeizure.SpikePhases.NumSpikesPerCycle.PercentNumbers(iNeuron,:) = 100 * (numSpikesPerCycle/sum(numSpikesPerCycle)) ;
    clear thePhases numSpikesPerCycle
end

%% make color map
jetMap = jet ;
normCmapRows = [[1:size(jetMap,1)]/size(jetMap,1)]' ;

%% make norm cycle numbers
normSWDcycleNum = [[1:size(currentSeizure.SpikePhases.RawPhases,2)]/size(currentSeizure.SpikePhases.RawPhases,2)]' ;

%%
subplot(totalSubPlots, 1, subPlotNums(1)) % plot seizure
    startPlotIDX = find(currentSeizure.theSeizure.Time{1} >= currentSeizure.theSeizure.TroughTimes{1}(1),1) ;
    endPlotIDX = find(currentSeizure.theSeizure.Time{1} >= currentSeizure.theSeizure.TroughTimes{1}(end),1) ;
    plot(currentSeizure.theSeizure.Time{1}(startPlotIDX:endPlotIDX), currentSeizure.theSeizure.EEG{1}(startPlotIDX:endPlotIDX), 'k')
    hold on
    plot(currentSeizure.theSeizure.TroughTimes{1}, currentSeizure.theSeizure.TroughValues{1}, 'ro') ;
    axis([currentSeizure.theSeizure.Time{1}(startPlotIDX), currentSeizure.theSeizure.Time{1}(endPlotIDX), -inf, inf])
    title('All SWD Cycles', 'fontsize', fontSize)

subplot(totalSubPlots, 1, subPlotNums(2)) % plot number of spikes per cycle: raw
    cycleNumber = 1:size(currentSeizure.SpikePhases.NumSpikesPerCycle.RawNumbers,2) ;
    bar(cycleNumber, sum(currentSeizure.SpikePhases.NumSpikesPerCycle.RawNumbers,1), 'k')
    title('Spike Count Per SWD Cycle', 'fontsize', fontSize)

subplot(totalSubPlots, 1, subPlotNums(3)) % plot number of spikes per cycle: raw
    normalizedCycleNumber = cycleNumber/length(cycleNumber) ;
    bar(normalizedCycleNumber, sum(currentSeizure.SpikePhases.NumSpikesPerCycle.RawNumbers,1), 'k')
    title('Spike Count Per Normalized SWD Cycle', 'fontsize', fontSize)




subplot(totalSubPlots, 1, subPlotNums(4))
    startPlotIDX = find(currentSeizure.theSeizure.Time{1} >= currentSeizure.theSeizure.TroughTimes{1}(2), 1) ;
    endPlotIDX = find(currentSeizure.theSeizure.Time{1} >= currentSeizure.theSeizure.TroughTimes{1}(3), 1) ;
    timeLength = length(currentSeizure.theSeizure.Time{1}(startPlotIDX:endPlotIDX)) ;
    normalizedTime = 0:(1/(timeLength-1)):1 ;
    plot(normalizedTime, currentSeizure.theSeizure.EEG{1}(startPlotIDX:endPlotIDX), 'k')
    axis([0, 1, -inf, inf])
    hold on
    plot([normalizedTime(1), normalizedTime(end)], currentSeizure.theSeizure.TroughValues{1}(2:3), 'ro') ;
    title('Single Normalized SWD Cycle', 'fontsize', fontSize)

%% plot phases
phaseHistBins =  [0:0.01:1] ;
subplot(totalSubPlots, 1, subPlotNums(5))
    yMinyMax = [0.5, 1.5] ;
    for iNeuron = 1:size(currentSeizure.SpikePhases.RawPhases,1)
        for iSWDcycle = 1:size(currentSeizure.SpikePhases.RawPhases,2)
            for iSpikes = 1:size(currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle},2)
                cMapRowColor = find(normCmapRows >= normSWDcycleNum(iSWDcycle),1) ;
                spikePhase = currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle}(iSpikes) ;
                plot([spikePhase, spikePhase], yMinyMax, 'color', jetMap(cMapRowColor, :))
                hold on
            end
            [phaseCounts{iNeuron,1}(iSWDcycle, :), edges] = histcounts(currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle}, phaseHistBins)  ;
        end
        yMinyMax = yMinyMax +1 ;
    end
    
    axis([0, 1, 0, yMinyMax(1)])
    title('Spike Phases', 'fontsize', fontSize)

subplot(totalSubPlots, 1, subPlotNums(6))
    allPhaseHistCounts = zeros(size(phaseCounts{1},1), size(phaseCounts{1},2)) ;
    for iNeuron = 1:size(phaseCounts,1)
        allPhaseHistCounts = allPhaseHistCounts + phaseCounts{iNeuron} ;
    end
    sumBins = [sum(allPhaseHistCounts,1)]' ;
    bar(phaseHistBins(1:end-1), sumBins, 'k') 
    axis([0, phaseHistBins(end-1), 0, inf])
    title('Spike Phase Histogram', 'fontsize', fontSize)

%% append allPhaseHistCounts to currentSeizures
currentSeizure.SpikePhases.PhaseHistCounts.Counts.All = allPhaseHistCounts ;
currentSeizure.SpikePhases.PhaseHistCounts.Counts.Sum = sumBins; 
currentSeizure.SpikePhases.PhaseHistCounts.Bins = phaseHistBins ;






















