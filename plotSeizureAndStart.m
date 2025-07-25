function seizureStart = plotSeizureAndStart(curated_seizures, firstTroughIDX, startSearchIDX, plotSeizures) 
% parent function: findRealSeizureStartFromScott.m

% save('/home/mark/plotStarts')
% ccc
% load('/home/mark/plotStarts')


    timeC = curated_seizures.time ;
    eeg = curated_seizures.EEG ;

    searchChunk(:,1) = timeC(startSearchIDX:firstTroughIDX) ;
    searchChunk(:,2) = eeg(startSearchIDX:firstTroughIDX) ;

    seizureStart = calcSeizureStartTime(searchChunk) ;
    seizureStartIDX = find(curated_seizures.time >= seizureStart, 1) ;

if plotSeizures == 1 ;
subplot(2,1,1)
    plot(timeC, eeg, 'k')
    hold on
    plot(timeC(curated_seizures.trTimeInds), curated_seizures.trVals, 'bo')
    plot(searchChunk(:,1), searchChunk(:,2),  'r')
    plot([seizureStart, seizureStart], [max(eeg), min(eeg)], '-g')


subplot(2,1,2)
    plot(searchChunk(:,1), searchChunk(:,2), 'r')
    hold on
    plot([seizureStart, seizureStart], [min(searchChunk(:,2)), max(searchChunk(:,2))], '-g')


    %%
set(gcf, 'units', 'normalized', 'position', [0.1 0.1 0.5 0.5])
end