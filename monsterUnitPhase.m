function allDataTable = monsterUnitPhase(allDataTable) 
% parent function: aggraPhase.m

% save('/home/mark/matlab_temp_variables/monsterPhase')
% clear all
% load('/home/mark/matlab_temp_variables/monsterPhase')
% clc; close all ;
% keep allDataTable

%%
dataType = 'SWDs' ;

%% get examples SWD cycle
SWDexample = getSWDexample(allDataTable.(dataType)(11, :)) ; %%theSWDs{1}{1}{1}) ;

%% create matrices containing neuron phase, either for each SWD cycle or the sum/mean across cycles
%% then put these matrices into allDataTable 
numHistBins = 100 ;
allDataTable = createPhaseMatrices(allDataTable, dataType, numHistBins) ;

%% load in ela/anna grace table with brain names...to whittle down to relevant structures
whittleDataTable = combineStructuresForUnits(allDataTable) ;

%% sum the structure histos that have been whittled and combined (for use in ordering monster matrix)
whittleDataTable = sumCombinedStructureHistos(whittleDataTable, 'SWDs') ;

%% find the centroid (weighted center) of the structure histogram
whittleDataTable = centroidCombinedStructureHistos(whittleDataTable, 'SWDs') ;

%% sort whittled table according to centroid
sortedDataTable.SWDs = sortWhittledTable(whittleDataTable, 'SWDs') ;

%% Create all-inclusive matrix based on phase for every single SWD cycle
[theMonsters.monsterCycle.Matrix, theMonsters.monsterCycle.brainStructuresYaxisInfo] = makeMonsterMatrices(sortedDataTable, dataType, 'PhasePerCycleMatrix') ;

%% Create all-inclusive matrix based on phase for every single SWD wherein phase data is summed across cycles
[theMonsters.monsterSWD.Matrix, theMonsters.monsterSWD.brainStructuresYaxisInfo] = makeMonsterMatrices(sortedDataTable, dataType, 'PhasePerSWDMatrix') ;

%% Create all-inclusive matrix based on phase for every neuron wherein phase data is summed across cycles
[theMonsters.monsterNeuron.Matrix, theMonsters.monsterNeuron.brainStructuresYaxisInfo] = makeMonsterMatrices(sortedDataTable, dataType, 'PhasePerNeuronMatrix') ;

%% Create all-inclusive matrix based on phase for every structure wherein phase data is summed across cycles
[theMonsters.monsterStructure.Matrix, theMonsters.monsterStructure.brainStructuresYaxisInfo] = makeMonsterMatrices(sortedDataTable, dataType, 'PhaseCombinedStructures') ;

%% plot the monster
plotTheMonsterMatrix(theMonsters, sortedDataTable.SWDs.PhaseCentroid, SWDexample)






