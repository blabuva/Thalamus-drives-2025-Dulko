function plotScatterPerStructure(Dotsss,currentStructure)
% parent function: investigateCorrBetweenFiringAndLFP.m 

rangeLabels = {'Range 1','Range 2','Range 3','Range 4','Range 5','Range 6'};  % optional labels

numRanges = 6; % Hard coded 

figure;

for iRange = 1:numRanges
    subplot(1, numRanges, iRange); 
    hold on

    % Initialize arrays to collect all spike and LFP values across all mice
    allSpikeVals = [];
    allLfpVals   = [];

    for iMouse = 1:size(Dotsss, 1)
        oneMouse = Dotsss{iMouse, 3}; % grab firing and LFP data 
        numSeizures = size(oneMouse, 1); 
        
        for iSeizure = 1:numSeizures
            spikeVals = oneMouse(iSeizure, :, 1);  % spike peaks (all ranges)
            lfpVals   = oneMouse(iSeizure, :, 2);  % corresponding LFP (all ranges) 
            
            spikeVal = spikeVals(1,iRange); % spike val in this range 
            lfpVal = lfpVals(1,iRange); % LFP val in this range 
            

            if ~isnan(spikeVal) && ~isnan(lfpVal)
                % Add to arrays for regression
                allSpikeVals(end+1) = spikeVal;
                allLfpVals(end+1)   = lfpVal;
                
                % Scatter individual point
                scatter(spikeVal, lfpVal, 100, 'k', 'filled', ...
                        'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.4); 
            end
        end
    end
    % Find mean X and mean Y, plot as a blue dot 
    meanX = mean(allSpikeVals,"all"); 
    meanY = mean(allLfpVals,"all"); 

    scatter(meanX, meanY, 100, 'blue', 'filled'); % plot mean 

    % Fit and plot regression line using all valid data points
    if numel(allSpikeVals) >= 2
        p = polyfit(allSpikeVals, allLfpVals, 1);  % linear fit
        xLine = linspace(min(allSpikeVals)-1, max(allSpikeVals)+1, 100);
        yLine = polyval(p, xLine);
        plot(xLine, yLine, 'r-', 'LineWidth', 2);  % regression line in red
    end

    xlabel('Firing Histogram Peak');
    ylabel('LFP Value');
    %title(['Dot Plot for ', rangeLabels{iRange}]);  % optional
    xlim([-1, 30]); 
    ylim([-15, 15]); 
    hold off
end

sgtitle(currentStructure,'Interpreter','none'); % set title to structure name 

% Set figure size for export
set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [5, 5, 35, 7.425]);  % [left, bottom, width, height]

% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperSize', [21, 7.425]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0, 0, 21, 7.425]);  % [left, bottom, width, height]

% save .svg 
figurePath = '/media/elaX/MyFigures/LFP/xCorrFiringAndLFP/'; 
svgFileName = fullfile(figurePath, [currentStructure, '02.svg']);       
%saveas(gcf, svgFileName, 'svg');  % Save the figure in .svg format
print(gcf, fullfile(figurePath, [currentStructure, '.svg']), '-dsvg', '-painters');


close all 



end 