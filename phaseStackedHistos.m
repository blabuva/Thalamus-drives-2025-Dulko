%%
% ccc
% load('/home/mark/matlab_temp_variables/phaseData2024-08-16');
%%
warning('off', 'all') ;

%%
keep phase structureLumper
clc, close all ;

%%
allOriginalStructureNames = fieldnames(phase.gria) ;
allLumpedStructureNames = unique(structureLumper.KeepAs_name__Don_tAnalyse) ;
for iStructure = 1:length(allLumpedStructureNames)
    currentLumpedStructure = allLumpedStructureNames{iStructure} ;
    tableCounter = 1;
    for iOldStructure = 1:size(structureLumper,1)        
        originalName = structureLumper.marksName{iOldStructure} ;
        elaName = structureLumper.KeepAs_name__Don_tAnalyse{iOldStructure} ;
        phaseTableIDX = find(contains(allOriginalStructureNames, originalName));
        if strcmp(currentLumpedStructure, elaName) == 1
            if isfield(phase.gria, originalName) == 1
                data = phase.gria.(originalName) ;
                dataFields = fieldnames(data) ;
                if tableCounter == 1
                    for iField = 1:length(dataFields)
                        lumpedPhase.gria.(currentLumpedStructure).(dataFields{iField}) = data.(dataFields{iField}).data ; 
                    end
                else
                     for iField = 1:length(dataFields)
                         if tableCounter ==3
                             x = 1;
                         end
                        lumpedPhase.gria.(currentLumpedStructure).(dataFields{iField}) = vertcat(lumpedPhase.gria.(currentLumpedStructure).(dataFields{iField}), data.(dataFields{iField}).data) ;
                     end
                end
    
                tableCounter = tableCounter+1 ;
                clear data dataFields
            end
        end
        
    end
        % elaName = structureLumper

    end
    
%% bin size
binSize = 0.01 ;
binEdges = 0:binSize:1 ;
    
    %%
% MDall = lumpedPhase.gria.Mediodorsal_nucleus_of_thalamus.singleALL ;
% mouseIDs = unique(MDall.MouseID) ;

%%
lumpedFields = fieldnames(lumpedPhase.gria) ;
for iField = 1:length(lumpedFields)    
    currentStructure = lumpedFields{iField} ;
    lumpedPhase.gria.(currentStructure).histCounts.singleALL = table ;
    tableCounter = 1 ;
    structureData = lumpedPhase.gria.(currentStructure).singleALL ;
    mouseIDs = unique(structureData.MouseID);
    for iMouse = 1:length(mouseIDs)
        currentID = mouseIDs{iMouse} ;
        mouseIDXs = find(strcmp(structureData.MouseID, currentID) == 1) ;
        for iSeizure = 1:length(mouseIDXs)
            currentSeizure = structureData.Phase{iSeizure} ;
            currentSeizureNum = structureData.SeizureNum(iSeizure) ;
            for iNeuron = 1:size(currentSeizure,1)
                currentNeuronID = currentSeizure.ClusterID(iNeuron);
                currentNeuronPhase = currentSeizure.Phase{iNeuron} ;
                if ~isempty(currentNeuronPhase)
                    cycles = unique(currentNeuronPhase.CycleNumber) ;
                    for iCycle = 1:length(cycles)
                        cycleIDXs = find(cycles(iCycle) == currentNeuronPhase.CycleNumber) ;
                        currentCyclePhase = currentNeuronPhase.Phase(cycleIDXs) ;

                        histC = histcounts(currentCyclePhase, binEdges) ;
                        lumpedPhase.gria.(currentStructure).histCounts.singleALL.MouseID{tableCounter} = currentID ;
                        lumpedPhase.gria.(currentStructure).histCounts.singleALL.NeuronID(tableCounter) = currentNeuronID ;
                        lumpedPhase.gria.(currentStructure).histCounts.singleALL.SeizureNum(tableCounter) = currentSeizureNum ;
                        lumpedPhase.gria.(currentStructure).histCounts.singleALL.CycleNum(tableCounter) = cycles(iCycle) ;
                        lumpedPhase.gria.(currentStructure).histCounts.singleALL.HistCounts{tableCounter} = histC ;
                        tableCounter = tableCounter + 1 ;
                        clear cycleIDXs histC
                    end
                    x = 1;
                end
                clear currentNeuronPhase currentNeuronID
            end
            clear currentSeizure currentSeizureNum
        end
        clear mouseIDXs
    end
    clear currentStructure structureData mouseIDs
end