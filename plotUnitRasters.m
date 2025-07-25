function  plotUnitRasters(singles, currentSeizure, timeFirstSWDspike, seizurePad, plotColor, titleFontSize, plotTitle)
               
%% define raster tick size
yMinMax = [0.5, 1.5] ;

%% make rasters
for iSingle = 1:size(singles,1)
    currentSpikes = singles.unitsPad{iSingle} ;
    for iSpike = 1:length(currentSpikes)
        plot([currentSpikes(iSpike), currentSpikes(iSpike)], yMinMax, plotColor)
        hold on            
    end
    yMinMax = yMinMax +1 ;    
    clear currentSpikes
end
yticks([1:size(singles,1)]) ;
yticklabels(singles.ClusterID)
ylabel('Neuron ID')

plot([currentSeizure.theSeizure.seizureStartTime, currentSeizure.theSeizure.seizureStartTime], [0, yMinMax(1)], 'g' ) % seizure start
plot([currentSeizure.theSeizure.TroughTimes{1}(end), currentSeizure.theSeizure.TroughTimes{1}(end)], [0, yMinMax(1)], 'g' ) % seizure end

axis([timeFirstSWDspike-seizurePad, currentSeizure.PSTH.bins.histBinsReal(end), -inf, inf])

title(sprintf('%s (%i)', plotTitle, size(singles,1)), 'Interpreter', 'none', 'FontSize', titleFontSize)