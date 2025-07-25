function  currentSeizure = singleMultiSeizurePlot(currentSeizure, iSeizure, plotPath, brainStructure, experimentInfo, EEG)
% parent function: plotType1SWDs.m

% save('/home/mark/matlab_temp_variables/SMSP')
% ccc
% load('/home/mark/matlab_temp_variables/SMSP')

plotQ = experimentInfo.plotData ;

set(0,'DefaultFigureVisible','on')

%% unpack currentSeizure
singlesQuestion = isfield(currentSeizure, 'SWD_SingleUnits') ;
if singlesQuestion == 0
    currentSeizure.SWD_SingleUnits = [] ;
    currentSeizure.SingleUnitPhase.SpikePhases = [] ;
end

multisQuestion = isfield(currentSeizure, 'SWD_MultiUnits') ;
if multisQuestion == 0
    currentSeizure.SWD_MultiUnits = [] ;
    currentSeizure.MultiUnitPhase.SpikePhases = [] ;
end

singles = currentSeizure.SWD_SingleUnits ;
multis = currentSeizure.SWD_MultiUnits ;
theSeizure = currentSeizure.theSeizure ;

%% time of first SWD spike
timeFirstSWDspike = currentSeizure.theSeizure.TroughTimes{1}(1) ;

%% start time of seizure
seizureStartTime = currentSeizure.theSeizure.seizureStartTime ;

%% separate units according to pre-SWD, during SWD and after-SWD
currentSeizure = preORduringORpostSWD(currentSeizure, 'single') ;
currentSeizure = preORduringORpostSWD(currentSeizure, 'multi') ;

%% extract user-defined seizure pad
seizurePad = experimentInfo.spikeDetectionParams.seizurePad ;

%% find earliest and latest single/multi unit time to define Xmin and Xmax of plots
[xMin, xMax] = findMinMaxSpikeTimes(singles, multis) ;

%% round the min/max
xMinFloor = floor(xMin) ;
xMaxCeil = ceil(xMax) ;

%% create a zero vector to store a zero padded EEG trace
diffSeizureTime = diff(theSeizure.Time{1}) ;
samplePeriodSeizure = diffSeizureTime(1) ;
timeZeroedSeizure = [xMinFloor:samplePeriodSeizure:xMaxCeil]' ;
zeroedSeizure = zeros(length(timeZeroedSeizure),1) ;

%% insert EEG into zeroed vector
EEGstartIDX = find(EEG.time >= xMinFloor, 1)  ;
EEGendIDX = find(EEG.time >= xMaxCeil, 1) ;
currentSeizure.theSeizure.ZeroPaddedSeizure{1} = [EEG.time(EEGstartIDX:EEGendIDX), EEG.data(EEGstartIDX:EEGendIDX)] ;

%% generate PSTH and firing frequency
currentSeizure = brainSpikeHisto_FF(currentSeizure, experimentInfo.spikeDetectionParams.seizurePad, experimentInfo.analysisParams.PSTHbinSize) ;

%% plot data
titleFontSize = 14 ;
%%
if strcmp(plotQ, 'Y')
    subplot(11,1,1) % plot zeroed seizure
        plotZeroedSeziure(brainStructure, currentSeizure, timeFirstSWDspike, seizurePad, iSeizure, 'k', 20)
    
    
    subplot(11,1,2) % plot single unit rasters
        if ~isempty(currentSeizure.SWD_SingleUnits)
            plotUnitRasters(singles, currentSeizure, timeFirstSWDspike, seizurePad, 'r', titleFontSize, 'Single Units')
        end
        
    subplot(11,1,3) % plot multi unit rasters
        if ~isempty(currentSeizure.SWD_MultiUnits)
            plotUnitRasters(multis, currentSeizure, timeFirstSWDspike, seizurePad, 'b', titleFontSize, 'Multi Units')
        end
    
    subplot(11,1,4) % histogram of spike sums
        if ~isempty(currentSeizure.SWD_SingleUnits)
            plotUnitHistograms(currentSeizure, 'not stacked', experimentInfo, titleFontSize)
        end
    
    subplot(11,1,5) % stacked histogram
        if ~isempty(currentSeizure.SWD_SingleUnits)
            plotUnitHistograms(currentSeizure, 'stacked', experimentInfo, titleFontSize)
        end
end
 
totalSubPlots = 11 ;
subPlotNums = [6:11] ;
if ~isempty(currentSeizure.SWD_SingleUnits)
    currentSeizure = includeThePhaseSubplots(currentSeizure, 'singles', totalSubPlots, subPlotNums, titleFontSize, plotQ) ;
end

if ~isempty(currentSeizure.SWD_MultiUnits)
    currentSeizure = includeThePhaseSubplots(currentSeizure, 'multis', totalSubPlots, subPlotNums, titleFontSize, plotQ) ;
end

%      set(gcf, 'InvertHardCopy', 'on');
%     set(gcf,'Color','w')   

if strcmp(plotQ, 'Y')
%% position the figure
    set(gcf, 'units', 'normalized', 'position', [0.1 0.1 0.3 0.8])
    
    %% size the resultant figure pdf
    make_my_figure_fit_HW(20, 10)
    
    %% save temp figure
    figName = sprintf('%stemp/%06d_Seizure', plotPath, iSeizure) ;
    print(gcf, figName, '-r500', '-dpng') ;
    print(gcf, figName, '-r500', '-depsc') ;
    close all ;
end













































