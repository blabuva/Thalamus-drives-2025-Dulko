%%
ccc

%% load data
load('/home/mark/matlab_temp_variables/currentSeizure', 'currentSeizure') ;

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


%% plot phases
subplot(2,1,1)
phaseHistBins =  [0:0.01:1] ;
    yMinyMax = [0.5, 1.5] ;
    for iNeuron = 1:size(currentSeizure.SpikePhases.RawPhases,1)
        for iSWDcycle = 1:size(currentSeizure.SpikePhases.RawPhases,2)
            for iSpikes = 1:size(currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle},2)
               
                spikePhase = currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle}(iSpikes) ;
                plot([spikePhase, spikePhase], yMinyMax, 'k', 'lineWidth', 2)
                hold on
            end
            [phaseCounts{iNeuron,1}(iSWDcycle, :), edges] = histcounts(currentSeizure.SpikePhases.RawPhases{iNeuron, iSWDcycle}, phaseHistBins)  ;
        end
        yMinyMax = yMinyMax +1 ;
    end

 %% make color maps
jetMap = jet ;
normCmapRows = [[1:size(jetMap,1)]/size(jetMap,1)]' ;
colorStepsForBars = floor(size(jetMap,1)/size(phaseCounts,1)) ;
barColorsTemp = jetMap(1:colorStepsForBars:256, :) ;
barColors = barColorsTemp(1:size(phaseCounts, 1)-1, :) ;
barColors(size(phaseCounts, 1), :) = jetMap(end,:) ;

subplot(2,1,2) 
for iNeuron = 1 :size(phaseCounts, 1)
    thetaSpike = sum(phaseCounts{iNeuron},1) ;
    thetaRads = thetaSpike*2*pi ;
    polarhistogram(thetaSpike, 10, 'FaceColor', barColors(iNeuron,:), 'FaceAlpha', .3)
    set(gcf, 'units', 'normalized', 'position', [0.1 0.5 0.2 0.5])
%     pause(1)
    hold on
end
