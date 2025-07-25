function twoCycleMatrix = makeAllSWDPhaseMatrix(allExperiments, numHistBins)
% parent function = monsterUnitPhase.m

% save('C:\Users\markb\Desktop\Matlab\tempVars\ALLSWDphase')
% clear all; close all; clc;
% load('C:\Users\markb\Desktop\Matlab\tempVars\ALLSWDphase')


%% make a vector that defines the border between neurons 
borderWidth = 50 ;
neuronBorderVal = -1 ;
% numHistBins = size(allExperiments{1}.EachSeizure{1},2)-1 ;
neuronBorder = ones(borderWidth, numHistBins) * neuronBorderVal ;

%% make a vector that defines the border between experiments 
exptBorderVal = -2 ;
exptBorder = ones(borderWidth, numHistBins) * exptBorderVal ;


%%
cycleMatrix = [] ;
for iExpt = 1:length(allExperiments)
    currentExpt = allExperiments{iExpt} ;
    for iNeuron = 1:size(currentExpt,1)
        if ~isempty(currentExpt.EachSeizure{iNeuron})
            cycleMatrix = [cycleMatrix; currentExpt.EachSeizure{iNeuron}(:, 1:numHistBins)] ;
        end
    end
%     cycleMatrix = [cycleMatrix; exptBorder] ;
end

%% duplicate cycleMatrix 
twoCycleMatrix = [cycleMatrix, cycleMatrix] ;