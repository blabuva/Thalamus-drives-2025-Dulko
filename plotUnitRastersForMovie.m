function plotUnitRastersForMovie(currentUnit, durIDX, timeC, numSubPlots, plotPlace, plotColor) 
% parent function: singleUnitsMovie.m

% save('/home/mark/matlab_temp_variables/unitPlots')
% ccc
% load('/home/mark/matlab_temp_variables/unitPlots')

%% plot unit channel 
subplot(numSubPlots, 1, plotPlace)
    units = currentUnit.units.unitsPad{1} ;
    for iUnit = 1:length(units)
        plot([units(iUnit), units(iUnit)], [0, 1], 'color', rgb(plotColor), 'linewidth', 3)
        hold on
    end

     box off ; axis off ;
    
