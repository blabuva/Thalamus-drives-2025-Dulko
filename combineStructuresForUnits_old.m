function comboTable = combineStructuresForUnits(allDataTable)
% parent function = monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/whittler')
% ccc
% load('/home/mark/matlab_temp_variables/whittler')

%%
% clc; close all
% keep allDataTable

%% 
eventType = 'SWDs' ;

%% load in ela/anna grace table with brain names...to whittle down to relevant structures
brainSheet = readtable('/media/probeX/intanData/ela/structureColorCoder_AG.xlsx') ;

%% recreate table headers for whittled table (i.e., excluding those not to analyze)
whittleTable.(eventType) = allDataTable.(eventType)(1,:) ;

%% first get rid of structures not to analyze
whittleBrainSheet = brainSheet(find(strcmp(brainSheet.KeepAs_name__Don_tAnalyse, 'DontAnalyze') ==0), :) ;

%% loop through
for iWhittleBrainPart = 1:size(whittleBrainSheet, 1)
    codeName = whittleBrainSheet.NameUsedByCode{iWhittleBrainPart} ;
    idxCodeNameInTable = find(strcmp(allDataTable.(eventType).brainNames, codeName) == 1) ;
    whittleTable.(eventType).brainNames(iWhittleBrainPart,1) = whittleBrainSheet.KeepAs_name__Don_tAnalyse(iWhittleBrainPart) ;
    whittleTable.(eventType)(iWhittleBrainPart,2:end) = allDataTable.(eventType)(idxCodeNameInTable, 2:end) ;
    clear codeName idxCodeNameInTable
end

%% find unique whittle names
uniqueNames = unique(whittleTable.(eventType).brainNames) ;

%% recreate table headers for combined table
% comboTable = whittleTable(1,:) ;

%% combine
for iName = 1: length(uniqueNames)
    currentName = uniqueNames{iName} ;
    idxCodeCurrentNameInTable = find(strcmp(whittleTable.(eventType).brainNames, currentName) == 1) ;
    newRowTable  = comboTheWhittledTable(whittleTable.(eventType)(idxCodeCurrentNameInTable, :)) ;
    if iName == 1
        comboTable.(eventType) = newRowTable ;
    else
        comboTable.(eventType) = [comboTable.(eventType); newRowTable] ;
    end
end
