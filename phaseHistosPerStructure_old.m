% function allDataTable = phaseHistosPerStructure(allDataTable, dataType) 
% parent function: monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/phaseHistStruc')
% ccc
% load('/home/mark/matlab_temp_variables/phaseHistStruc')

%%
clc; close all ;
keep allDataTable dataType

%%
for iBrainPart = 1 %:size(allDataTable.(dataType),1)
    allNeurons = allDataTable.(dataType).BinnedPhasesSumAcrossSWDs{iBrainPart} ;


end