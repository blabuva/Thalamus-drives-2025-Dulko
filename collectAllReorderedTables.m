function allReorderedTables = collectAllReorderedTables(elasPeakToValleyRatios, reorderedTablePlaceHolder) 
%parent function: extractAndPlotPhaseFromDataBase.m

%% reorder the grias
allReorderedTables.gria.singleAll = reorderMyHistTable(elasPeakToValleyRatios.gria.singleALL.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.gria.multi = reorderMyHistTable(elasPeakToValleyRatios.gria.multi.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.gria.singleEX = reorderMyHistTable(elasPeakToValleyRatios.gria.singleEX.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.gria.singleIN = reorderMyHistTable(elasPeakToValleyRatios.gria.singleIN.perCycle.Filtered, reorderedTablePlaceHolder) ;

%% reorder the stargazers
allReorderedTables.stargazer.singleAll = reorderMyHistTable(elasPeakToValleyRatios.stargazer.singleALL.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.stargazer.multi = reorderMyHistTable(elasPeakToValleyRatios.stargazer.multi.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.stargazer.singleEX = reorderMyHistTable(elasPeakToValleyRatios.stargazer.singleEX.perCycle.Filtered, reorderedTablePlaceHolder) ;
allReorderedTables.stargazer.singleIN = reorderMyHistTable(elasPeakToValleyRatios.stargazer.singleIN.perCycle.Filtered, reorderedTablePlaceHolder) ;