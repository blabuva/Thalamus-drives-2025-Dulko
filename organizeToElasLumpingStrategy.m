function elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, mouseStrain, unitType, cycleType) 
% parent function: unitPhaseFromDataBase.m

%%
uniqueStructures = unique([elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).ElasStructureName{:}], 'first') ;
for iStructure = 1:length(uniqueStructures)
    currentUnique = uniqueStructures{iStructure} ;
    uniqueIDXs = find(strcmpi([elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).ElasStructureName{:}], currentUnique) ==1) ;
    lumpedHisto = [] ;
    for iIDX = 1:length(uniqueIDXs)
        lumpedHisto = [lumpedHisto; elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).Histogram{uniqueIDXs(iIDX)}] ;
    end
    lumpedHistoSum = sum(lumpedHisto,1) ;

    for iIDX = 1:length(uniqueIDXs)
        if iIDX == 1                      
             elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).LumpedHistogram{uniqueIDXs(iIDX)} = lumpedHistoSum ;
             if isempty(lumpedHistoSum) == 0
                [x, elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).LumpedP2Vratio(uniqueIDXs(iIDX)),  elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).PeakBin(uniqueIDXs(iIDX))] =  elasPeak2ValleyCalc(lumpedHistoSum) ;
             else
                
             end
        else
            elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).LumpedHistogram{uniqueIDXs(iIDX)} = NaN;
            elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).LumpedP2Vratio(uniqueIDXs(iIDX)) = 0 ;
            elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).PeakBin(uniqueIDXs(iIDX)) = 0 ;
        end        
    end
    clear lumpedHisto uniqueIDXs currentUnique lumpedHistoSum
end