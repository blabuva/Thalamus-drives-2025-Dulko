function plotPopRasters(currentData, iNeuron, iPlot, iSWD, numSWDs, numberOfNeurons, iTempfig, currentSWD, xyLimits)                                      
% % parent function:  makeUnitPopPlots.m

% save('/home/mark/matlab_temp_variables/aggRaster')
% ccc
% load('/home/mark/matlab_temp_variables/aggRaster')

% set(0,'DefaultFigureVisible', 'on')

%% get units
units = currentData.unitsPad{1} ;

if ~isempty(units) == 1
    subaxis(numberOfNeurons, numSWDs, iPlot, 'SpacingVert',0,'SpacingHoriz', 0.005) %, 'Padding', 0)
    %% get SWD spike troughts
    troughs = currentSWD.TroughTimes{1} ;
    
    %% get seizure start/end
    seizureStart = currentSWD.TroughTimes{1}(1) ;
    seizureEnd = currentSWD.TroughTimes{1}(end) ;
    
    %% make raster
    for iUnit = 1:length(units)
        plot([units(iUnit), units(iUnit)], [0.2, 0.8], 'k') ;
        hold on
    end
    
    %% plot SWD spikes
    LWred = 2 ;
    plot([troughs(1), troughs(1)], [0, 0.2], 'r', 'linewidth', LWred)
    plot([troughs(1), troughs(1)], [0.8, 1], 'r',  'linewidth', LWred)
    plot([troughs(end), troughs(end)], [0, 0.2], 'r', 'linewidth', LWred)
    plot([troughs(end), troughs(end)], [0.8, 1], 'r',  'linewidth', LWred)
    hold on      
        
    %% set plot params
    axis([xyLimits, 0, 1])
    if iSWD == 1 
        yticks(0.5)
        yticklabels(sprintf('Neuron %i', iNeuron))
        ax = gca ;
        ax.YAxis.FontSize = 16 ;
    else
    yticklabels('')
    end

    if iNeuron < numberOfNeurons
        xticklabels('')
    end      
    box off

end 
    
if iTempfig == 1 && iNeuron ==1
    title(sprintf('SWD %i', iSWD), 'fontsize', 16)
end


                

