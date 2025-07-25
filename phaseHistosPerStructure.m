function twoCycleMatrix = phaseHistosPerStructure(allExperiments) 

% save('C:\Users\markb\Desktop\Matlab\tempVars\phaseHistStruc')
% ccc 
% load('C:\Users\markb\Desktop\Matlab\tempVars\phaseHistStruc')

%%
numHistBins = size(allExperiments{1}.SumAcrossSeizures{1},2)-1 ;
structHisto = [] ;
for iExperiment = 1:length(allExperiments)
    for iNeuron = 1:size(allExperiments{iExperiment},1) 
        if ~isempty(allExperiments{iExperiment}.SumAcrossSeizures{iNeuron})
            structHisto = [structHisto; allExperiments{iExperiment}.SumAcrossSeizures{iNeuron}(1, 1:numHistBins)] ;
        end
    end
end
twoCycleMatrix = [structHisto, structHisto] ;
