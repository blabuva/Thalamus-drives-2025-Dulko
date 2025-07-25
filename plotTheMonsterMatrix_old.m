function plotTheMonsterMatrix(monsterMatrix, brainStructuresYaxisInfo, SWDexample)
% parent function = monsterUnitPhase.m

%% for Ela's plot changes:
% save('/home/mark/matlab_temp_variables/plotMonster_FOR-ELA')
% ccc
% load('/home/mark/matlab_temp_variables/plotMonster_FOR-ELA')

%% original:
save('/home/mark/matlab_temp_variables/plotMonster')
ccc
load('/home/mark/matlab_temp_variables/plotMonster')

%% subplot params
plotH = 5 ;
plotW = 2 ;

%% plot example SWD
subplot(plotH, plotW, 1)
    plot(SWDexample.timeC, SWDexample.eeg, 'k', 'linewidth', 3)
    axis([-50, 50, -inf inf])

%% plot the monster
subplot(plotH, plotW, 3:2:9)
    plotTheMonster(monsterMatrix, brainStructuresYaxisInfo)

%% calculate monster line summary
for iRow = 1:size(monsterMatrix,1)
    histogram_data = monsterMatrix(iRow,50:150) ;
    bin_edges = 0:1:length(histogram_data);
    % calculate centroid of vector
    % Calculate the center of mass
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
    center_of_mass = (sum(histogram_data .* bin_centers) / sum(histogram_data)) -50;
    allCenters(iRow,:) = [iRow, center_of_mass, sum(histogram_data)] ;
    clear bin_centers bin_edges center_of_mass histogram_data
end

%% plot
allCentersFlip = flipud(allCenters) ;
allCentersTable = array2table(allCentersFlip, 'VariableNames', {'RowNum', 'Centroid', 'NumSpikes'}) ;
allCentersTable.SmoothCentroid = smooth(allCentersTable.Centroid, 20) ;

%% temp plot
Quants = quantile(allCentersFlip(:,3), 3)  ;

allCentersTable = colorThoseQuants(allCentersTable, Quants) ;

smoothAllcenters = smooth(allCenters(:,2), 1) ;
subplot(plotH, plotW, 4:2:10)
    for iRow = 1:size(allCentersTable,1)
        plot(allCentersTable.SmoothCentroid(iRow), allCentersTable.RowNum(iRow), 'Marker', '.' , 'color', rgb(allCentersTable.Color{iRow}))

%         pause(0.1)
        hold on
    end
    plot([0, 0], [0, size(monsterMatrix, 1)], 'k')
    axis([-50 50 1 size(monsterMatrix, 1)])
% plot([center_of_mass, center_of_mass], [0, max(histogram_data)], 'r')
        set(gcf, 'Units', 'normalized', 'position', [0.1, 0.3, 0.3, 0.6])

%%

% 
