function [counts9thNeuron,phaseCountsAllNeurons] = calcHistogramsPhaseExample(allExperiments,iNeuron)
% parent function: phaseExample.m 

%% Histogram for 1 neuron 
% calculate the counts for one neuron (where in the 0 - 1 range it fires) 
phases9thNeuron = allExperiments{9,1}.experimentData.SWDs.Mediodorsal_nucleus_of_thalamus.SWD{1,5}.SingleUnitPhase.SpikePhases.RawPhases(iNeuron,:);
  
allPhases = cell2mat(phases9thNeuron);
numBins = 100; 
binEdges = linspace(0,1,numBins+1); 

counts9thNeuron = histcounts(allPhases,binEdges); 
%figure; bar(binEdges(1:end-1),counts,'histc')

%% Histogram for all neurons (this seizure only) 
data = allExperiments{9,1}.experimentData.SWDs.Mediodorsal_nucleus_of_thalamus.SWD{1,5}.SingleUnitPhase.SpikePhases.RawPhases; 
allCounts = []; % for storing sums for each neuron 

for iNeu = 1:size(data,1) % from 1st to last neuron <---- run this to check how many neurons  
    phasesOneNeuon = data(iNeu,:); 
    allPhasesOneNeuron = cell2mat(phasesOneNeuon); 
    countsOneNeuron = histcounts(allPhasesOneNeuron,binEdges); 
    allCounts = [allCounts; countsOneNeuron]; 
end

phaseCountsAllNeurons = sum(allCounts,1); % calculate sum for each time bin across all neurons  

end 