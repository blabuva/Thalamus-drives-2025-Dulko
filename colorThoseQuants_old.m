function allCentersTable = colorThoseQuants(allCentersTable, Quants) 
% parent function: plotTheMonsterMatrix.m

% save('/home/mark/matlab_temp_variables/CQ')
% ccc
% load('/home/mark/matlab_temp_variables/CQ')

for iRow = 1:size(allCentersTable,1)
    numSpikes = allCentersTable.NumSpikes(iRow) ;
    if numSpikes <= Quants(1)
        allCentersTable.Color{iRow} = 'Black' ;
    elseif numSpikes <= Quants(2)
        allCentersTable.Color{iRow} = 'Blue' ;
    elseif numSpikes <= Quants(3)
        allCentersTable.Color{iRow} = 'Yellow' ;
    else
        allCentersTable.Color{iRow} = 'Red' ;
    end
end