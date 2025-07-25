function [histoCurrentStructureSum, pTOvRatio, peakBin] = elasPeak2ValleyCalc(dataFromOneStructure)
% parent function: unitPhaseFromDataBase.m

%%

    histoCurrentStructureSum = sum(dataFromOneStructure,1) ;
    peakHistogram = max(histoCurrentStructureSum(50:150)) ;
    peakBin = find(histoCurrentStructureSum(50:150) == peakHistogram, 1)+50 ;
    valleyHistogram = min(histoCurrentStructureSum) ;
    if valleyHistogram == 0
        valleyHistogram = 1 ;
    end
    pTOvRatio = peakHistogram/valleyHistogram ;
    % elasPeakToValleyRatios.gria.preLump.(phaseFieldsGria{iStructure}).histogram = histoCurrentStructureSum ;
    % elasPeakToValleyRatios.gria.preLump.(phaseFieldsGria{iStructure}).pTOvRatio = pTOvRatio ;
    % allPtoVs(iStructure,1) = pTOvRatio ;
