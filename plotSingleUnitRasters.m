function  plotUnitRasters(singles, xMinFloor, xMaxCeil, plotColor, titleFontSize)

%% define raster tick size
yMinMax = [0.5, 1.5] ;

%% make rasters
for iSingle = 1:size(singles,1)
    currentSpikes = singles.unitsPad{iSingle} ;
    for iSpike = 1:length(currentSpikes)
        plot([currentSpikes(iSpike), currentSpikes(iSpike)], yMinMax, 'r')
        hold on            
    end
    yMinMax = yMinMax +1 ;    
    clear currentSpikes
end
yticks([1:size(singles,1)]) ;
yticklabels(singles.ClusterID)
ylabel('Neuron ID')
axis([xMinFloor, xMaxCeil, 0, yMinMax(2)-0.5])
title(sprintf('Single Units (%i)', size(singles,1)), 'Interpreter', 'none', 'FontSize', titleFontSize)