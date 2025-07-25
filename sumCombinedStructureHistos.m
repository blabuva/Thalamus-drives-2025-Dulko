function whittleDataTable = sumCombinedStructureHistos(whittleDataTable, dataType)

% save('C:\Users\markb\Desktop\Matlab\tempVars\sumComboedHistos')
% clear all; close all; clc ;
% load('C:\Users\markb\Desktop\Matlab\tempVars\sumComboedHistos')
% keep whittleDataTable; clc; close all ;

%%
for iStruct = 1:size(whittleDataTable.(dataType),1)
    whittleDataTable.(dataType).PhaseCombinedStructures{iStruct} = sum(whittleDataTable.(dataType).PhasePerStructureMatrix{iStruct}, 1) ;
end