function originalDB = lumpThoseBrainStructures(originalDB, structureLumper) 
% parent function: unitPhaseFromDataBase.m

% save('/home/mark/matlab_temp_variables/lumper', '-v7.3')
% ccc
% load('/home/mark/matlab_temp_variables/lumper')
% close all; clc;
% keep originalDB structureLumper

%% first deal with any /'s in Anna Graces file
for iStructure = 1:length(structureLumper.NameUsedByCode)
    codeNames{iStructure,1} = structureLumper.NameUsedByCode{iStructure} ;
    codeNames{iStructure,1} =strrep(codeNames{iStructure,1}, '/', '_') ;
    codeNames{iStructure,1} =strrep(codeNames{iStructure,1}, '-', '_') ;
end

%% add name to original data base
for iRow = 1:size(originalDB,1)
    currentStructure= strrep(originalDB.Structure{iRow}, ' ', '_') ;
    currentStructure = strrep(currentStructure, '/', '_') ;
    currentStructure = strrep(currentStructure, '-', '_') ;
    originalDB.LumpedStructure(iRow) = codeNames(find(contains(codeNames, currentStructure))) ;
end


