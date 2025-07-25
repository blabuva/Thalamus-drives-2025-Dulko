function saveProbeAnalytics(experimentData, dumpFolder, theTimeStamp, experimentInfo)

% save('/home/mark/matlab_temp_variables/spa')
% ccc
% load('/home/mark/matlab_temp_variables/spa')

%% extract analytics
brainParts = fieldnames(experimentData.SWDs) ;
for iBrainPart = 1:size(brainParts,1)
    for iSWD = 1:size(experimentData.SWDs.(brainParts{iBrainPart}).SWD,2)
%         if 
        spikePhases.SWDs.(brainParts{iBrainPart}){iSWD}.SingleUnitPhase = experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.SingleUnitPhase ;
        spikePhases.SWDs.(brainParts{iBrainPart}){iSWD}.MultiUnitPhase = experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.MultiUnitPhase ;
        spikePhases.SWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.theSeizure ;
        spikePhases.nonSWDs.(brainParts{iBrainPart}){iSWD}.SingleUnitPhase = experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.SingleUnitPhase ; 
        spikePhases.nonSWDs.(brainParts{iBrainPart}){iSWD}.MultiUnitPhase = experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.MultiUnitPhase ;  
        spikePhases.nonSWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.theSeizure ;


        firingFreqs.SWDs.(brainParts{iBrainPart}){iSWD}.freqs = experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.InstFF.allNeurons ;
        firingFreqs.SWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.theSeizure ;
        firingFreqs.nonSWDs.(brainParts{iBrainPart}){iSWD}.freqs = experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.InstFF.allNeurons ;
        firingFreqs.nonSWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.theSeizure ;

        psth.SWDs.(brainParts{iBrainPart}){iSWD} = experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.PSTH ;
        psth.SWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.SWDs.(brainParts{iBrainPart}).SWD{iSWD}.theSeizure ;
        psth.nonSWDs.(brainParts{iBrainPart}){iSWD} = experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.PSTH ;
        psth.nonSWDs.(brainParts{iBrainPart}){iSWD}.EEG =  experimentData.NON_SWDs.(brainParts{iBrainPart}).NON_SWD{iSWD}.theSeizure ;
    end
end

%% save variables
save(sprintf('%s/allData_%s__%s_%s', dumpFolder, theTimeStamp, experimentInfo.mouse.strain, experimentInfo.EEGreference), 'experimentData', '-v7.3') ;
save(sprintf('%s/spikePhases_%s__%s_%s', dumpFolder, theTimeStamp, experimentInfo.mouse.strain, experimentInfo.EEGreference), 'spikePhases','-v7.3') ;
save(sprintf('%s/firingFreqs_%s__%s_%s', dumpFolder, theTimeStamp, experimentInfo.mouse.strain, experimentInfo.EEGreference), 'firingFreqs', '-v7.3') ;
save(sprintf('%s/psth_%s__%s_%s', dumpFolder, theTimeStamp, experimentInfo.mouse.strain, experimentInfo.EEGreference), 'psth','-v7.3') ;
