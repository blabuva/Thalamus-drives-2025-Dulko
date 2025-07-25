function xyLimits = findxlRasterLimits(currentExperiment) 



for iSWD = 1:length(currentExperiment)
    allUnitTimes = [] ;
    currentSWD = currentExperiment{iSWD} ;
    for iNeuron = 1:size(currentSWD,1)
        allUnitTimes= [allUnitTimes; currentSWD.unitsPad{iNeuron} ] ;
    end
    xyLimits{iSWD} = [min(allUnitTimes), max(allUnitTimes)] ;
    clear currentSWD
end