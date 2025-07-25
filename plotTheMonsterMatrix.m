function plotTheMonsterMatrix(theMonsters, structureCentroid, SWDexample)
% parent function = monsterUnitPhase.m

%% for Ela's plot changes:
% save('/home/mark/matlab_temp_variables/plotMonster_FOR-ELA')
% ccc ;
% load('/home/mark/matlab_temp_variables/plotMonster_FOR-ELA')


%% plot example SWD that describes how matrices are generated
fileName = '/media/markX/ela/examplePhaseSWD.eps' ;
SWDexample = plotTheExampleSWD(SWDexample, fileName) ;

%% get monster fields
monsterFields = fieldnames(theMonsters) ;

%% create colormap for matrices
matrixCmaps = createMatrixCmaps(monsterFields) ;

%% plot matrices aligned to the SWD spike
for iMonster = 1:length(monsterFields)-1
    % plot example
    subplot(5, 1, 1)
        plot(SWDexample.normedCycle.normedTime, SWDexample.normedCycle.normedEEG, 'k', 'linewidth', 3)
        axis([-50, 50, -inf inf])
    
    % plot the matrix
    subplot(5, 1, 2:5)  
        fileName = sprintf('/media/markX/ela/%s.eps', monsterFields{iMonster}) ;
        plotTheMonster(theMonsters.(monsterFields{iMonster}).Matrix, theMonsters.(monsterFields{iMonster}).brainStructuresYaxisInfo, matrixCmaps.(monsterFields{iMonster}), fileName)
    
     clear fileName
end

%% plot horizontal bar plot for structure summaries
% plot example
subplot(5, 1, 1)
    plot(SWDexample.normedCycle.normedTime, SWDexample.normedCycle.normedEEG, 'k', 'linewidth', 3)
    axis([-20, 20, -inf inf])

% plot bars    
subplot(5, 1, 2:5)
    barh(flipud(cell2mat(structureCentroid)))
    axis([-20, 20, -inf, inf])

% set figure position
set(gcf, 'units', 'normalized', 'position', [0.01, 0.01, 0.3, 0.9])

% save
fileName = '/media/markX/ela/structureBarPlot.eps' ;
exportgraphics(gcf, fileName) ;
close all ;

%% calculate centroid summary for matrix plot
allCentersTable = calcMatrixCentroids(theMonsters) ;

%% plot centroids aligned to SWD spike
subplot(5, 1, 1)
    plot(SWDexample.normedCycle.normedTime, SWDexample.normedCycle.normedEEG, 'k', 'linewidth', 3)
    axis([-50, 50, -inf inf])

subplot(5, 1, 2:5)
    for iRow = 1:size(allCentersTable,1)
        plot(allCentersTable.SmoothCentroid(iRow), iRow, 'Marker', '.' , 'color', rgb(allCentersTable.Color{iRow}))
        hold on
    end
    plot([0, 0], [0, size(theMonsters.monsterSWD.Matrix, 1)], 'k')
    axis([-50 50 1 size(theMonsters.monsterSWD.Matrix, 1)])

% set figure position
set(gcf, 'units', 'normalized', 'position', [0.01, 0.01, 0.3, 0.9])

% save
fileName = '/media/markX/ela/centroidPhaseSWD.eps' ;
exportgraphics(gcf, fileName) 
close all

