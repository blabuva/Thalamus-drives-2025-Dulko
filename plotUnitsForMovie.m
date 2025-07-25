function plotUnitsForMovie(currentUnit, durIDX, timeC, numSubPlots, plotPlace, plotColor) 
% parent function: singleUnitsMovie.m

% save('/home/mark/matlab_temp_variables/unitPlots')
% ccc
% load('/home/mark/matlab_temp_variables/unitPlots')

%% plot unit channel 
subplot(numSubPlots, 1, plotPlace)
    plot(timeC, currentUnit.channel, 'color', rgb('black'))
    hold on
    units = currentUnit.units.unitsPad{1} ;
    for iUnit = 1:length(units)
        unitIDX = find(timeC >= units(iUnit),1) ;
        startIDX = unitIDX - durIDX ;
        endIDX = unitIDX + durIDX ;
        plot(timeC(startIDX:endIDX), currentUnit.channel(startIDX:endIDX), 'color', rgb('red'), 'linewidth', 2)
        clear unitIDX startIDX endIDX
    end

     box off ; axis off ;
    
