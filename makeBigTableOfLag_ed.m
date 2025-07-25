function [BigTableOfLag,labelsBigTable,numStructures,numMice] =makeBigTableOfLag_ed(originalDB,numMice)  
% parent function: StartHere.m

allNames = {};% Initialize an empty cell array to store unique names

% Loop through each element in the cell array
for i = 1:numel(originalDB.LumpedStructure);
    display(i)
    allNames = [allNames; originalDB.LumpedStructure{i}{1,1}];
end

uniqueNames = unique(allNames);% Use unique to find unique names

labelsBigTable = uniqueNames; 
numStructures = numel(labelsBigTable); % how many brain structures are there? 
BigTableOfLag = zeros(numStructures,numStructures,numMice); % 3rd dimension is the mouse 

end