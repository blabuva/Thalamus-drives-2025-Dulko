function cellEngagementPercent = phaseTheSpikes_2(currentSeizure)

% save('/home/mark/matlab_temp_variables/PhaseSpikes')
% ccc
% load('/home/mark/matlab_temp_variables/PhaseSpikes')

%% define some plot parameters
fontSize = 12 ;

%% make color map
jetMap = jet ;
normCmapRows = [[1:size(jetMap,1)]/size(jetMap,1)]' ;

%% make norm cycle numbers
normSWDcycleNum = [[1:size(currentSeizure.RawPhases,2)]/size(currentSeizure.RawPhases,2)]' ;

%% make 0 to 1 phase plots
% plotPhaseUsing0to1(currentSeizure, fontSize, jetMap, normCmapRows, normSWDcycleNum) ;
close all 

%% calculate percent of cylces that each neuron fires at least once
clear cellEngagementPercent
for iNeuron = 1:size(currentSeizure.RawPhases,1)
    cellEngagementPercent(iNeuron,1) = size(currentSeizure.RawPhases,2) - nnz(cellfun(@isempty,currentSeizure.RawPhases(iNeuron,:))) ;
end
cellEngagementPercent = 100 * cellEngagementPercent./size(currentSeizure.RawPhases,2) ;






















