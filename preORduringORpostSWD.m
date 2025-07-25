function currentSeizure = preORduringORpostSWD(currentSeizure, unitType)
% parent function: singleMultiSeizurePlot.m

% save('/home/mark/matlab_temp_variables/PREpost')
% ccc
% load('/home/mark/matlab_temp_variables/PREpost')


%% get relevant data
if strcmp(unitType, 'single')
    fieldName = 'SWD_SingleUnits' ;
else
    fieldName = 'SWD_MultiUnits' ;
end

%% get SWD units (i.e., 'units') and pre/post units (i.e., 'unitsPad')
for iNeuron = 1:size(currentSeizure.(fieldName),1)
    swdUnits = currentSeizure.(fieldName).units{iNeuron} ;
    allUnits = currentSeizure.(fieldName).unitsPad{iNeuron} ;
    if ~isempty(swdUnits)
        currentSeizure.(fieldName).unitsPreSWD{iNeuron} = allUnits(find(allUnits<swdUnits(1))) ;
        currentSeizure.(fieldName).unitsDuringSWD{iNeuron} = allUnits(find(allUnits>=swdUnits(1) & allUnits <= swdUnits(end))) ;
        currentSeizure.(fieldName).unitsPostSWD{iNeuron} = allUnits(find(allUnits>swdUnits(end))) ;
    else
        currentSeizure.(fieldName).unitsPreSWD{iNeuron} = allUnits(find(allUnits<currentSeizure.theSeizure.TroughTimes{1}(1))) ;
        currentSeizure.(fieldName).unitsDuringSWD{iNeuron} = [] ;
        currentSeizure.(fieldName).unitsPostSWD{iNeuron} = allUnits(find(allUnits>currentSeizure.theSeizure.TroughTimes{1}(end))) ;
    end
end