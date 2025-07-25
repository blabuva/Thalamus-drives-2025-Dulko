function phaseData = binRawPhases(rawPhases, binSize) 

% save('/home/mark/matlab_temp_variables/aggRAQW')
% ccc
% load('/home/mark/matlab_temp_variables/aggRAQW')

%% create bin windoes
binRanges = 0:binSize:1 ;

%% create table
for iNeuron = 1:size(rawPhases,1)
    phaseData.phasePerNeuron{iNeuron,1} = [] ;
end
phaseData.phasePerNeuron = array2table(phaseData.phasePerNeuron, 'VariableNames', {'RawPhase'}) ;

%% append bin params
phaseData.binParams.binSize = binSize ;
phaseData.binParams.binRanges = binRanges ;

%% group all phases together, regardless of cycle, and bin the data
for iNeuron = 1:size(rawPhases,1)
    phases = [] ;
    for iCycle = 1:size(rawPhases,2)
        if ~isempty(rawPhases{iNeuron, iCycle})
            phases = [phases, rawPhases{iNeuron, iCycle}] ; 
            allCycles(iCycle,:) = histc(rawPhases{iNeuron, iCycle}, binRanges) ;
        else
            allCycles(iCycle,:) = zeros(1,length(binRanges)) ;
        end
    end
    phaseData.phasePerNeuron.BinnedPhasePerCycle{iNeuron} = allCycles ;
    phaseData.phasePerNeuron.RawPhase{iNeuron}= phases ;
    phaseData.phasePerNeuron.BinnedPhaseAllCycles{iNeuron} = histc(phases, binRanges)  ;
    clear allCycles
end


