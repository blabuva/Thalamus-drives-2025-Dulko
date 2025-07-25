function meanZscoreAll = calculateMeanZscoreForEachStructure(allNeuronsMatrix)

meanZscoreAll = mean(allNeuronsMatrix(:, 20:24), 'all');


end 