function binPhases = combinePhaseBinCounts(allSeizuresBinnedPhases)
% parent function : collectAllRawPhases.m

% save('/home/mark/matlab_temp_variables/cmonbinePhose')
% ccc
% load('/home/mark/matlab_temp_variables/cmonbinePhose')

%% get number of neurons in structure
numNeurons = size(allSeizuresBinnedPhases{1}.phasePerNeuron, 1) ;

%% loop through neurons, then seizures, then cycles
neuronNames = {} ;
for iNeuron = 1:numNeurons
    binPhasesSumCycle = [] ;
    binPhasesPerCycle = [] ;
    for iSeizure = 1:length(allSeizuresBinnedPhases)
           binPhasesSumCycle = [binPhasesSumCycle; allSeizuresBinnedPhases{iSeizure}.phasePerNeuron.BinnedPhaseAllCycles{iNeuron}] ;
           binPhasesPerCycle = [binPhasesPerCycle; allSeizuresBinnedPhases{iSeizure}.phasePerNeuron.BinnedPhasePerCycle{iNeuron}] ;
    end
    singleNeuronEachSeizure{iNeuron, 1} = binPhasesSumCycle ;
    singleNeuronEachCycle{iNeuron,1} = binPhasesPerCycle ;
    singleNeuronSummedAcrossSeizures{iNeuron, 1} = sum(binPhasesSumCycle,1) ;
    singleNeuronMeanAcrossSeizures{iNeuron, 1} = mean(binPhasesSumCycle,1) ;
    currentName = sprintf('Neuron%.02i', iNeuron) ;
    neuronNames = [neuronNames, currentName] ;
    clear currentName ;
end 


%% create table
binPhases.EachCycle = array2table(singleNeuronEachCycle, 'VariableNames', {'EachCycle'}, 'RowNames', neuronNames) ;
binPhases.EachSeizure = array2table(singleNeuronEachSeizure, 'VariableNames', {'EachSeizure'}, 'RowNames', neuronNames) ;
binPhases.SumAcrossSeizures = array2table(singleNeuronSummedAcrossSeizures, 'VariableNames', {'SumAcrossSeizures'}, 'RowNames', neuronNames) ;
binPhases.MeanAcrossSeizures = array2table(singleNeuronMeanAcrossSeizures, 'VariableNames', {'MeanAcrossSeizures'}, 'RowNames', neuronNames) ; 




