function makeUnitPopPlots(data, experimentInfo, SWDs, brainPart, plotType) 
% parent function: plotAggaUnitsPhase.m

save('/home/mark/matlab_temp_variables/aggraPPPhase')
clear all; close all;
load('/home/mark/matlab_temp_variables/aggraPPPhase')
set(0,'DefaultFigureVisible', 'off')
warning ('off','all');
% clc
% close all
% keep data experimentInfo brainPart plotType SWDs


%% make dump folder:
dumpFolder = sprintf('/media/probeX/intanData/ela/populationPlots/%s/%s', brainPart, plotType) ;
mkdir(dumpFolder) ;

%%
for iExperiment = 1:length(data)
        currentExperiment = data{iExperiment} ;
        currentExperimentSWDs = SWDs{iExperiment} ;

        % calculate max Y for all plots, as defined by plotType
        if strcmp(plotType, 'polarSpikeCount') == 1
            maxYforPlots = findMaxUnitFiring(currentExperiment) ;
        elseif strcmp(plotType, 'polarCircHist') == 1
            maxYforPlots = findMaxUnitFiring(currentExperiment) ;
        elseif strcmp(plotType, 'rasters') ==1
            xyLimits = findxlRasterLimits(currentExperiment) ;
        end

        numSWDs = length(currentExperiment) ; % in plot, columns are SWDs
        numberOfNeurons = size(currentExperiment{1},1)  ;
        maxNeuronsPerTempFig = 2 ;
        numberOfTempFigs = ceil(numberOfNeurons/maxNeuronsPerTempFig) ;
        iNeuron = 1 ;
        iPlot = 1 ;
        neuronNumFig = 1; 
        iTempfig = 1 ;
       while iNeuron <=numberOfNeurons   
                for iSWD = 1:numSWDs
                    currentDataForSWD = currentExperiment{iSWD} ;
                    theColorMap = redblue(size(currentDataForSWD,2)) ;
    
                    if strcmp(plotType, 'polarSpikeCount') == 1
                        plotNumSpikesAndPhase(currentDataForSWD, iNeuron, iPlot, iSWD, numSWDs, maxNeuronsPerTempFig, ...
                            maxYforPlots, theColorMap)
                    elseif strcmp(plotType, 'polarCircHist') == 1
                        plotPhaseCircHist(currentDataForSWD, iNeuron, iPlot, iSWD, numSWDs, maxNeuronsPerTempFig, ...
                            maxYforPlots, theColorMap)
                    elseif strcmp(plotType, 'rasters') == 1
%                         if iNeuron == 71
%                             a=1 ;
%                         end
                        plotPopRasters(currentDataForSWD(iNeuron, :), iNeuron, iPlot, iSWD, numSWDs, maxNeuronsPerTempFig, iTempfig, currentExperimentSWDs{iSWD}, xyLimits{iSWD})
                    end
    
                    iPlot = iPlot +1 ;
                    clear currentDataForSWD theColorMap 
                end
%                 disp(sprintf('Experiment %i/%i, Neuron #%i', iExperiment, length(data), iNeuron))
                neuronNumFig = neuronNumFig + 1 ;


                
                
                if neuronNumFig > maxNeuronsPerTempFig || iNeuron == numberOfNeurons 
                    set(gcf, 'units', 'inches', 'position', [0.01, 0.01, numSWDs*5, maxNeuronsPerTempFig])
                    screenposition = get(gcf,'Position');
                    set(gcf, 'PaperSize', [screenposition(3:4)]);

                    tempFigName = sprintf('%s/tempFig___%03i', dumpFolder, iTempfig) ;
                    
                    print(tempFigName, '-dpdf', '-fillpage')
                                          
                    close all
                    iTempfig = iTempfig + 1;
                    neuronNumFig = 1;
                    iPlot = 1 ;                
                                     
                end
                iNeuron = iNeuron + 1;
        end

             figName = sprintf('%s/%s_%s_%s', dumpFolder, brainPart, experimentInfo.MouseIDs{iExperiment}, plotType) ;   
             unix(sprintf('pdftk %s/tempFig*.pdf cat output %s.pdf', dumpFolder, figName)) ;
             unix(sprintf('rm -rf  %s/tempFig*.pdf', dumpFolder))
               
%         disp('printing figure')    
        
%         clc
        close all
        keep data iExperiment brainPart dumpFolder experimentInfo plotType SWDs
 end

