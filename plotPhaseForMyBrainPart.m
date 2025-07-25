function plotPhaseForMyBrainPart(currentBrainPart, SWD, plotSaveDir, currentName)
% parent function: phaseStackedHistosPLOT.m

%%

%%
allMouseIDs = unique(currentBrainPart.MouseID) ;

%%

tableCounter = 1; 
phaseHistCounts = table ;
for iMouse = 1:length(allMouseIDs)
    mouseIDXs = find(strcmp(currentBrainPart.MouseID, allMouseIDs{iMouse}) == 1);
    currentMouse = currentBrainPart(mouseIDXs,:) ;
    neuronIDs = unique(currentMouse.NeuronID);
    
    for iNeuron = 1:length(neuronIDs)
        neuronIDXs = find(currentMouse.NeuronID == neuronIDs(iNeuron)) ;
        neuronHist = sum(vertcat(currentMouse.HistCounts{neuronIDXs}),1) ;
        % neuronHistDouble = [neuronHist, neuronHist] ;
        phaseHistCounts.MouseID{tableCounter} = allMouseIDs{iMouse} ;
        phaseHistCounts.NeuronID(tableCounter) = neuronIDs(iNeuron) ;
        phaseHistCounts.HistCounts{tableCounter} = neuronHist ;
        tableCounter  = tableCounter +1 ;
        % bar(neuronHistDouble)
        clear neuronIDXs neuronHist
    end
    clear mouseIDXs currentMouse neuronIDs
end


%% plot SWD cycle
subplot(3,1,1:2)
startIDX = find(SWD(:,1) >= 527.2, 1) ;
endIDX = find(SWD(:,1) >= 527.7,1) ;
timeC = SWD(startIDX:endIDX, 1) ;
EEG = SWD(startIDX:endIDX, 2) ;
troughsData = findpeaks(-EEG) ;
troughs(:,1) = troughsData.loc ;
troughs(:,2) = EEG(troughsData.loc) ;
troughs = sortrows(troughs, 2, 'ascend') ;
realTroughs = troughs([1,7],1) ;

pushTime = 0 ;

periodSEC = timeC(realTroughs(1)) - timeC(realTroughs(2));
startEEGplotTIME = timeC(realTroughs(2)) + periodSEC/2 + pushTime;
startIDX = find(timeC >= startEEGplotTIME, 1) ;
endEEGplotTIME = startEEGplotTIME + periodSEC + pushTime ;
endIDX = find(timeC >= endEEGplotTIME, 1) ;

finalEEGtimeC = timeC(startIDX:endIDX) - timeC(startIDX)  ;
finalEEGeeg = EEG(startIDX:endIDX) ;

% EEG = SWD(startIDX:endIDX, 2) ;
spikeTime = 0.094 ;
spikeTimeIDX = find(finalEEGtimeC >= spikeTime, 1) ;


plot(finalEEGtimeC, finalEEGeeg, 'k', 'LineWidth', 3)
hold on
 plot([spikeTime, spikeTime], [min(finalEEGeeg), max(finalEEGeeg)], 'r-')

axis([finalEEGtimeC(1), finalEEGtimeC(end), -inf, inf])

set(gca,'XColor', 'none','YColor','none')
set(gca, 'color', 'none');
title(currentName, 'Interpreter','none')

%% plot histogram
bins = [-99:100] ;
histCountsPlot = zeros(1,200) ;

%% define histo color
colors = {'black'; 'red'; 'cyan'; 'darkgreen'; 'Magenta'; 'DarkCyan'; 'Lime'; 'Gold'; 'Brown'; 'HotPink'; 'DarkOrange'; 'DimGray'; 'Indigo'} ;
mouseIDs = unique(phaseHistCounts.MouseID) ;
allColors = [] ;
for iMouse = 1:length(mouseIDs)
    mouseIDXs = find(strcmp(phaseHistCounts.MouseID, mouseIDs{iMouse}) ==1) ;
    for iIDX = 1:length(mouseIDXs)
         currentColors{iIDX, 1} = colors{iMouse};
    end
    allColors = [allColors; currentColors] ;
end

%% plot save dir
% plotSaveDir = '/media/mark2X/ela/phaseHistoFigs' ;
%% plot histo
subplot(3,1,3)
    for iRow = 1:size(phaseHistCounts,1)
        if iRow == 201
            x = 1
        end
        iRow
        getRows = 1:iRow ;
        currentHistCounts = vertcat(phaseHistCounts.HistCounts{getRows}) ;
        currentHistCountsDouble = [currentHistCounts, currentHistCounts];
        ba = bar(bins, currentHistCountsDouble, 'stacked', 'FaceColor','flat') ;
        hold on
        plot([0, 0], [0, max(sum(currentHistCountsDouble,1))], 'r-')
        box off
        hold off
        for iGetRow = 1:length(getRows) ;
            currentColor = rgb(allColors{iGetRow}) ;
            try
                ba(iGetRow).CData = currentColor ;
            catch

            end
        end
        
        axis([-50, 50, 0, inf])
        xticks([-50, 0, 50]) ;
        set(gca, 'TickDir', 'out', 'FontSize', 15)
        make_my_figure_fit_HW(6,20)
        figFileName = sprintf('%s/%s', plotSaveDir, currentName) ;
        if iRow == size(phaseHistCounts, 1)
            print(figFileName, '-dpng', '-r800')
        end
    
    end
