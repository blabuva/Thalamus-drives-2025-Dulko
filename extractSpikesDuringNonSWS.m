function [AllBinned_NonSWSs] = extractSpikesDuringNonSWS(seizureStart,seizureEnd,binSize,OneSeizure,spikes,AllBinned_NonSWSs)
% parent function: calculateCorrelationCoeffForNeuronsEachSeizure.m 

% this function finds edges for a given seizure, extract spike times for
% all neurons in one structure. 
% INPUT:
% -- seizureStart % when did this seizure start
% -- seizureEnd % when did this seizure start

% find egdes for NON SEIZURE 
eventDuration = seizureEnd-seizureStart; % in seconds
dataCollectionStart = OneSeizure.DataCollectionStart(1);  % when did data collection start?
TimeToBeExtracted = eventDuration; % period to be extracted; is equal the seizure duration
Difference = seizureStart-dataCollectionStart; % how long is non-seizure length that the code can pick from
halfDifference = Difference/2;% calculate half distance
leftEdge = seizureStart-halfDifference; % establish the left edge
rightEdge = leftEdge+TimeToBeExtracted; % establish the right edge (left edge + time to be extracted)
edgesNonSWSs = [leftEdge: binSize: rightEdge];  % based on left and right edge and bin size, establish edges
    % extract spikes that fall in this time period for all neurons
    BinnedNonSWSs = NaN(size(spikes,1), numel(edgesNonSWSs)-1); % pre-popullate data with NaN
    for ni = 1:numel(spikes(:,1)) %% will look at neurons from 1 to the end
        BinnedNonSWSs(ni,:) = histcounts(spikes.SpikeTimesSec{ni,:}, edgesNonSWSs); % calculate how many spikes happen within each bin
    end
    if BinnedNonSWSs == 0
        display('Neuron did not fire during this seizure')
    end
    AllBinned_NonSWSs = [AllBinned_NonSWSs; BinnedNonSWSs];

end 