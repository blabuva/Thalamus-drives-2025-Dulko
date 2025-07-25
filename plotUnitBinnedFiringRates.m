function data = plotUnitBinnedFiringRates(data, dataType, binsForFFs) 

% save('/home/mark/matlab_temp_variables/FRATEs')
% ccc
% load('/home/mark/matlab_temp_variables/FRATEs')

%% extract fieldnames of brain structures
brainParts = fieldnames(data) ;

%% loop through brain parts to extract spike times 
for iBrainPart = 1:size(brainParts,1)
    % loop through seizures per brain part
    for iSWD = 1:size(data.(brainParts{iBrainPart}).(dataType),2)
        currentSWDsingleUnits = data.(brainParts{iBrainPart}).(dataType){iSWD}.SWD_SingleUnits.unitsPreSWD ;
        swdStartTime = data.(brainParts{iBrainPart}).(dataType){iSWD}.theSeizure.TroughTimes{1}(1) ;
        swdBins = swdStartTime + binsForFFs ;
        for iNeuron = 1:size(currentSWDsingleUnits,1)
            spikeFreqBinned(iNeuron,:) = binSingleUnitFF(currentSWDsingleUnits{iNeuron}, swdBins) ;
        end
        data.(brainParts{iBrainPart}).preSWDbinnedFFs.perSWD{iSWD} = spikeFreqBinned ;
        clear currentSWDsingleUnits swdStartTime swdBins spikeFreqBinned
    end
end

%% define plot colors
pColors = {'red'; 'blue'; 'DarkGreen'; 'Purple'; 'black'; 'DarkOrange'; 'DeepSkyBlue'; 'Tan'; 'DeepPink'} ;

%% loop through to make plots
MSsingle = 1 ;
MSmean = 8 ;
subplotNum = 0 ;
for iBrainPart = 1:size(brainParts,1)
    % loop through seizures per brain part
    subplotNum = subplotNum+1 ;
    for iSWD = 1:size(data.(brainParts{iBrainPart}).preSWDbinnedFFs.perSWD,2)
        currentFF = data.(brainParts{iBrainPart}).preSWDbinnedFFs.perSWD{iSWD} ;
        for iNeuron = 1:size(currentFF,1)
            subplot(size(brainParts,1),2,subplotNum)
                plot(binsForFFs(2:end)-1, currentFF(iNeuron, :), 'o', 'markeredgecolor', rgb(pColors{iBrainPart}), 'LineWidth', 0.05 , 'MarkerSize', MSsingle)
                hold on
        end
            plot(binsForFFs(2:end)-1, nanmean(currentFF,1), '-o',  'markeredgecolor', rgb(pColors{iBrainPart}), 'color', rgb(pColors{iBrainPart}), 'LineWidth', 1, 'MarkerSize', MSmean)
            axis([binsForFFs(1), binsForFFs(end), 0, inf])
            xticks([binsForFFs])
            title(sprintf('%s: Firing Rates for All Seizures', brainParts{iBrainPart}), 'interpreter', 'none')
           allMeanFFs(iSWD,:) = nanmean(currentFF,1) ;
            clear curentFF
    end
                subplotNum = subplotNum+1 ;
             subplot(size(brainParts,1),2,subplotNum)
                plot(binsForFFs(2:end)-1, nanmean(allMeanFFs,1), '-o',  'markeredgecolor', rgb(pColors{iBrainPart}), 'color', rgb(pColors{iBrainPart}), 'LineWidth', 1, 'MarkerSize', MSmean)
                axis([binsForFFs(1), binsForFFs(end), 0, inf])
                xticks([binsForFFs])
                title(sprintf('%s: Mean Firing Rates Across Seizures', brainParts{iBrainPart}), 'interpreter', 'none')
                data.(brainParts{iBrainPart}).preSWDbinnedFFs.meanAcrossNeurons = allMeanFFs ;
                clear allMeanFFs
end

%%
set(gcf, 'units', 'normalized', 'position', [0.1 0.4 0.2 0.6])
make_my_figure_fit_HW(10, 15) ;
figDump = '/media/probeX/intanData/ela/markTemp/0024/plots/' ;
figName = sprintf('%s%s_binnedFiringRates', figDump, dataType) ;
print(figName, '-dpng', '-r300')
close all

