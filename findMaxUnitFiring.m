function maxNeuronFiringInCycles = findMaxUnitFiring(currentExperiment) 
% parent function: plotAggaUnitsPhase.m

% save('/home/mark/matlab_temp_variables/uniF')
% ccc
% load('/home/mark/matlab_temp_variables/uniF')

%% count all spikes/cycle for all neurons in experiment
jumper = 1 ;
for iSWD = 1:length(currentExperiment)
    currentSWD = currentExperiment{iSWD} ;
    for iNeuron = 1:size(currentSWD,1)
        currentNeuron = currentSWD(iNeuron,:) ;
        for iCycle = 1:length(currentNeuron)
            numSpikes(jumper,1) = length(currentNeuron{iCycle})  ;
            jumper = jumper +1 ;
        end
    end
end

%% find the max
maxNeuronFiringInCycles = max(numSpikes) ;

% sortSpikes = sort(numSpikes, 'descend') ;
