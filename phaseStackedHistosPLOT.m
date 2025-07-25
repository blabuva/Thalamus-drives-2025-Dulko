%%
% ccc ;
% load('/home/mark/matlab_temp_variables/PLOThistoPHASE') ;
% load('/home/mark/matlab_temp_variables/SWDex') ;
%%
keep lumpedPhase SWD
clc; close all

%%
% plotSaveDir = '/media/mark2X/ela/phaseHistoFigs' ;
% plotSaveDir = sprintf('%s/%s', '/media/mark2X/ela/phaseHistoFigs', currentName) ;
plotSaveDir = '/media/mark2X/ela/phaseHistoFigs/allStructures' ;
%%
brainNames = fieldnames(lumpedPhase.gria) ;
%%
for iStructure = [6:length(brainNames)]
    currentName = brainNames{iStructure} ;
    
    mkdir(plotSaveDir)
    currentBrainPart = lumpedPhase.gria.(currentName).histCounts.singleALL ;
    plotPhaseForMyBrainPart(currentBrainPart, SWD, plotSaveDir, currentName)
    close all
end



