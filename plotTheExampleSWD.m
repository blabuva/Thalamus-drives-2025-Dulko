function SWDexample = plotTheExampleSWD(SWDexample, fileName)
% parent function: plotTheMonsterMatrix.m

%% unpack some variables
startPeak1 = SWDexample.forPlots.startPeak1 ;
startPeak2 = SWDexample.forPlots.startPeak2 ;
endPeak1 = SWDexample.forPlots.endPeak1 ;
endPeak2 = SWDexample.forPlots.endPeak2 ;
xAxisMin = SWDexample.forPlots.xAxisMin ;
xAxisMax = SWDexample.forPlots.xAxisMax ;

%% plot
numSubPlotRows =7 ;
subplot(numSubPlotRows, 1, 1)
    plot(SWDexample.EEG.Time, SWDexample.EEG.EEG, 'k')
    hold on
    plot(SWDexample.EEG.Time(startPeak1:endPeak1), SWDexample.EEG.EEG(startPeak1:endPeak1), 'r')
    plot(SWDexample.EEG.Time(startPeak2:endPeak2), SWDexample.EEG.EEG(startPeak2:endPeak2), 'b')
    axis([xAxisMin, xAxisMax, -inf, inf])

subplot(numSubPlotRows, 1, 2)
    for iUnit = 1:length(SWDexample.Units)
        plot([SWDexample.Units(iUnit), SWDexample.Units(iUnit)], [0, 1], 'color', rgb('black'))
        hold on
    end

    for iUnit = 164:165
        plot([SWDexample.Units(iUnit), SWDexample.Units(iUnit)], [0, 1], 'color', rgb('red'), 'linewidth', 2)
        hold on
    end

    for iUnit = 172:173
        plot([SWDexample.Units(iUnit), SWDexample.Units(iUnit)], [0, 1], 'color', rgb('blue'), 'linewidth', 2)
        hold on
    end

    axis([xAxisMin, xAxisMax, 0, 1])   

subplot(numSubPlotRows, 1, 3)
    cyclePad = 0.05 ;
%     cyclePad = 0 ;
    plot(SWDexample.EEG.Time, SWDexample.EEG.EEG, 'k')
    hold on
    plot(SWDexample.EEG.Time(startPeak1:endPeak1), SWDexample.EEG.EEG(startPeak1:endPeak1), 'r', 'linewidth', 2)
    for iUnit = 1:length(SWDexample.Units)
        plot([SWDexample.Units(iUnit), SWDexample.Units(iUnit)], [-15, -9], 'r', 'linewidth', 3)
    end
    axis([SWDexample.theCycle.Cycle1.Times(1)-cyclePad, SWDexample.theCycle.Cycle1.Times(2)+cyclePad, -12, inf])

subplot(numSubPlotRows, 1, 4)
    plot(SWDexample.EEG.Time, SWDexample.EEG.EEG, 'k')
    hold on
    plot(SWDexample.EEG.Time(startPeak2:endPeak2), SWDexample.EEG.EEG(startPeak2:endPeak2), 'b', 'linewidth', 2)
    for iUnit = 1:length(SWDexample.Units)
        plot([SWDexample.Units(iUnit), SWDexample.Units(iUnit)], [-15, -9], 'b', 'linewidth', 3)
    end
    axis([SWDexample.theCycle.Cycle2.Times(1)-cyclePad, SWDexample.theCycle.Cycle2.Times(2)+cyclePad, -12, inf])   

subplot(numSubPlotRows, 1, 5)
    cyclePad = 0.2747 ;
    cycleDur = (endPeak2 - startPeak2)/1000 ;
    cycleDurIDX = find(SWDexample.EEG.Time - SWDexample.EEG.Time(1) >= cycleDur, 1) ;
    normedPreEEG = SWDexample.EEG.EEG(startPeak2 - cycleDurIDX+1 :startPeak2) ;
    normedPostEEG = SWDexample.EEG.EEG(endPeak2 : endPeak2 + cycleDurIDX-1) ;
%     plot(SWDexample.EEG.Time, SWDexample.EEG.EEG, 'k')
    normedEEG = [normedPreEEG; SWDexample.EEG.EEG(startPeak2:endPeak2); normedPostEEG] ;
    normedTime = -100:100/(cycleDurIDX):200 ;
    zeroIDX = find(normedTime >= 0,1) ;
    hundredIDX = find(normedTime >=100, 1) ;
    plot(normedTime(1:length(normedTime)-1)/100, normedEEG, 'k')
    hold on
    plot(normedTime(zeroIDX:hundredIDX)/100, normedEEG(zeroIDX:hundredIDX), 'color', rgb('green'), 'linewidth', 2)

    for iUnit = 1:length(SWDexample.Phases.Raw.Cycle1)
        plot([SWDexample.Phases.Raw.Cycle1(iUnit), SWDexample.Phases.Raw.Cycle1(iUnit)], [-15, -8], 'r', 'linewidth', 3)
        hold on
    end
    for iUnit = 1:length(SWDexample.Phases.Raw.Cycle2)
        plot([SWDexample.Phases.Raw.Cycle2(iUnit), SWDexample.Phases.Raw.Cycle2(iUnit)], [-8, -3], 'b', 'linewidth', 3)
    end

    axis([0-cyclePad, 1+cyclePad, -12, 12]) 

%% for histograms in plot
theHistCounts = [] ;
for iCycle = 1:length(SWDexample.Phases.Raw.AllCycles)
    currentCycle = SWDexample.Phases.Raw.AllCycles{iCycle} ;
    if ~isempty(currentCycle)
    theHistCounts = [theHistCounts; histcounts(currentCycle, [0:0.01:1])] ;
    end
end
 
 subplot(numSubPlotRows, 1, 6)
 cyclePad = cyclePad*100 ;
    bar(sum(theHistCounts,1), 'k')
    axis([0-cyclePad, 100+cyclePad, 0, inf])   

 subplot(numSubPlotRows, 1, 7)
 heatMapCounts = [zeros(22, 27), theHistCounts, zeros(22, 27)] ;
 imagesc(heatMapCounts)
 myCmap(1, :) = rgb('black') ;
 myCmap(2, :) = rgb('yellow') ;
 colormap(myCmap)
% axis([0-cyclePad, 100+cyclePad, -inf, inf])  

set(gcf, 'units', 'normalized', 'position', [0.01, 0.01, 0.3, 0.9])

%%
SWDexample.normedCycle.normedTime = normedTime(1:length(normedEEG)) ;
SWDexample.normedCycle.normedEEG = normedEEG ;

%%
exportgraphics(gcf, fileName) ;
close all ;
