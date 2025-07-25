function plotHistoExamples(data1, data2, subPlotNums, plotTitle1, plotTitle2, legend1, legend2, color1, color2)
% parent function: extractAndPlotPhaseFromDataBase.m

%%
subplot(subPlotNums(1), subPlotNums(2), subPlotNums(3))
    plot(data1, 'color', rgb(color1), 'linewidth', 2)
    hold on
    plot(data2, 'color', rgb(color2), 'linewidth', 2)
    plot([50, 50], [0, 1], ':', 'Color', rgb('black'))
    xticks([30:10:70])
    axis([30, 70, 0, 1])
    xticklabels([-20:10:20])
    title({plotTitle1; plotTitle2}, 'FontSize', 12)
    legend(legend1,legend2, 'location', 'southeast')