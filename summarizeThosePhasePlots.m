function summarizeThosePhasePlots(phaseTable, dumpFolder)
% parent function: parseThePhaseFile.m

% save('/home/mark/matlab_temp_variables/summPhase')
% ccc
% load('/home/mark/matlab_temp_variables/summPhase')
% 
set(0, 'DefaultFigureVisible', 'off')

%%  brain fields
brainParts = fieldnames(phaseTable) ;

%% plot Colors
brainPartColorMap = plotColorsForUnits() ;

%% loop though
phaseType = 'allSpikes' ;
for iBrainPart = 1:size(brainParts,1)
    for iNeuron = 1:size(phaseTable.(brainParts{iBrainPart}).(phaseType),1) 
        currentNeuron = phaseTable.(brainParts{iBrainPart}).(phaseType)(iNeuron,:) ;
        for iSWD = 1:size(currentNeuron,2)
            if ~isempty(currentNeuron{iSWD})
                [meanPhaseNeuronForOneSWD(iSWD,1), meanEngagementforOneSWD(iSWD,1)] = meansPolars(currentNeuron{iSWD}) ;
                meanNormPhaseNeuronForOneSWD(iSWD,1) = mean(currentNeuron{iSWD}.NormPhase) ;
                meanDegPhaseNeuronForOneSWD(iSWD,1) = mean(currentNeuron{iSWD}.DegreePhase) ;
                polarplot([meanPhaseNeuronForOneSWD(iSWD), meanPhaseNeuronForOneSWD(iSWD)], [0, meanEngagementforOneSWD(iSWD)], '-', 'color', rgb('gray')) ;
                hold on  
            else
                meanPhaseNeuronForOneSWD = [] ;
                meanEngagementforOneSWD = [] ;
                meanNormPhaseNeuronForOneSWD = [] ;
                meanDegPhaseNeuronForOneSWD = [] ;
            end
        end

        [meanPhase, CIphase, meanEngagement, CIengagement]  = calculatePhaseStats(meanPhaseNeuronForOneSWD, meanEngagementforOneSWD)  ;
        polarplot([meanPhase, meanPhase], [0, meanEngagement], '-', 'color', 'r', 'LineWidth', 3) ;
        polarplot([CIphase(1), CIphase(1)], [0, meanEngagement], ':', 'color', rgb('salmon'), 'LineWidth', 3) ;
        polarplot([CIphase(2), CIphase(2)], [0, meanEngagement], ':', 'color', rgb('salmon'), 'LineWidth', 3) ;
        allNeuronsMean.(brainParts{iBrainPart}).allNeurons(iNeuron, :) = [meanPhase, meanEngagement] ;
        rlim([0 100])
        title(sprintf('Neuron %i', iNeuron))
        ax = gca ;
        ax.ThetaZeroLocation = 'top' ;
        ax.ThetaDir = 'clockwise' ;
        set(gcf, 'units', 'normalized', 'position', [0.1 0.3 0.2 0.6])
%         pause(3)
        close all

        keep phaseTable phaseType brainParts iBrainPart iNeuron allNeuronsMean brainPartColorMap
    end
end

%% plot the mean
singleLineWidth = 0.5 ;
meanLineWidth = 8 ;
CIlineWidth = 4 ;
% set(0, 'DefaultFigureVisible', 'on')
for iBrainPart = 1:size(brainParts,1) 
    plotColor = brainPartColorMap.PlotColor(find(strcmp(brainParts{iBrainPart}, brainPartColorMap.NameUsedByCode)), :) ;
    for iNeuron = 1:size(allNeuronsMean.(brainParts{iBrainPart}).allNeurons,1)
        polarplot([allNeuronsMean.(brainParts{iBrainPart}).allNeurons(iNeuron,1) , allNeuronsMean.(brainParts{iBrainPart}).allNeurons(iNeuron,1)], [0, allNeuronsMean.(brainParts{iBrainPart}).allNeurons(iNeuron,2)], ...
            '-', 'color', plotColor ,'LineWidth', singleLineWidth) ;
        hold on
    end
    [allNeuronsMean.(brainParts{iBrainPart}).meanPhase, allNeuronsMean.(brainParts{iBrainPart}).CIphase, allNeuronsMean.(brainParts{iBrainPart}).meanEngagement, allNeuronsMean.(brainParts{iBrainPart}).CIengagement]  = ...
        calculatePhaseStats(allNeuronsMean.(brainParts{iBrainPart}).allNeurons(:,1), allNeuronsMean.(brainParts{iBrainPart}).allNeurons(:,2))  ;

    polarplot([allNeuronsMean.(brainParts{iBrainPart}).meanPhase, allNeuronsMean.(brainParts{iBrainPart}).meanPhase], [0, allNeuronsMean.(brainParts{iBrainPart}).meanEngagement], '-', 'color', plotColor, 'LineWidth', meanLineWidth) ;
    polarplot([allNeuronsMean.(brainParts{iBrainPart}).CIphase(1), allNeuronsMean.(brainParts{iBrainPart}).CIphase(1)], [0, allNeuronsMean.(brainParts{iBrainPart}).meanEngagement], '-', 'color', plotColor, 'LineWidth', CIlineWidth) ;
    polarplot([allNeuronsMean.(brainParts{iBrainPart}).CIphase(2), allNeuronsMean.(brainParts{iBrainPart}).CIphase(2)], [0, allNeuronsMean.(brainParts{iBrainPart}).meanEngagement], '-', 'color', plotColor, 'LineWidth', CIlineWidth) ;
end

rlim([0 100])
title('All Neurons')
ax = gca ;
ax.ThetaZeroLocation = 'top' ;
ax.ThetaDir = 'clockwise' ;

radius = 20 ;
for iBrainPart = 1:size(brainParts,1) 
    text(4, radius, brainParts{iBrainPart}, 'color', plotColor, 'fontsize', 20, 'interpreter', 'none')
    radius = radius +10 ;
end


set(gcf, 'units', 'normalized', 'position', [0.1 0.3 0.2 0.6])