function seizureStart = calcSeizureStartTime(searchChunk)
% parent function: plotSeizureAndStart.m

%% 
% save('/home/mark/matlab_temp_variables/searchTheChunk')
% ccc
% load('/home/mark/matlab_temp_variables/searchTheChunk')

%%
eeg = searchChunk(:,2) ;
reverseEEG = flipud(eeg) ;
timeC = searchChunk(:,1) ;
reverseTime = flipud(searchChunk(:,1)) ;

%%
diffRevEEG = diff(reverseEEG) ;
smoothDiffRevEEG = smooth(diffRevEEG, 3) ;

[peaks(:,2), peaks(:,1)] = findpeaks(smoothDiffRevEEG) ;
peaksSort = sortrows(peaks,2, 'descend') ;

topPeak = peaksSort(1, :) ;
firstBigNegative = find(smoothDiffRevEEG(topPeak(1):end) <=0, 1) + topPeak(1)-1 ;
if isempty(firstBigNegative)
    seizureStart = reverseTime(topPeak(1)) ;
else
    seizureStart = reverseTime(firstBigNegative) ;
end

