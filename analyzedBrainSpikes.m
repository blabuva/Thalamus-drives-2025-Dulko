function currentSWD = analyzedBrainSpikes(currentSWD, timePad)
% parent function: loadBrainSikes.m

% save('/home/mark/matlab_temp_variables/ABS')
% ccc
% load('/home/mark/matlab_temp_variables/ABS')


%% get time of first SWD peak
timeFirstPeak = currentSWD.theSeizure.TroughTimes{1}(1)  ;

%% define histogram bins
histSizeMS = 50 ;
histSizeSec = histSizeMS/1000 ;
durationTimePaddedSWD = timePad + timePad + currentSWD.theSeizure.Time{1}(end) - currentSWD.theSeizure.TroughTimes{1}(1) ;
histBinsZeroed = 0:histSizeSec:durationTimePaddedSWD ;
histBinsReal = histBinsZeroed + (timeFirstPeak - timePad) ;
histBinsPlot = histBinsReal(1:end-1) - timeFirstPeak ;

%% align zeroed SWD with histogram (i.e., start with time of the first peak)
zeroedSWD = currentSWD.theSeizure.ZeroPaddedSeizure{1} ;
startIDX = find(zeroedSWD(:,1) >= timeFirstPeak - timePad, 1) ;
endIDX = size(zeroedSWD(:,1),1) - startIDX ;

%% bin spikes into histogram and also calculate instantaneous spike frequency
for iNeuron = 1:size(currentSWD.SWD_SingleUnits.unitsPad, 1)
    theSpikes = currentSWD.SWD_SingleUnits.unitsPad{iNeuron} ;
    [binnedSpikes(iNeuron,:), edges] = histcounts(theSpikes, histBinsReal) ;
    instantSpikeFreq{iNeuron}(:,1) =  theSpikes(1:end-1) ;
    instantSpikeFreq{iNeuron}(:,2) = 1./(diff(theSpikes)) ;
    clear theSpikes
end 

%% sum of the binned spikes across neurons
summedBinnedSpikes = sum(binnedSpikes) ;

%% average of the binned spikes across neurons
meanBinnedSpikes = mean(binnedSpikes) ;

%% append histogram and frequency data into currentSWD
currentSWD.PSTH.allNeurons.counts = binnedSpikes ;
currentSWD.PSTH.allNeurons.edges = edges ;
currentSWD.PSTH.sum.counts = summedBinnedSpikes ;
currentSWD.PSTH.sum.edges = edges ;
currentSWD.PSTH.average.counts = meanBinnedSpikes ;
currentSWD.PSTH.average.edges = edges ;
currentSWD.InstFF.allNeurons = instantSpikeFreq ;


subplot(3,1,1)
    timeC = zeroedSWD(:,1) - timeFirstPeak ;
    plot(timeC(startIDX:end), zeroedSWD(startIDX:end, 2), 'k')
    axis([timeC(startIDX), histBinsPlot(end), -inf, inf])

subplot(3,1,2)
    bar(histBinsPlot, summedBinnedSpikes, 'k')
    axis([histBinsPlot(1), histBinsPlot(end), 0, inf])

subplot(3,1,3)
    bar(histBinsPlot, binnedSpikes, 'stacked')
    axis([histBinsPlot(1), histBinsPlot(end), 0, inf])

    set(gcf, 'units', 'normalized', 'position', [0.01 0.45 0.3 0.5])




