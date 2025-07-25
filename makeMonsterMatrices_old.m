function [monsterMatrix, brainStructuresYaxisInfo] = makeMonsterMatrices(allDataTable, dataType, phaseData)
% parent function = monsterUnitPhase.m


%% create empty matrices
monsterMatrix = [] ;
% monsterSWDMatrix = [] ;
brainStructuresYaxisInfo = array2table(allDataTable.(dataType).brainNames, 'VariableNames', {'Structures'}) ;

%% 
for iBrainPart = 1:size( allDataTable.(dataType),1)
    if ~isempty(allDataTable.(dataType).MouseIDs{iBrainPart})
        monsterMatrix = [monsterMatrix; allDataTable.(dataType).(phaseData){iBrainPart}] ;
        brainStructuresYaxisInfo.MatrixLength(iBrainPart) = size(allDataTable.(dataType).(phaseData){iBrainPart}, 1) ;
    end

    brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart) = size(allDataTable.(dataType).(phaseData){iBrainPart}, 1)/2 ;
    if iBrainPart == 1
        brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) = brainStructuresYaxisInfo.MatrixLength(iBrainPart) ;
        brainStructuresYaxisInfo.Yticks(iBrainPart) = brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart) ;
    else
        brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) = brainStructuresYaxisInfo.AccumulatedLength(iBrainPart-1) + brainStructuresYaxisInfo.MatrixLength(iBrainPart) ;
        brainStructuresYaxisInfo.Yticks(iBrainPart) = brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) - brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart)  ;
    end
end