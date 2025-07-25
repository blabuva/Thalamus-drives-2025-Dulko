function elasPeakToValleyRatios = collectAllPeakToVallyRatios(phase, structureLumper, highRatioThreshold, lowRatioThreshold) 
% parent function: extractAndPlotPhaseFromDataBase.m

%% suppress matlab warnings
warning('off', 'all')

%%
elasPeakToValleyRatios = [] ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'gria', 'singleALL', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'gria', 'singleIN', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'gria', 'singleEX', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'gria', 'multi', 'perCycle') ;

elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'stargazer', 'singleALL', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'stargazer', 'singleIN', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'stargazer', 'singleEX', 'perCycle') ;
elasPeakToValleyRatios = p2vEla(elasPeakToValleyRatios, phase, structureLumper, 'stargazer', 'multi', 'perCycle') ;


%% lump structures in P2V table according to Ela's lumping strategy
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'gria', 'singleALL', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'gria', 'singleIN', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'gria', 'singleEX', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'gria', 'multi', 'perCycle') ;

elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'stargazer', 'singleALL', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'stargazer', 'singleIN', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'stargazer', 'singleEX', 'perCycle') ;
elasPeakToValleyRatios = organizeToElasLumpingStrategy(elasPeakToValleyRatios, 'stargazer', 'multi', 'perCycle') ;

%% sort P2V table
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'gria', 'singleALL', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'gria', 'singleIN', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'gria', 'singleEX', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'gria', 'multi', 'perCycle', highRatioThreshold, lowRatioThreshold) ;

elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'stargazer', 'singleALL', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'stargazer', 'singleIN', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'stargazer', 'singleEX', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, 'stargazer', 'multi', 'perCycle', highRatioThreshold, lowRatioThreshold) ;
