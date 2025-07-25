function plotSortedFRSWD_vsNonSWD(meanFiringRates,meanFiringRates_NonS,stdDev,stdDev_NonS)
% parent function: calcMeanFR_ela.m 

% [~, sortIndex] = sort(meanFiringRates); % default (ascending) 

% sort based on the difference, from the most negative to most positive 
difference = []; 
difference = meanFiringRates_NonS-meanFiringRates; 
[~, sortIndex] = sort(difference); 


sortedMeanSeizures = meanFiringRates(sortIndex); 

% apply the same sort order to baseline 
sortedBaseline = meanFiringRates_NonS(sortIndex); 
% apply the same order to Data Counts 
sortedDataCounts = dataCounts(sortIndex); 


% apply the same order to labels 
charLabels = cellstr(groupCats);  % Now it's a cell array of character vectors
charLabels = charLabels';  

sortedLabels = charLabels(sortIndex); 
sortedLabels = sortedLabels'; 
sortedLabels = categorical(sortedLabels,sortedLabels); % weird but this line is necessary to sort correctly

figure; hold on;
% Plot using scatter FOR SEIZURES 
scatter(sortedMeanSeizures, sortedLabels, stDev(sortIndex)*20, 'filled', ...
    'MarkerFaceColor','[0 0 1', 'MarkerFaceAlpha', 0.6);  % Scale dot size by count (adjust 10 for visibility)
% Plot using scatter FOR NON-SEIZURES 
scatter(sortedBaseline, sortedLabels, stDev_NonS(sortIndex)*20, 'filled', ...
    'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerFaceAlpha', 0.6);  % Scale dot size by count (adjust 10 for visibility)
xline(5,'--k'); 
xline(30,'-k');
xlim([0,30]); 
xlabel('Firing Rate');
ylabel('Brain Structure');
title('Firing Rates For seizures and non-seizures SORTED (Dot Size = stDev)');

forDataPath = ('/media/elaX/Publications/Figures/Figure2_FiringRate/');
svgFileName = fullfile(forDataPath, ['FiringChangeScatter_sorted','.svg']);
        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

