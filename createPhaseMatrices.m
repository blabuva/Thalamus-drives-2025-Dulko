function allDataTable = createPhaseMatrices(allDataTable, dataType, numHistBins) 
% parent function = monsterUnitPhase.m

for iBrainPart = 1:size( allDataTable.(dataType),1)
    if ~isempty(allDataTable.(dataType).MouseIDs{iBrainPart})
        allDataTable.(dataType).PhasePerCycleMatrix{iBrainPart} = makeAllCyclePhaseMatrix(allDataTable.(dataType).BinnedPhasesPerSWDCycle{iBrainPart}, numHistBins) ;
        allDataTable.(dataType).PhasePerSWDMatrix{iBrainPart} = makeAllSWDPhaseMatrix(allDataTable.(dataType).BinnedPhasesPerSWD{iBrainPart}, numHistBins) ;
        allDataTable.(dataType).PhasePerNeuronMatrix{iBrainPart} = makeAllNeuronPhaseMatrix(allDataTable.(dataType).BinnedPhasesSumAcrossSWDs{iBrainPart}, numHistBins) ;
        allDataTable.(dataType).PhasePerStructureMatrix{iBrainPart} = makeAllMousePhaseMatrix(allDataTable.(dataType).PhasePerNeuronMatrix{iBrainPart}) ;
    end
end
