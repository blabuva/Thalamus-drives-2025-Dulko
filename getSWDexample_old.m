function SWDexample = getSWDexample(theSWD) 
% parent function = monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/Combowhittler')
% ccc
% load('/home/mark/matlab_temp_variables/Combowhittler')

%%
troughTimes = theSWD.TroughTimes{1} ;

%% find time INDEXs
for iTrough = 1:length(troughTimes)
    troughIDX(iTrough,1) = find(theSWD.Time{1} >= troughTimes(iTrough),1) ;
end

%% EEG
SWDexample.eeg = theSWD.EEG{1}(troughIDX(1):troughIDX(3)) ;

%% normalized time for eeg
timeC = -100:200/length(SWDexample.eeg):100 ;
SWDexample.timeC = timeC(1:end-1) ;

