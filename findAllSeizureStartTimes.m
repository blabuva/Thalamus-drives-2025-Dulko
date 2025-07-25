function [seizureStartTimes, nonSeizureStartTimes, numSWDsamples, startTimeSpikeTimeDifference] = findAllSeizureStartTimes(SWDs, EEG) 
% parent function: makeNonSeizureControlData.m

% save('/home/mark/matlab_temp_variables/swdStarts')
% ccc
% load('/home/mark/matlab_temp_variables/swdStarts')

%% loop through seizures
for iSWD = 1:size(SWDs,1)
       seizureStartTimes(iSWD,1) = SWDs.SWD_startTime(iSWD) ;
       firstSpikeTime(iSWD,1) = SWDs.SWD_troughTimes{iSWD}(1) ;
       startTimeSpikeTimeDifference(iSWD,1) =firstSpikeTime(iSWD,1) -   seizureStartTimes(iSWD,1) ;
       numSWDsamples(iSWD,1) = length(SWDs.SWD_timeCol{iSWD}) ;
end

%% tack total time end onto seizureStartTimes so that last control seizure can be made
firstSpikeTime(iSWD+1, 1) =  EEG.time(end) ;
 
%%
halfDiffStarts = (diff(firstSpikeTime))/2 ;

%%
nonSeizureFirstSpikeTimes(:,1) = firstSpikeTime(1:end-1) ;
nonSeizureFirstSpikeTimes(:,2) = nonSeizureFirstSpikeTimes + halfDiffStarts ;
nonSeizureFirstSpikeTimes(:,3) = nonSeizureFirstSpikeTimes(:,2) - startTimeSpikeTimeDifference ;

nonSeizureStartTimes = nonSeizureFirstSpikeTimes(:,3) ;


