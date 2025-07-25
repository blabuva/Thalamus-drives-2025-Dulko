function nonSWDs = makeNonSeizureControlData(type1SWDs, EEG) 
% parent function: spikesAndSeizures.m

save('/home/mark/matlab_temp_variables/nonControl')
ccc
load('/home/mark/matlab_temp_variables/nonControl')

%% get start times of seizures and non-seizures
[seizureStartTimes, nonSeizureStartTimes, numSWDsamples, startTimeSpikeTimeDifference] = findAllSeizureStartTimes(type1SWDs, EEG) ;

%% create nonSWD table from SWD table
nonSWDs = type1SWDs ;

%% loop through type1SWDs to create a control data set defined by the EEG/spike activity that occurs half-way between two seizures.
for iSWD = 1:size(type1SWDs,1)
    currentSWD = type1SWDs(iSWD,:) ;
    timeDifference = nonSeizureStartTimes(iSWD) - currentSWD.SWD_troughTimes{1}(1) ;


    indexOfNonSWDstartTime = find(EEG.time >= nonSeizureStartTimes(iSWD), 1) ;

 
    endIDX = indexOfNonSWDstartTime + numSWDsamples(iSWD)-1 ;

    % in case 'control' SWD goes over the duration of the recording
    if endIDX > length(EEG.time)
        endIDX = length(EEG.time) ;
    end

    EEGnonSWD = EEG.data(indexOfNonSWDstartTime:endIDX) ;
    timenonSWD = EEG.time(indexOfNonSWDstartTime:endIDX) ;
    nonSWDs.SWD_timeCol{iSWD}  = timenonSWD ;
    nonSWDs.SWD_EEG{iSWD} = EEGnonSWD ;
    nonSWDs.SWD_troughTimes{iSWD} = currentSWD.SWD_troughTimes{1} + timeDifference + startTimeSpikeTimeDifference(iSWD) ; 
    nonSWDs.SWD_troughVals{iSWD} = currentSWD.SWD_troughVals{1}  ;
    nonSWDs.SWD_startTime(iSWD) = nonSeizureStartTimes(iSWD) ;
end