function spikesPerStructure = plotType1SWDs(brainSpikes, EEG, experimentInfo, dataType, dumpFolder, fidTracker)
% parent function: analyzeElasExperiment.m

% save('/home/mark/matlab_temp_variables/PLOTTYPE1')
% ccc
% load('/home/mark/matlab_temp_variables/PLOTTYPE1')

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

%% turn off figure visibilty
set(0,'DefaultFigureVisible','off') ;

%% plot query
plotQ = experimentInfo.plotData ;

%% make plot directory
plotPath = sprintf('%s/plots/', dumpFolder) ;
if strcmp(plotQ, 'Y')
    unix(sprintf('mkdir %s', plotPath)) ;
end

%% get brain structure names
brainFields = fieldnames(brainSpikes) ;

%% make temp fold to hold pngs
if strcmp(plotQ, 'Y')
    unix(sprintf('mkdir %stemp', plotPath)) ;
    
    unix(sprintf('mkdir %sSWD', plotPath)) ;
    unix(sprintf('mkdir %sSWD/pdfs', plotPath)) ;
    unix(sprintf('mkdir %sSWD/pngs', plotPath)) ;
    unix(sprintf('mkdir %sSWD/eps', plotPath)) ;
    unix(sprintf('mkdir %sSWD/pdfs/seizures', plotPath)) ;
    unix(sprintf('mkdir %sSWD/pngs/seizures', plotPath)) ;
    unix(sprintf('mkdir %sSWD/eps/seizures', plotPath)) ;
    
    unix(sprintf('mkdir %sNON-SWD', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/pdfs', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/pngs', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/eps', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/pdfs/nonSeizures', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/pngs/nonSeizures', plotPath)) ;
    unix(sprintf('mkdir %sNON-SWD/eps/nonSeizures', plotPath)) ;
end

%% loop through structures
for iBrain = 1:size(brainFields,1)
    for iSeizure = 1:size(brainSpikes.(brainFields{iBrain}).SWD,2)
        currentSeizure = brainSpikes.(brainFields{iBrain}).SWD{iSeizure};       

        currentSeizure = singleMultiSeizurePlot(currentSeizure, iSeizure, plotPath, brainFields{iBrain}, experimentInfo, EEG) ;
        if strcmp(dataType, 'SWD')
            spikesPerStructure.(brainFields{iBrain}).SWD{iSeizure} = currentSeizure ;
        else
            spikesPerStructure.(brainFields{iBrain}).NON_SWD{iSeizure} = currentSeizure ;
        end
        clear singles multis zeroedSeizure currentSeizure
    end
    
    if strcmp(plotQ, 'Y')
        if strcmp(dataType, 'SWD')
            unix(sprintf('convert %stemp/*.png %s/SWD/pdfs/seizures/%s.pdf', plotPath, plotPath, brainFields{iBrain})) ;
            unix(sprintf('mkdir %sSWD/pngs/seizures/%s', plotPath, brainFields{iBrain})) ;
            unix(sprintf('mv %stemp/*.png  %sSWD/pngs/seizures/%s/.', plotPath, plotPath, brainFields{iBrain})) ;
            unix(sprintf('mkdir %sSWD/eps/seizures/%s', plotPath, brainFields{iBrain})) ;
            unix(sprintf('mv %stemp/*.eps  %sSWD/eps/seizures/%s/.', plotPath, plotPath, brainFields{iBrain})) ;
        else
            unix(sprintf('convert %stemp/*.png %s/NON-SWD/pdfs/nonSeizures/%s.pdf', plotPath, plotPath, brainFields{iBrain})) ;
            unix(sprintf('mkdir %sNON-SWD/pngs/nonSeizures/%s', plotPath, brainFields{iBrain})) ;
            unix(sprintf('mv %stemp/*.png  %sNON-SWD/pngs/nonSeizures/%s/.', plotPath, plotPath, brainFields{iBrain})) ;
            unix(sprintf('mkdir %sNON-SWD/eps/nonSeizures/%s', plotPath, brainFields{iBrain})) ;
            unix(sprintf('mv %stemp/*.eps  %sNON-SWD/eps/nonSeizures/%s/.', plotPath, plotPath, brainFields{iBrain})) ;
        end
        unix(sprintf('rm -rf %stemp/*', plotPath)) ;
    end
end

%% delete temp png folder
if strcmp(plotQ, 'Y')
    unix(sprintf('rm -rf %stemp', plotPath)) ;
end

%% turn off figure visibilty
set(0,'DefaultFigureVisible','on') ;
