function SWDexample = getSWDexample(theSWD) 
% parent function = monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/Combowhittler')
% ccc
% load('/home/mark/matlab_temp_variables/Combowhittler')

%% define the cycle you want
theCycle = 8 ;
theSecondCycle = 14 ;

%% SWD taken from 'Lateral_dorsal_nucleus_of_thalamus'. Experiment #1. SWD #2.
SWDexample.EEG.Time = theSWD.theSWDs{1}{1}{2}.Time{1} ;
SWDexample.EEG.EEG = theSWD.theSWDs{1}{1}{2}.EEG{1} ;
SWDexample.Units = theSWD.SingleUnitsSWD{1}{1}{2}.unitsPad{1} ;
SWDexample.Phases.Raw.AllCycles = theSWD.RawPhases{1}{1}{2}(1, :) ;
SWDexample.Phases.Raw.Cycle1 = theSWD.RawPhases{1}{1}{2}{1, theCycle} ;
SWDexample.Phases.Raw.Cycle2 = theSWD.RawPhases{1}{1}{2}{1, theSecondCycle} ;

%% for  plot
SWDexample.forPlots.xAxisMin = SWDexample.EEG.Time(1);
SWDexample.forPlots.xAxisMax = SWDexample.EEG.Time(end);
SWDexample.theCycle.Cycle1.Times = theSWD.theSWDs{1}{1}{2}.TroughTimes{1}(theCycle:theCycle+1) ;
SWDexample.theCycle.Cycle2.Times = theSWD.theSWDs{1}{1}{2}.TroughTimes{1}(theSecondCycle:theSecondCycle+1) ;

%% indices of example cycle
SWDexample.forPlots.startPeak1  = find(SWDexample.EEG.Time >= SWDexample.theCycle.Cycle1.Times(1), 1) ;
SWDexample.forPlots.endPeak1 = find(SWDexample.EEG.Time >= SWDexample.theCycle.Cycle1.Times(2), 1) ;
SWDexample.forPlots.startPeak2  = find(SWDexample.EEG.Time >= SWDexample.theCycle.Cycle2.Times(1), 1) ;
SWDexample.forPlots.endPeak2 = find(SWDexample.EEG.Time >= SWDexample.theCycle.Cycle2.Times(2), 1) ;

