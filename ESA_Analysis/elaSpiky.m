function [SPKrez] = elaSpiky(ssArray, tlim)
%% elaSpiky runs the Spiky code on segments of Ela's 
%
% INPUTS:
%   ssArray - 
%   tlim - tlim(1) is start time (in seconds) of epoch
%          tlim(2) is the corresponding end time (in seconds)
%
% OUTPUTS:
%   SPIKY METRICS
%   
% Written by Scott Kilianski
% Updated 10/1/2024
% ------------------------------------------------------------ %
%% --- Function Body --- %
pathToSPIKYws = 'C:\Users\Scott\Documents\SPIKY_30_Apr_2021\SPIKY\SPIKY_ws.mat';

% Restrict spikes to just intra-ictal times
% -- NEED TO RETRIEVE CORRESPONDING LFP -- %
hgt = numel(ssArray); % height of spike matrix
tmin = tlim(1); % minimum time, seconds (e.g. start of seizure)
tmax = tlim(2); % max time, seconds (e.g. end of seizure))
for ni = 1:hgt
    keepLog{ni} = ssArray{ni}> tmin & ssArray{ni} < tmax;
end

% -- Convert spikeArray to zero-padded matrix -- %
wid = max(cellfun(@sum,keepLog));   % width of spike matrix
spikesNew = zeros(hgt,wid);         % initialize the overall zero-padded spike matrix
spikeSubArray = cell(1,hgt);
for ni = 1:hgt
    spikesToKeep = ssArray{ni}(keepLog{ni});
    spikeSubArray{ni} = spikesToKeep';
    spikesNew(ni,1:numel(spikesToKeep)) = spikesToKeep;
end

keep spikesNew spikeSubArray tmin tmax pathToSPIKYws

%% Load SPIKY workspace dat
load(pathToSPIKYws); % path to the SPIKY workpsace
handles.figure1.Visible = 'off';

% -- Assign 'd_para' values -- %
spikes = spikeSubArray;
d_para.tmin = tmin;
d_para.tmax = tmax;
numCells = numel(spikeSubArray);
d_para.num_trains = numCells;
d_para.num_all_trains = numCells;
d_para.num_pairs = numCells*(numCells-1)/2;
d_para.num_allspikes = cellfun(@numel,spikeSubArray);
d_para.num_total_spikes = sum(cellfun(@numel,spikeSubArray));
d_para.pre_select_trains = 1:numCells;
d_para.max_num_allspikes = max(cellfun(@numel,spikeSubArray));
d_para.group_vect = ones(1,numCells);
d_para.select_trains = 1:numCells;
d_para.select_group_vect = ones(1,numCells);
d_para.num_select_group_trains = numCells;
d_para.cum_num_select_group_trains = numCells;
d_para.select_group_center = round(numCells/2);
d_para.num_spikes_ori = cellfun(@numel,spikeSubArray);
d_para.num_spikes = cellfun(@numel,spikeSubArray);


% Calculate the spike distances
SPIKY_calculate_distances;
keep results

% figure;
% sax(1) = subplot(211);
% plot(results.SPIKE.time, results.SPIKE.profile);
% sax(2) = subplot(212);
% plot(results.SPIKE_synchro.time, results.SPIKE_synchro.profile);
% linkaxes(sax,'x');

SPKrez = results;

end