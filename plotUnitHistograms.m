function  plotUnitHistograms(currentSeizure, histType, experimentInfo, titleFontSize)

    if strcmp(histType, 'stacked')
        bar(currentSeizure.PSTH.bins.histBinsPlot ,currentSeizure.PSTH.allNeurons.counts, 'stacked')
    else
        bar(currentSeizure.PSTH.bins.histBinsPlot ,currentSeizure.PSTH.sum.counts, 'k')
    end

    hold on
    plot([0, 0], [0, max(currentSeizure.PSTH.sum.counts)], 'g' ) ; % seizure start
    

    %% need to calculate seizure end because histogram is zeroed to the seizure start
    seizureEnd = currentSeizure.theSeizure.TroughTimes{1}(end) - currentSeizure.theSeizure.seizureStartTime ; 
    plot([seizureEnd, seizureEnd], [0, max(currentSeizure.PSTH.sum.counts)], 'g' ) 

    %% titles
    if strcmp(histType, 'stacked')
        title(sprintf('Stacked PSTH (BinSize: %ims)', experimentInfo.analysisParams.PSTHbinSize), 'Interpreter', 'none', 'FontSize', titleFontSize)
    else
        title(sprintf('PSTH (BinSize: %ims)', experimentInfo.analysisParams.PSTHbinSize), 'Interpreter', 'none', 'FontSize', titleFontSize)
    end


xlim([currentSeizure.PSTH.bins.histBinsPlot(1), currentSeizure.PSTH.bins.histBinsPlot(end)])
    ylabel('Spike Counts')

