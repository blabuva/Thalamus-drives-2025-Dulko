function plotPhaseUsing0to1(currentSeizure, fontSize, jetMap, normCmapRows, normSWDcycleNum) 


subplot(6, 1, 1) % plot seizure
    startPlotIDX = find(currentSeizure.EEG.Time{1} >= currentSeizure.EEG.TroughTimes{1}(1),1) ;
    endPlotIDX = find(currentSeizure.EEG.Time{1} >= currentSeizure.EEG.TroughTimes{1}(end),1) ;
    plot(currentSeizure.EEG.Time{1}(startPlotIDX:endPlotIDX), currentSeizure.EEG.EEG{1}(startPlotIDX:endPlotIDX), 'k')
    hold on
    plot(currentSeizure.EEG.TroughTimes{1}, currentSeizure.EEG.TroughValues{1}, 'ro') ;
    axis([currentSeizure.EEG.Time{1}(startPlotIDX), currentSeizure.EEG.Time{1}(endPlotIDX), -inf, inf])
    title('All SWD Cycles', 'fontsize', fontSize)

subplot(6, 1, 2) % plot number of spikes per cycle: raw
    cycleNumber = 1:size(currentSeizure.NumSpikesPerCycle.RawNumbers,2) ;
    bar(cycleNumber, sum(currentSeizure.NumSpikesPerCycle.RawNumbers,1), 'k')
    title('Spike Count Per SWD Cycle', 'fontsize', fontSize)

subplot(6, 1, 3) % plot number of spikes per cycle: raw
    normalizedCycleNumber = cycleNumber/length(cycleNumber) ;
    bar(normalizedCycleNumber, sum(currentSeizure.NumSpikesPerCycle.RawNumbers,1), 'k')
    title('Spike Count Per Normalized SWD Cycle', 'fontsize', fontSize)

subplot(6, 1, 4)
    startPlotIDX = find(currentSeizure.EEG.Time{1} >= currentSeizure.EEG.TroughTimes{1}(2), 1) ;
    endPlotIDX = find(currentSeizure.EEG.Time{1} >= currentSeizure.EEG.TroughTimes{1}(3), 1) ;
    timeLength = length(currentSeizure.EEG.Time{1}(startPlotIDX:endPlotIDX)) ;
    normalizedTime = 0:(1/(timeLength-1)):1 ;
    plot(normalizedTime, currentSeizure.EEG.EEG{1}(startPlotIDX:endPlotIDX), 'k')
    axis([0, 1, -inf, inf])
    hold on
    plot([normalizedTime(1), normalizedTime(end)], currentSeizure.EEG.TroughValues{1}(2:3), 'ro') ;
    title('Single Normalized SWD Cycle', 'fontsize', fontSize)

%% plot phases
phaseHistBins =  [0:0.01:1] ;
subplot(6, 1, 5)
    yMinyMax = [0.5, 1.5] ;
    for iNeuron = 1:size(currentSeizure.RawPhases,1)
        for iSWDcycle = 1:size(currentSeizure.RawPhases,2)
            for iSpikes = 1:size(currentSeizure.RawPhases{iNeuron, iSWDcycle},2)
                cMapRowColor = find(normCmapRows >= normSWDcycleNum(iSWDcycle),1) ;
                spikePhase = currentSeizure.RawPhases{iNeuron, iSWDcycle}(iSpikes) ;
                plot([spikePhase, spikePhase], yMinyMax, 'color', jetMap(cMapRowColor, :))
                hold on
            end
            [phaseCounts{iNeuron,1}(iSWDcycle, :), edges] = histcounts(currentSeizure.RawPhases{iNeuron, iSWDcycle}, phaseHistBins)  ;
        end
        yMinyMax = yMinyMax +1 ;
    end
    
    axis([0, 1, 0, yMinyMax(1)])
    title('Spike Phases', 'fontsize', fontSize)

subplot(6, 1, 6)
    allPhaseHistCounts = zeros(size(phaseCounts{1},1), size(phaseCounts{1},2)) ;
    for iNeuron = 1:size(phaseCounts,1)
        allPhaseHistCounts = allPhaseHistCounts + phaseCounts{iNeuron} ;
    end
    sumBins = [sum(allPhaseHistCounts,1)]' ;
    bar(phaseHistBins(1:end-1), sumBins, 'k') 
    axis([0, phaseHistBins(end-1), 0, inf])
    title('Spike Phase Histogram', 'fontsize', fontSize)


