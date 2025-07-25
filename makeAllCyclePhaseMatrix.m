function twoCycleMatrix = makeAllCyclePhaseMatrix(allExperiments, numHistBins) 
% parent function = monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/allCycleMatrix')
% ccc
% load('/home/mark/matlab_temp_variables/allCycleMatrix')

%% make a vector that defines the border between neurons 
borderWidth = 50 ;
neuronBorderVal = -1 ;
% numHistBins = size(allExperiments{1}.EachCycle{1},2)-1 ;
neuronBorder = ones(borderWidth, numHistBins) * neuronBorderVal ;

%% make a vector that defines the border between experiments 
exptBorderVal = -2 ;
exptBorder = ones(borderWidth, numHistBins) * exptBorderVal ;


%%
cycleMatrix = [] ;
for iExpt = 1:length(allExperiments)
    currentExpt = allExperiments{iExpt} ;
    for iNeuron = 1:size(currentExpt,1)
        cycleMatrix = [cycleMatrix; currentExpt.EachCycle{iNeuron}(:, 1:numHistBins)] ;
    end
end

%% duplicate cycleMatrix 
twoCycleMatrix = [cycleMatrix, cycleMatrix] ;







