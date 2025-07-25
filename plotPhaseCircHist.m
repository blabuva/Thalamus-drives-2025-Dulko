function plotPhaseCircHist(currentSWD, iNeuron, iPlot, iSWD, numSWDs, maxYforPlots, theColorMap)
% % parent function: makeUnitPopPlots.m
% save('/home/mark/matlab_temp_variables/circPhase')
% ccc
% load('/home/mark/matlab_temp_variables/circPhase')

currentNeuronPhases = cell2mat(currentSWD(iNeuron,:)) ;
currentNeuronEngagement = 100 * (nnz(cellfun(@isempty,currentSWD(iNeuron, :)))/size(currentSWD,2)) ;
currentNeuron = currentSWD(iNeuron, :) ;   

%% make the phase plots
for iCycle = 1:length(currentNeuron)
    currentCycle = currentNeuron{iCycle} ;
    currentRBcolor = theColorMap(iCycle, :) ;
    if ~isempty(currentCycle)
        spikePhase = deg2rad(currentCycle * 360) ;
        numSpikes = length(currentCycle) ;
        polarplot(spikePhase, ones(numSpikes,1)*numSpikes, 'o', 'markerfacecolor', currentRBcolor, 'markeredgecolor', 'k', ...
            'markersize', 4)
        hold on
        clear currentCycle numSpikes
    end
end 

%% set plot params
ax = gca ;
ax.ThetaZeroLocation = 'top' ;
ax.ThetaDir = 'clockwise' ;
ax.FontSize = 3 ;
ax.TitleFontSizeMultiplier  =5 ;
ax.FontWeight = 'bold ' ;
thetaticks([0 90 180 270])
thetaticklabels({'','','',''})
rlim([0 maxYforPlots])
radiusTicks = rticks ;

for iLabel = 1:length(radiusTicks)-1
    rl{iLabel} = '' ;
end
    rl{end+1} = num2str(radiusTicks(end)) ;                        
    rticklabels(rl)

if iPlot <= numSWDs
    title(sprintf('SWD %i', iSWD))
    subtitle(sprintf('%i Cycles', size(currentSWD,2)))
end
                

