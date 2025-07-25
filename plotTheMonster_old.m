function plotTheMonster(monsterMatrix, brainStructuresYaxisInfo)

imagesc(monsterMatrix)
hold on
for iStructure = 1:size(brainStructuresYaxisInfo,1)
    plot([1:202], ones(1,202)*brainStructuresYaxisInfo.AccumulatedLength(iStructure), 'w', 'linewidth', 1) ;
end

% 
% %ww
% % make colormap
% % colors = {'red'; 'Lime'; 'Black'; 'White'; 'Yellow'} ;
% % colors = {'Black'; 'blue'; 'cyan'; 'violet'; 'fuchsia'; 'Yellow' ;'red'; 'White';} ;
colors = {'Black';  'Yellow' ; 'Yellow' ; 'Yellow' ;'red'; 'red'; 'red';'White';'White';'White'} ;
for iColor =1:length(colors)
    myCmap(iColor, :) = rgb(colors{iColor}) ;
end
colormap(myCmap)

zeroTicks = find(brainStructuresYaxisInfo.MatrixLength>0) ;
theTicks = brainStructuresYaxisInfo.Yticks(zeroTicks) ;
yticks(theTicks) ;
yticklabels(brainStructuresYaxisInfo.Structures )

axis([50, 150, 0 size(monsterMatrix,1)])
set(gca,'TickLabelInterpreter','none', 'fontSize', 6)