function plotTheMonster(monsterMatrix, brainStructuresYaxisInfo, myCmap, fileName)
% parent function: plotTheMonsterMatrix.m

imagesc(monsterMatrix)
hold on
for iStructure = 1:size(brainStructuresYaxisInfo,1)
    plot([1:202], ones(1,202)*brainStructuresYaxisInfo.AccumulatedLength(iStructure), 'w', 'linewidth', 1) ;
end

%%
colormap(myCmap)

zeroTicks = find(brainStructuresYaxisInfo.MatrixLength>0) ;
theTicks = brainStructuresYaxisInfo.Yticks(zeroTicks) ;
yticks(theTicks) ;
yticklabels(brainStructuresYaxisInfo.Structures )

axis([50, 150, 0 size(monsterMatrix,1)])
set(gca,'TickLabelInterpreter','none', 'fontSize', 6)

set(gcf, 'units', 'normalized', 'position', [0.01, 0.01, 0.3, 0.9])

%% save
exportgraphics(gcf, fileName) ;
close all ;