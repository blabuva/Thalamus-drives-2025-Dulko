function makePopPhases(data, experimentInfo) 
% % parent function: plotAggaUnitsPhase.m

save('/home/mark/matlab_temp_variables/aggraPPPhase')
ccc
load('/home/mark/matlab_temp_variables/aggraPPPhase')
set(0,'DefaultFigureVisible', 'off')
clc
close all
keep phasesCurrentBrainPart experimentInfo


for iExperiment = 1 %:length(phasesCurrentBrainPart)
        currentExperiment = data{iExperiment} ;
        maxYforPlots = findMaxUnitFiring(currentExperiment) ;
        numSWDs = length(currentExperiment) ; % in plot, columns are SWDs
        numberOfNeurons = size(currentExperiment{1},1)  ;
        iPlot = 1 ;
        for iNeuron = 1:numberOfNeurons            
            for iSWD = 1:numSWDs
                currentSWD = currentExperiment{iSWD} ;
                theColorMap = redblue(size(currentSWD,2)) ;
                currentNeuron = currentSWD(iNeuron, :) ;
                currentNeuronVector = cell2mat(currentNeuron) ; 
                if ~isempty(currentNeuronVector)
                    subaxis(numberOfNeurons, numSWDs, iPlot, 'Spacing', 0, 'Padding', 0)
                    plotNumSpikesAndPhase(currentSWD, iNeuron, theColorMap)
                end   
                iPlot = iPlot +1 ;
                clear currentSWD theColorMap currentNeuron
            end
            disp(sprintf('Neuron #%i', iNeuron))
        end
                set(gcf, 'units', 'normalized', 'position', [0.01, 0.01, 0.5, 0.9])
    end
    disp('printing figure')
    make_my_figure_fit_HW(numberOfNeurons,numSWDs*2)
    print('/media/markX/testUnits', '-dpng', '-r500')
    close all