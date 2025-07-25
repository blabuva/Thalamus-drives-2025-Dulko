% function allDataTable = monsterUnitPhase(allDataTable) 
% parent function: aggraPhase.m

% save('/home/mark/matlab_temp_variables/monsterPhase')
% ccc
% load('/home/mark/matlab_temp_variables/monsterPhase')
clc; close all ;
keep allDataTable

%%
dataType = 'SWDs' ;

%% get examples SWD cycle
SWDexample = getSWDexample(allDataTable.(dataType).theSWDs{1}{1}{1}) ;

%% create matrices containing neuron phase, either for each SWD cycle or the sum/mean across cycles
%% then put these matrices into allDataTable 
allDataTable = createPhaseMatrices(allDataTable, dataType) ;

%% create phase histos per structure
allDataTable = phaseHistosPerStructure(allDataTable, dataType) ;

%% load in ela/anna grace table with brain names...to whittle down to relevant structures
whittleDataTable = combineStructuresForUnits(allDataTable)




%% Create all-inclusive matrix based on phase for every single SWD cycle
[monsterCycleMatrix, brainStructuresYaxisInfo] = makeMonsterMatrices(whittleDataTable, dataType, 'PerCycleMatrix') ;

%% Create all-inclusive matrix based on phase for every single SWD wherein phase data is summed across cycles
[monsterSWDMatrix, brainStructuresYaxisInfo] = makeMonsterMatrices(whittleDataTable, dataType, 'PerSWDMatrix') ;



%% plot the monster
plotTheMonsterMatrix(monsterSWDMatrix, brainStructuresYaxisInfo, SWDexample)






