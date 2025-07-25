function brainSpikes = groupClustersFromSameBrainStructures(SWD, fidTracker)
% parent function: analyzeElasExperiment.m

save('/home/mark/matlab_temp_variables/goopClus')
% ccc
% load('/home/mark/matlab_temp_variables/goopClus')

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

%%
brainSpikes = [] ;
brainSpikes = aggregateDataAccordingToBrainStructure(brainSpikes, SWD, 'SWD_SingleUnits') ;
brainSpikes = aggregateDataAccordingToBrainStructure(brainSpikes, SWD, 'SWD_MultiUnits') ;
