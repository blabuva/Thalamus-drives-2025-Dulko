function  allTroughs = createTroughTable(currentSeizure, maxInterTroughDurationMS) 
    
    siSec = currentSeizure.time(2) - currentSeizure.time(1) ;
    siMS = siSec * 1000 ;
    allTroughs = array2table(currentSeizure.trTimeInds(:), 'variablenames', {'TroughIndex'}) ;
    allTroughs.TroughVal = currentSeizure.trVals ;
    allTroughs.TimeMS = currentSeizure.time(currentSeizure.trTimeInds) *1000 ;
    allTroughs.DiffMS = zeros(size(allTroughs,1),1) ;
    allTroughs.DiffMS(2:end) = diff(allTroughs.TimeMS) ;
    allTroughs.LongPeriodPeaks = zeros(size(allTroughs,1),1) ;
    allTroughs.LongPeriodPeaks(1) =1 ;
    realPeakIDX = find(allTroughs.DiffMS > maxInterTroughDurationMS) ;
    allTroughs.LongPeriodPeaks(realPeakIDX) = 1 ;