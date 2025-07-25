function allDataTable = createPhaseMatrices(allDataTable, dataType) 
% parent function = monsterUnitPhase.m

for iBrainPart = 1:size( allDataTable.(dataType),1)
    if ~isempty(allDataTable.(dataType).MouseIDs{iBrainPart})
        allDataTable.(dataType).PerCycleMatrix{iBrainPart} = makeAllCyclePhaseMatrix(allDataTable.(dataType).BinnedPhasesPerSWDCycle{iBrainPart}) ;
        allDataTable.(dataType).PerSWDMatrix{iBrainPart} = makeAllSWDPhaseMatrix(allDataTable.(dataType).BinnedPhasesPerSWD{iBrainPart}) ;
%         monsterCycleMatrix = [monsterCycleMatrix; allDataTable.(dataType).PerCycleMatrix{iBrainPart}] ;
%         monsterSWDMatrix = [monsterSWDMatrix; allDataTable.(dataType).PerSWDMatrix{iBrainPart}] ;
% 
%         brainStructuresYaxisInfo.MatrixLength(iBrainPart) = size(allDataTable.(dataType).PerCycleMatrix{iBrainPart}, 1) ;


    end

%     brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart) = size(allDataTable.(dataType).PerCycleMatrix{iBrainPart}, 1)/2 ;
%     if iBrainPart == 1
%         brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) = brainStructuresYaxisInfo.MatrixLength(iBrainPart) ;
%         brainStructuresYaxisInfo.Yticks(iBrainPart) = brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart) ;
%     else
%         brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) = brainStructuresYaxisInfo.AccumulatedLength(iBrainPart-1) + brainStructuresYaxisInfo.MatrixLength(iBrainPart) ;
%         brainStructuresYaxisInfo.Yticks(iBrainPart) = brainStructuresYaxisInfo.AccumulatedLength(iBrainPart) - brainStructuresYaxisInfo.HalfMatrixLength(iBrainPart)  ;
%     end
%                 allDataTable.(dataType).PerSWDMatrix{iBrainPart} = makeAllSWDPhaseMatrix(allDataTable.(dataType).BinnedPhasesPerSWD{iBrainPart}) ;
        %     perSWD = data.BinnedPhasesPerSWD(iBrainPart) ;
%     summedSWD = data.BinnedPhasesSumAcrossSWDs(iBrainPart) ;
%     meanedSWD = data.BinnedPhasesMeanAcrossSWDs(iBrainPart) ;
%     end
end
