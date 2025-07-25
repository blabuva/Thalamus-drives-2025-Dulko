function [troughIDXs, troughVals] = findOneTrough(allTroughs) 

% save('/home/mark/matlab_temp_variables/theOne')
% ccc
% load('/home/mark/matlab_temp_variables/theOne')

%% pre load real peaks with zeros
allTroughs.RealPeaks = zeros(size(allTroughs,1),1) ;

%% for all troughs except the last
for iTrough = 1:size(allTroughs,1)-1
    if allTroughs.LongPeriodPeaks(iTrough) == 1
        if allTroughs.LongPeriodPeaks(iTrough+1) == 1
            allTroughs.RealPeaks(iTrough) = 1 ;
        else
            lastCloseTrough = find(allTroughs.LongPeriodPeaks(iTrough+1:end) == 1,1) + iTrough-1 ;
            troughestTrough = min(allTroughs.TroughVal(iTrough:lastCloseTrough)) ;
            troughestTroughIDX = find(allTroughs.TroughVal(iTrough:lastCloseTrough) == troughestTrough, 1) ;
            currentTroughIDXs = [iTrough:1:lastCloseTrough] ;
            tableIDX = currentTroughIDXs(troughestTroughIDX) ;
            allTroughs.RealPeaks(tableIDX) =1 ;
        end
    end
    keep allTroughs
end

%% for last troughs
lastLongPeriod = find(allTroughs.LongPeriodPeaks ==1, 1,  'last') ;
lastBigPeakVal = min(allTroughs.TroughVal(lastLongPeriod:end)) ;
lastBigPeakIDX = find(allTroughs.TroughVal(lastLongPeriod:end) == lastBigPeakVal, 1) - 1 + lastLongPeriod ;
allTroughs.RealPeaks(lastBigPeakIDX) = 1 ;

%% extract non-duplicated trough vals and indices
realTroughIDX = find(allTroughs.RealPeaks == 1) ;
troughIDXs = allTroughs.TroughIndex(realTroughIDX) ;
troughVals = allTroughs.TroughVal(realTroughIDX) ;