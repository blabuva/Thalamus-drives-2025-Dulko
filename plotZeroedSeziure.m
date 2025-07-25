function plotZeroedSeziure(brainStructure, currentSeizure, timeFirstSWDspike, seizurePad, iSeizure, plotColor, titleFontSize)


%% exttact time and EEG
timeC = currentSeizure.theSeizure.ZeroPaddedSeizure{1}(:,1) ;
EEG = currentSeizure.theSeizure.ZeroPaddedSeizure{1}(:,2) ;

plot(timeC, EEG, plotColor) % the seizure
hold on
plot(currentSeizure.theSeizure.TroughTimes{1}, currentSeizure.theSeizure.TroughValues{1}, 'ro', 'markersize', 10) % troughs
plot([currentSeizure.theSeizure.seizureStartTime, currentSeizure.theSeizure.seizureStartTime], [min(EEG), max(EEG)], 'g' ) %seizure start
plot([currentSeizure.theSeizure.TroughTimes{1}(end), currentSeizure.theSeizure.TroughTimes{1}(end)], [min(EEG), max(EEG)], 'g' ) %seizure end

axis([timeFirstSWDspike-seizurePad, currentSeizure.PSTH.bins.histBinsReal(end), -inf, inf])

title(sprintf('%s: Seizure #%i', brainStructure, iSeizure), 'Interpreter', 'none', 'FontSize', titleFontSize)