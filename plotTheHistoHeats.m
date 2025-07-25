function plotTheHistoHeats(data, structureOrder, includeYlabel, subPlotNums, plotTitle1, plotTitle2)
%parent function: extractAndPlotPhaseFromDataBase.m

%% create Y axis tick labels based on structures included in the heat map
for iLabel = 1:length(structureOrder)
    if strcmp(includeYlabel, 'Y')
        theYtickLabels(iLabel) = structureOrder(iLabel) ;
    else
        theYtickLabels(iLabel) = "" ;
    end
end

%% plot heatmap
subplot(subPlotNums(1), subPlotNums(2), subPlotNums(3))
    imagesc(data)
    hold on
    plot([50,50], [0, size(data,1)], 'LineStyle','--', 'LineWidth', 2, 'Color', 'w')
    xticks(0:10:150) ;
    yticks(1:length(structureOrder)) ;
    theTicks = xticks ;
    for iTick = 1:length(theTicks)
        thePlotTicks{iTick} = num2str(theTicks(iTick)-50);
    end
    xticklabels(thePlotTicks)
    yticklabels(theYtickLabels)
    axis(-51, 50, -inf, inf)
    title({plotTitle1; plotTitle2}, 'FontSize', 12)

%% apply colormap
theCmap = colormap(gcf) ;
theCmap(1,:) = 0 ;
colormap(theCmap) ;