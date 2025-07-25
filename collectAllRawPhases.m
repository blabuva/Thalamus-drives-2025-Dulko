function allDataTable = collectAllRawPhases(allDataTable, eventType, allExperiments, structureInfo, brainNames) 
% parent function: aggraPhase.m

% save('/home/mark/matlab_temp_variables/RawPhs')
% ccc
% load('/home/mark/matlab_temp_variables/RawPhs')

% clc; close all
% keep allDataTable eventType allExperiments structureInfo brainNames

%% define bin size for phase plots
binSize = 0.01 ;

%% create another SWD/non-SWD field name
if strcmp(eventType, 'SWDs') == 1
    eventType2 = 'SWD' ;
else
    eventType2 = 'nonSWD' ;
end

%%
for iExperiment = 1:length(allExperiments)
    currentExperiment = allExperiments{iExperiment}.experimentData.(eventType) ;
    analyticsTimeStamp = allExperiments{iExperiment}.analyticsTimeStamp ;
    pathToData = allExperiments{iExperiment}.pathToData ;
    mouseID = allExperiments{iExperiment}.mouseID ;    
    brainParts = fieldnames(currentExperiment) ;
    gender = allExperiments{iExperiment}.gender ;
    age = allExperiments{iExperiment}.age ;

    for iPart = 1:length(brainParts)
        currentPart = brainParts{iPart} ;
%         disp(currentPart)
        unitsAllSeizures = currentExperiment.(currentPart).(eventType2) ;
        for iSeizure = 1:length(unitsAllSeizures)
            if  isempty(unitsAllSeizures{iSeizure}.SingleUnitPhase.SpikePhases) ==0 

                SWDs{iSeizure,1} = currentExperiment.(currentPart).(eventType2){iSeizure}.theSeizure ;

                rawPhasesSingles = unitsAllSeizures{iSeizure}.SingleUnitPhase.SpikePhases.RawPhases ;
                rawPhasesMultis = unitsAllSeizures{iSeizure}.MultiUnitPhase.SpikePhases.RawPhases ;

                binPhasesSingles{iSeizure, 1} = binRawPhases(rawPhasesSingles, binSize) ;
                binPhasesMultis{iSeizure, 1} = binRawPhases(rawPhasesMultis, binSize) ;
                
                SingleUnitsSWD = unitsAllSeizures{iSeizure}.SWD_SingleUnits ;
                PSTH = unitsAllSeizures{iSeizure}.PSTH ;
                InstFF = unitsAllSeizures{iSeizure}.InstFF ;

                unitPhasePerSeizureSingles{iSeizure,1} =  rawPhasesSingles; % pretty sure that columns are cycles and rows are neurons
                unitPhasePerSeizureMultis{iSeizure,1} =  rawPhasesMultis; % pretty sure that columns are cycles and rows are neurons

                PSTHperSeizure{iSeizure,1} =  PSTH ;
                InstFFperSeizure{iSeizure,1} =  InstFF ;
                SingleUnitsSWDperSeizure{iSeizure,1} = SingleUnitsSWD ;

                clear rawPhasesSingles rawPhasesMultis PSTH InstFF SingleUnitsSWD
            end
        end
        currentPartIDX = find(strcmp(currentPart, brainNames),1) ;
        currentSizeOfElementsInStructure = length(allDataTable.(eventType).SingleUnitPhase{currentPartIDX}) ;

        if exist('unitPhasePerSeizureSingles') == 1   
            allDataTable.(eventType).theSWDs{currentPartIDX}{currentSizeOfElementsInStructure + 1} = SWDs ;

%             allDataTable.(eventType).SingleUnitPhase{currentPartIDX}{currentSizeOfElementsInStructure + 1} =  unitPhasePerSeizureSingles;
%             allDataTable.(eventType).MultiUnitPhase{currentPartIDX}{currentSizeOfElementsInStructure + 1} =  unitPhasePerSeizureMultis;

            tempTableSingle.RawPhases{currentPartIDX}{currentSizeOfElementsInStructure + 1} =  unitPhasePerSeizureSingles;
            tempTableMulti.RawPhases{currentPartIDX}{currentSizeOfElementsInStructure + 1} =  unitPhasePerSeizureMultis;

            allDataTable.(eventType).PSTH{currentPartIDX}{currentSizeOfElementsInStructure + 1} = PSTHperSeizure ;
            allDataTable.(eventType).InstFF{currentPartIDX}{currentSizeOfElementsInStructure + 1} = InstFFperSeizure ;
            allDataTable.(eventType).SingleUnitsSWD{currentPartIDX}{currentSizeOfElementsInStructure + 1} = SingleUnitsSWDperSeizure ;
            allDataTable.(eventType).AnalyticsTimeStamps{currentPartIDX}{currentSizeOfElementsInStructure + 1} = analyticsTimeStamp ;
            allDataTable.(eventType).MouseIDs{currentPartIDX}{currentSizeOfElementsInStructure + 1}  = mouseID ;
            allDataTable.(eventType).Genders{currentPartIDX}{currentSizeOfElementsInStructure + 1} = gender ;
            allDataTable.(eventType).Ages{currentPartIDX}{currentSizeOfElementsInStructure + 1} = age ;
            allDataTable.(eventType).PathsToData{currentPartIDX}{currentSizeOfElementsInStructure + 1} =pathToData ; 

            % for phase binning
            binPhasesAllNeuronsSingles = combinePhaseBinCounts(binPhasesSingles) ;
            binPhasesAllNeuronsMultis = combinePhaseBinCounts(binPhasesMultis) ;

            tempTableSingle.BinnedPhasesPerSWDCycle{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsSingles.EachCycle ;
            tempTableSingle.BinnedPhasesPerSWD{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsSingles.EachSeizure ;
            tempTableSingle.BinnedPhasesSumAcrossSWDs{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsSingles.SumAcrossSeizures ;
            tempTableSingle.BinnedPhasesMeanAcrossSWDs{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsSingles.MeanAcrossSeizures ;
        
            tempTableMulti.BinnedPhasesPerSWDCycle{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsMultis.EachCycle ;
            tempTableMulti.BinnedPhasesPerSWD{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsMultis.EachSeizure ;
            tempTableMulti.BinnedPhasesSumAcrossSWDs{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsMultis.SumAcrossSeizures ;
            tempTableMulti.BinnedPhasesMeanAcrossSWDs{currentPartIDX}{currentSizeOfElementsInStructure + 1} = binPhasesAllNeuronsMultis.MeanAcrossSeizures ;
        
        
        end


        clear currentPart unitsAllSeizures unitPhasePerSeizure PSTHperSeizure InstFFperSeizure SingleUnitsSWDperSeizure...
            currentPartIDX currentSizeOfElementsInStructure SWDs binPhasesAllNeuronsSingles AllNeuronsMultisbinPhases binPhasesSingles binPhasesMultis
    end
    allDataTable.(eventType).SingleUnitPhase = tempTableSingle ;
     allDataTable.(eventType).MultiUnitPhase = tempTableMulti ;

    clear currentExperiment brainParts analyticsTimeStamp pathToData mouseID tempTableSingle tempTableMulti
end