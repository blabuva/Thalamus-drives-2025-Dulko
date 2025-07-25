function [CorrelationsAllSeizures, CorrelationsAllNonSeizures, Labels] = calculateCorrelationCoeffForNeuronsEachSeizure(numSeizures,MouseDatabase,whatSeizures,binSize)
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m

% this function grabs action potentials for seizure period and non seizure
% period, calculates correlation coefficients for all possible neurons(
% from different nuclei) and returns correlations organized by event
% (seizure and non-seizure) 

CorrelationsAllSeizures = []; % Initiate for storing SEIZURE CORRs 
CorrelationsAllNonSeizures = []; % Initiate for storing NON Seizure CORRs 


for iSeizure = 1:numSeizures
    oneSeizureInd = (MouseDatabase.SeizureNumber == whatSeizures(iSeizure)); % get index for one seizure
    OneSeizure = MouseDatabase(oneSeizureInd, :); % grab data for one seizure
    seizureStart = OneSeizure.SeizureStartTime(1); % when did this seizure start
    seizureEnd = OneSeizure.SeizureEndTime(1); % when did this seizure start
    edges = [seizureStart: binSize: seizureEnd];
    
    Labels =[]; % collect brain structure name for each neuron
    numRows = size(OneSeizure,1);
    AllBinned = [];
    AllBinned_NonSWSs = []; 
    for iRow = 1:numRows
        x = OneSeizure.LumpedStructure(iRow); % which structure are we looking at now
        x = x{1,1}; % extract this structure's name 
        %% Extract spikes for this nucleus 
            AllSpikes = OneSeizure.SingleUnitsAll(iRow,:); % all, ihn, exc neurons / structure
            %spikes = AllSpikes{1,1}.all;
            spikes = AllSpikes{1,1}.all.CurrentSWD; 
            numNeurons = size(spikes,1); 
            % Repeat the structure name based on the number of neurons
            structureLabel = repmat({x}, 1, numNeurons);
            Labels = [Labels, structureLabel]; % Append to the "Labels" cell array
                %% Extract spikes for each neuron DURING SEIZURES and concatenate 
                        Binned = NaN(size(spikes,1), numel(edges)-1); % pre-popullate data with NaN
                        for ni = 1:numel(spikes(:,1)) %% will look at neurons from 1 to the end
                           Binned(ni,:) = histcounts(spikes.SpikeTimesSec{ni,:}, edges); % calculate how many spikes happen within each bin
                        end
                        if Binned == 0 
                            display('Neuron did not fire during this seizure')
                        end 
                        AllBinned = [AllBinned; Binned]; % all neurons from different structures are combined  

                %% Extract spikes for each neuron DURING NON - SEIZURES and concatenate  
                        [AllBinned_NonSWSs] = extractSpikesDuringNonSWS(seizureStart,seizureEnd,binSize,OneSeizure,spikes,AllBinned_NonSWSs); 

    end
    
    %% SEIZURES Calc corr coeff between all neurons 
    [R,P] = corrcoef(AllBinned');
    CorrelationsAllSeizures{iSeizure} = R;

    %% NON SEIZURES Calc corr coeff between all neurons 
    [R_non, P_non] = corrcoef(AllBinned_NonSWSs'); 
    CorrelationsAllNonSeizures{iSeizure} = R_non; 
end



end