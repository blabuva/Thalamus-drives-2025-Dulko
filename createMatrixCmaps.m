function matrixCmaps = createMatrixCmaps(monsterFields) 

%% cmaps for single cycle matrix
matrixCmaps.(monsterFields{1})(1,:)= rgb('black') ;
matrixCmaps.(monsterFields{1})(2, :) = rgb('yellow') ;

%% cmaps for cycle sum matrix
matrixCmaps.(monsterFields{2})(1, :) = rgb('black') ;
matrixCmaps.(monsterFields{2})(2, :) = rgb('DarkCyan') ;

for iColor =3:4
    matrixCmaps.(monsterFields{2})(iColor, :) = rgb('yellow') ;
end

for iColor =5:7
   matrixCmaps.(monsterFields{2})(iColor, :) = rgb('red') ;
end

for iColor =8:20
    matrixCmaps.(monsterFields{2})(iColor, :) = rgb('white') ;
end

%% cmaps for single neuron matrix
matrixCmaps.(monsterFields{3})(1, :) = rgb('black') ;
matrixCmaps.(monsterFields{3})(2, :) = rgb('DarkCyan') ;

for iColor =3:4
    matrixCmaps.(monsterFields{3})(iColor, :) = rgb('yellow') ;
end

for iColor =5:7
    matrixCmaps.(monsterFields{3})(iColor, :) = rgb('red') ;
end

for iColor =8:20
    matrixCmaps.(monsterFields{3})(iColor, :) = rgb('white') ;
end



