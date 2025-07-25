function elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, mouseStrain, unitType, cycleType) 
% parent: unitPhaseFromDataBase.m

%%
phaseFields = fieldnames(phase.(mouseStrain)) ;
for iStructure = 1:length(phaseFields)
    currentStructurePreLump = phaseFields{iStructure} ;
    % create table on first iteration of the loop
    if iStructure ==1
        elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType) = table ;
        elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).OriginalStructureName{iStructure} = currentStructurePreLump ;
    else
        elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).OriginalStructureName{iStructure} = currentStructurePreLump ;
    end

    elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).ElasStructureName{iStructure} = structureLumper.KeepAs_name__Don_tAnalyse(find(strcmpi(structureLumper.marksName, currentStructurePreLump) ==1)) ;
   
    % check if matNoBlanks exists. If not, then skip
    noBlanksField = isfield(phase.(mouseStrain).(phaseFields{iStructure}).(unitType).(cycleType), 'matNoBlanks') ;
    if noBlanksField == 1
        [elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).Histogram{iStructure}, elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).NonLumpP2Vratio{iStructure}] =   ... 
            elasPeak2ValleyCalc(phase.(mouseStrain).(phaseFields{iStructure}).(unitType).(cycleType).matNoBlanks) ;
    else
        elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).Histogram{iStructure} = [];
        elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).NonLumpP2Vratio{iStructure} = [] ;
    end
end