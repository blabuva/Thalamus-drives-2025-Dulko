function seizures = noTroughDupes(seizures) 

% save('/home/mark/matlab_temp_variables/noDUPES')
% ccc
% load('/home/mark/matlab_temp_variables/noDUPES')

%% max duration between troughs (trough times less than this val are considered duplicates)
maxInterTroughDurationMS = 50 ;

for iSeizure = 1:size(seizures,2)
    currentSeizure = seizures(iSeizure) ;
    allTroughs = createTroughTable(currentSeizure, maxInterTroughDurationMS) ;
    [troughIDXs, troughVals] = findOneTrough(allTroughs) ;
    seizures(iSeizure).trTimeInds = troughIDXs ;
    seizures(iSeizure).trVals = troughVals ;
    clear currentSeizure allTroughs troughIDXs troughVals
end