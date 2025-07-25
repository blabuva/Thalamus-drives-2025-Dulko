function structureLumper = AGfileParser(theFile) 
% parent file: unitPhaseFromDataBase.m

%%
structureLumper = readtable(theFile) ; 
for iStructure = 1:size(structureLumper,1)
    codeName = structureLumper.NameUsedByCode{iStructure} ;
    codeName = strrep(codeName, '/', '_') ;
    codeName = strrep(codeName, '-', '_') ;
    structureLumper.marksName{iStructure} = codeName ;
    clear codeName;
end