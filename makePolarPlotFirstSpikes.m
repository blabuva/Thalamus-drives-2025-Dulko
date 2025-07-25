function phaseTable = makePolarPlotFirstSpikes(brainParts, cellEngagementPercent, spikePhases, cMapJet, tempFigDump, folderDump, mouseID, analyticsTimeStamp) 
% parent function: parseThePhaseFile.m

% save('/home/mark/matlab_temp_variables/ppAS')
% ccc
% load('/home/mark/matlab_temp_variables/ppAS')

%% defind some initial fig props 
set(0,'DefaultFigureVisible','off')
figNum = 1; 
subplotNum = 1 ;
numColorSteps = floor(size(jet,1)/size(cellEngagementPercent.(brainParts{1}),2)) ;

%% define number of subplots per page
subRows = 4; 
subCols = 3 ;

%%
for iBrainPart = 1:size(brainParts,1) - 1
    
  for iNeuron = 1:size(cellEngagementPercent.(brainParts{iBrainPart}),1)
      colorStep = 1 ;
      subplot(subRows, subCols, subplotNum)
        currentEngagements = cellEngagementPercent.(brainParts{iBrainPart})(iNeuron,:) ;
        for iSWD = 1:size(spikePhases.(brainParts{iBrainPart}),2)
            currentSeizure = spikePhases.(brainParts{iBrainPart}){iSWD} ;
            if isfield(currentSeizure, 'RawPhases') == 1
                currentPhases = spikePhases.(brainParts{iBrainPart}){iSWD}.RawPhases(iNeuron,:) ;
                iFirsts = 1 ;
                    iAll = 1 ;
                    for iPhase =1:size(currentPhases,2)
                        if ~isempty(currentPhases{iPhase})
                            for iSpike = 1:size(currentPhases{iPhase},2)
                                spikePhaseDegrees = currentPhases{iPhase}(iSpike) * 360 ;
                                spikePhase = deg2rad(spikePhaseDegrees) ;
                                allSpikePhases(iAll, 1:4) = [currentPhases{iPhase}(iSpike), spikePhaseDegrees, spikePhase, currentEngagements(iSWD)] ;
                                iAll = iAll + 1; 
                                if iSpike == 1
                                    polarplot(spikePhase, currentEngagements(iSWD), 'o', 'markerfacecolor', 'r', 'markeredgecolor', 'r', 'markersize', 1)
                                    allFirstSpikePhases(iFirsts, 1:4) = [currentPhases{iPhase}(iSpike), spikePhaseDegrees, spikePhase, currentEngagements(iSWD)] ;
                                    iFirsts = iFirsts + 1; 
                                else
                                    polarplot(spikePhase, currentEngagements(iSWD), 'o', 'markerfacecolor', 'k', 'markeredgecolor', 'k', 'markersize', 1)
                                end
                                hold on
                            end
                        end
                    end
            end

            colorStep = colorStep + numColorSteps ;
            doesItExist = exist('allFirstSpikePhases') ;
            if  doesItExist == 1
                allFirstSpikePhases_allSWDs{iNeuron, iSWD} = array2table(allFirstSpikePhases, 'VariableNames', {'NormPhase', 'DegreePhase', 'RadPhase', 'Engangement'}) ;
            else
                allFirstSpikePhases_allSWDs{iNeuron, iSWD} = [] ;
            end

            doesItExist = exist('allSpikePhases') ;
            if  doesItExist == 1
                allSpikePhases_allSWDs{iNeuron, iSWD} = array2table(allSpikePhases, 'VariableNames', {'NormPhase', 'DegreePhase', 'RadPhase', 'Engangement'}) ;
            else
                allSpikePhases_allSWDs{iNeuron, iSWD} = [] ;
            end
                
            clear allFirstSpikePhases allSpikePhases currentPhases
        end
        clear currentEngagements


try
    rlim([0 100])
    title(sprintf('Neuron %i', iNeuron))
    ax = gca ;
    ax.ThetaZeroLocation = 'top' ;
    ax.ThetaDir = 'clockwise' ;
catch
end


    subplotNum = subplotNum + 1; 
    if subplotNum ==13
        subplotNum = 1 ;
%         set(gcf, 'units', 'normalized', 'position', [0.1 0.3 0.2 0.6])
        make_my_figure_fit_HW(10,15)
        print(sprintf('%s/%04d_firstSpikes__%s', tempFigDump, figNum, analyticsTimeStamp), '-r500', '-dpng')
        print(sprintf('%s/%04d_firstSpikes__%s', tempFigDump, figNum, analyticsTimeStamp), '-r500', '-depsc')

        close all
        figNum = figNum + 1 ;
    end
  end
  % save final fig:
  unix(sprintf('convert %s/*.png %s/pdfs/firstSpikes__%s__%s__%s.pdf', tempFigDump, folderDump, brainParts{iBrainPart}, mouseID, analyticsTimeStamp));

  unix(sprintf('mv %s/*.png %s/pngs/%s/.', tempFigDump, folderDump, brainParts{iBrainPart}));

  unix(sprintf('mv %s/*.eps %s/eps/%s/.', tempFigDump, folderDump, brainParts{iBrainPart}));

  unix(sprintf('rm -rf %s/*', tempFigDump)) ;

  phaseTable.(brainParts{iBrainPart}).firstSpikes = allFirstSpikePhases_allSWDs ;
  phaseTable.(brainParts{iBrainPart}).allSpikes = allSpikePhases_allSWDs ;
  clear allFirstSpikePhases_allSWDs allSpikePhases_allSWDs
end


%% reset default figure visibility to on
set(0,'DefaultFigureVisible','on')


