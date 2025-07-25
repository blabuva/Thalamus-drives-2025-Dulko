function ResultsExc = calcPhase_Excitatory(brainStructures,data,ResultsExc,iEventType,binEdges,class)
% parent function: MasterCodePhaseEla20250212.m 

for iStructure = 1:size(brainStructures,1)

    Y = brainStructures{iStructure};
    type = {'NON_SWD', 'SWD'}; % because Mark doesn't make my life easier
    x = type{iEventType}; % NON_SWD or SWD
    allEvents = data.(Y).(x);
    allPhaseValuesAllEvents = [];

    if isempty(allEvents{1, 1}.SingleUnitPhase.SpikePhases) % if there is no SU, there will be no phases
        ResultsExc{iStructure,1} = Y; % store brain structure's name
        ResultsExc{iStructure,iEventType+1} =  []; % store empty to know which ones were skipped
        %continue % skip this brain structure if this happens

    else
        % now ready for phase analysis
        for iEvent = 1:size(allEvents,2)
            rawPhases = allEvents{1,iEvent}.SingleUnitPhase.SpikePhases.RawPhases;
            % SELECT ONLY EXCITATORY UNITS
            filteredPhases = selectExcitatoryUnits(rawPhases,class,iStructure,allEvents);
            % raw phases (rows - neurons, columns - cycles)
            allPhaseValues = [];
            for iNeuron = 1:size(filteredPhases,1)
                phaseValues = cell2mat(filteredPhases(iNeuron,:));
                allPhaseValues = [allPhaseValues,phaseValues]; % store phase values, all neuron, 1 event
            end
            allPhaseValuesAllEvents = [allPhaseValuesAllEvents, allPhaseValues];

        end
        % calculate distribution across all events and plot histogram
        countsAllEvents = histcounts(allPhaseValuesAllEvents,binEdges);

        %figure; bar(binEdges(1:end-1),countsAllEvents,'histc'); % visualize if you wish

        % Store results for this experiment
        ResultsExc{iStructure,1} = Y; % store brain structure's name
        ResultsExc{iStructure,iEventType+1} = countsAllEvents; % store counts

    end


end % end for iStructure loop

end % function end