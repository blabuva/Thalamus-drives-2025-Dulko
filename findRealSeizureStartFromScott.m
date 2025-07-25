function curated_seizures = findRealSeizureStartFromScott(curated_seizures)
% parent function: scottsSeizureDetectionMaster_20230212.m

% save('/home/mark/matlab_temp_variables/realStarts')
% ccc
% load('/home/mark/matlab_temp_variables/realStarts')

%% loop through seizures
for iSeizure = 1:size(curated_seizures,2)
    disp(iSeizure);
    troughPeriods = diff(curated_seizures(iSeizure).time(curated_seizures(iSeizure).trTimeInds) *1000) ;
    meanPeriod = ceil(mean(troughPeriods))/1000 ;
    if isnan(meanPeriod)
        meanPeriod = 0.150 ;
    end

    halfPeriod = meanPeriod/2 ;

    firstTroughIDX = curated_seizures(iSeizure).trTimeInds(1) ;
    firstTroughTime = curated_seizures(iSeizure).time(curated_seizures(iSeizure).trTimeInds(1)) ;
    startSearchIDX = find(curated_seizures(iSeizure).time >= firstTroughTime - halfPeriod, 1) ;
    startSearchTime = curated_seizures(iSeizure).time(startSearchIDX) ;
    
    %% plot
    plotSeizures = 1 ;
    curated_seizures(iSeizure).seizureStartTime = plotSeizureAndStart(curated_seizures(iSeizure), firstTroughIDX, startSearchIDX, plotSeizures) ;
    close all
    keep curated_seizures iSeizure
end











