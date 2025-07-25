function brainPartColorMap = plotColorsForUnits() ;

%% get Anna Grace's excel file
brainPartColorMap = readtable('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;

%% generate color map that includes highly divergent colors (using downloaded function: maxdistcolor)
fun = @sRGB_to_OKLab;
brainPartColorMap.PlotColor = maxdistcolor(size(brainPartColorMap,1), fun) ;

% %% plot colors
% for iColor = 1:size(brainPartColorMap,1)
%     plot(iColor, 1, 'o', 'markerfacecolor', brainPartColorMap.PlotColor(iColor, :), ...
%         'markeredgecolor', brainPartColorMap.PlotColor(iColor, :), ...
%         'markersize', 20) ;
%     hold on
% end