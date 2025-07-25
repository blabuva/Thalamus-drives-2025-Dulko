function currentSeizure = brainSpikeHisto_FF(currentSeizure, timePad, histSizeMS)
% parent function: loadBrainSikes.m

% save('/home/mark/matlab_temp_variables/ABS')
% ccc
% load('/home/mark/matlab_temp_variables/ABS')


%% get time of first SWD peak
timeFirstPeak = currentSeizure.theSeizure.seizureStartTime  ;

%% define histogram bins (in sec)
histSizeSec = histSizeMS/1000 ;
durationTimePaddedSWD = timePad + timePad + currentSeizure.theSeizure.Time{1}(end) - currentSeizure.theSeizure.seizureStartTime ;
% durationTimePaddedSWD = timePad + timePad + currentSeizure.theSeizure.Time{1}(end) - currentSeizure.theSeizure.TroughTimes{1}(1) ;

histBinsZeroed = 0:histSizeSec:durationTimePaddedSWD ;
histBinsReal = histBinsZeroed + (timeFirstPeak - timePad) ;
histBinsPlot = histBinsReal(1:end-1) - timeFirstPeak ;

%% align zeroed SWD with histogram (i.e., start with time of the first peak)
zeroedSWD = currentSeizure.theSeizure.ZeroPaddedSeizure{1} ;
startIDX = find(zeroedSWD(:,1) >= timeFirstPeak - timePad, 1) ;
endIDX = size(zeroedSWD(:,1),1) - startIDX ;

%% bin spikes into histogram and also calculate instantaneous spike frequency
if ~isempty(currentSeizure.SWD_SingleUnits)
    for iNeuron = 1:size(currentSeizure.SWD_SingleUnits.unitsPad, 1)
        theSpikes = currentSeizure.SWD_SingleUnits.unitsPad{iNeuron} ;
        [binnedSpikes(iNeuron,:), edges] = histcounts(theSpikes, histBinsReal) ;
        instantSpikeFreq{iNeuron}(:,1) =  theSpikes(1:end-1) ;
        instantSpikeFreq{iNeuron}(:,2) = 1./(diff(theSpikes)) ;
        clear theSpikes
    end 
else
    binnedSpikes = [] ;
    edges = [] ;
    instantSpikeFreq = [] ;
end

%% sum of the binned spikes across neurons
summedBinnedSpikes = sum(binnedSpikes) ;

%% average of the binned spikes across neurons
meanBinnedSpikes = mean(binnedSpikes) ;

%% append histogram and frequency data into currentSWD
currentSeizure.PSTH.allNeurons.counts = binnedSpikes ;
currentSeizure.PSTH.allNeurons.edges = edges ;
currentSeizure.PSTH.sum.counts = summedBinnedSpikes ;
currentSeizure.PSTH.sum.edges = edges ;
currentSeizure.PSTH.average.counts = meanBinnedSpikes ;
currentSeizure.PSTH.average.edges = edges ;
currentSeizure.PSTH.bins.histBinsReal = histBinsReal ;
currentSeizure.PSTH.bins.histBinsPlot = histBinsPlot ;
currentSeizure.InstFF.allNeurons = instantSpikeFreq ;






