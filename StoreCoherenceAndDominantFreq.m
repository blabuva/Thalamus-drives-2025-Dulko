function [DominantFrequency,CoherenceMatrix,PeakCoherence] = StoreCoherenceAndDominantFreq(COHR,iMouse,uniqueNames,DominantFrequency,numSeizures,f,labelsBigTable,CoherenceMatrix,PeakCoherence,numStructures)
% parent function: StartHere.m

for iStructure = 1:numStructures

    % calculate mean coherence
    allCoherences = []; % prepare for storing coherences for each seizure
    for iSeizure = 1:numSeizures
        allCoherences = [allCoherences, COHR{iStructure,iSeizure}];
    end
    mCoherence = nanmean(allCoherences,2); % calculate mean Coherence

    if  isnan(mCoherence(1,1))
        continue 
    end
        % Find and store the peak of coherence and the dominant frequency
        % Plot if you wish
        % figure;
        % plot(f,mCoherence,"black",'LineWidth',2)
        % xlim([0 50]);
        peakCoh = max(mCoherence);
        % yline(PeakCoherence,"blue",'LineWidth',2);
        [FrequencyIdx,~] = find(mCoherence == peakCoh); % find index in freq corresponding to the highest coherence
        domFrequency = f(FrequencyIdx);
        % xline(domFrequency,"green", 'LineWidth', 2);
        % ylabel('Mean Coherence');
        % xlabel('Frequency in Hz');
    
        % Store dominant frequency for this structure
        currentStructure = uniqueNames{iStructure};
        StructureIndex = find(strcmp(labelsBigTable, currentStructure));
        MouseIndex = iMouse;
    
        DominantFrequency(StructureIndex,MouseIndex) = domFrequency;
        CoherenceMatrix{StructureIndex,MouseIndex} = peakCoh; % store peak coherence. Will be used for color intensity in the heatmap
       % store the whole coherence 
       CoherenceMatrix{StructureIndex,MouseIndex} = mCoherence; % store whole mean coherence
end


end 