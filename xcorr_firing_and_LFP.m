function [Dots] = xcorr_firing_and_LFP(firingRates, EEGs, numSeizures, uniqueStructures, iMouse) 
% parent function: Phase_ela.m 

% Establish time ranges: 
numRanges = 6;
range1 = [20, 59];
range2 = [60, 99];
range3 = [100, 139];
range4 = [140, 179];
range5 = [180, 219];
range6 = [220, 260];
ranges = {range1, range2, range3, range4, range5, range6};

% Loop through brain structures in this recording  

Dots = []; % will store data for all brain structures in this mouse

for iStructure = 1:size(uniqueStructures,1)

    currentStructure = uniqueStructures{iStructure};

    % Collect and store peak firing and peak LFP for this brain structure
    AllPeaks = zeros(numSeizures, numRanges, 2);  % (seizure, range, [firing, LFP])

    for iSeizure = 1:numSeizures
        figure; title(num2str(iSeizure));
        display(iSeizure);

        % add lines to specify the ranges
        for iLine = 1:6
            xline(ranges{iLine}(1),'r--');
        end

        subplot(4,1,1);
        spikeCount = firingRates{iStructure,iSeizure};
        plot(spikeCount);
        xlim([0,260]);
        hold on

        eeg = EEGs{iSeizure,1};
        indices = round(linspace(1, length(eeg), length(spikeCount))); % match EEG length to spikeCount
        downsampledeeg = eeg(indices)';

        for iRange = 1:numRanges
            range = ranges{iRange};

            % get spike subset and max
            subsetSpike = spikeCount(range(1):range(2));
            [peakVal, peakIdx] = max(subsetSpike);

            % get EEG value at that peak
            subsetEEG = downsampledeeg(range(1):range(2));
            % ver 1: grab LFP at the time
                % LFPval = subsetEEG(peakIdx);  
                % when max spike count occurs 
            % ver 2: grap MIN LFP in this range 
            LFPval = min(subsetEEG); 
   
            % store in output array
            AllPeaks(iSeizure, iRange, 1) = peakVal;
            AllPeaks(iSeizure, iRange, 2) = LFPval;

            % plot peak on histogram for visualization
            plot(range(1)+peakIdx-1, peakVal, 'ro');
        end

        subplot(4,1,2);
        plot(eeg,'b');
        %xlim([0,400]);
        xlim([0,1300]);

        subplot(4,1,3);
        plot(downsampledeeg,'k','LineWidth',1.5);
        xlim([0,260]);

        subplot(4,1,4);
        hold on
        colors = lines(numRanges);
        for iRange = 1:numRanges
            plot(AllPeaks(iSeizure, iRange, 1), AllPeaks(iSeizure, iRange, 2), '.', 'Color', colors(iRange,:), 'MarkerSize', 12);
        end
        hold off
    end
    % store
    Dots{iStructure,1} = iMouse;
    Dots{iStructure,2} = currentStructure;
    Dots{iStructure,3} = AllPeaks;

end
%% Plot for each range 
% rangeLabels = {'Range 1','Range 2','Range 3','Range 4','Range 5','Range 6'};  % optional labels
% 
% figure;
% for iRange = 1:numRanges
%     subplot(1,numRanges,iRange); 
%     hold on
% 
%     spikeVals = nan(numSeizures,1);
%     lfpVals   = nan(numSeizures,1);
% 
%     for iSeizure = 1:numSeizures
%         spikeVal = AllPeaks(iSeizure, iRange, 1);  % spike peak
%         lfpVal   = AllPeaks(iSeizure, iRange, 2);  % corresponding LFP
% 
%         spikeVals(iSeizure) = spikeVal;
%         lfpVals(iSeizure)   = lfpVal;
% 
%         scatter(spikeVal,lfpVal, 100, 'k', 'filled', 'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.4); 
%        % plot(spikeVal, lfpVal, '.', 'Color', 'k', 'MarkerSize', 15);
%        % text(spikeVal - 0.4, lfpVal, num2str(iSeizure)); add ID for each
%        % dot if you wish 
%     end
% 
%     % Fit and plot regression line
%     validIdx = ~isnan(spikeVals) & ~isnan(lfpVals);
%     if sum(validIdx) >= 2
%         p = polyfit(spikeVals(validIdx), lfpVals(validIdx), 1);  % linear fit
%         xLine = linspace(min(spikeVals)-1, max(spikeVals)+1, 100);
%         yLine = polyval(p, xLine);
%         plot(xLine, yLine, 'r-', 'LineWidth', 2);  % regression line in red
%     end
% 
%     xlabel('Firing Histogram Peak');
%     ylabel('LFP Value');
%     title(['Dot Plot for ', rangeLabels{iRange}]);  % optional
%     xlim([-15,15]); 
%     ylim([-15,15]); 
%     yline(0,'--'); 
%     xline(0,'--'); 
%     hold off
% 
% 
% end
% 
% % save .svg 
% figurePath = '/media/elaX/Publications/Figures/Figure4_PhaseForGria/1stCycle/'; 
% svgFileName = fullfile(figurePath, ['SeizureExample'  '.svg']);
% 
% saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
% 
close all 

end % function end 