function raw = threshRawIntanData(dataPathRaw, map,  spikeThreshold, hiPassFilt)
% Parent Function: analyzeElasExperiment.m

% save('/home/mark/matlab_temp_variables/intanRAW') ;
% ccc
% load('/home/mark/matlab_temp_variables/intanRAW') ;

%% collect files in intanDir (only rhd files)
intanFiles = dir(sprintf('%s/*.rhd', dataPathRaw)) ;

%% just to be safe, sort rhd files according to timestamp (to ensure proper chronological concatentation)
[~,intanIDX] = sort([intanFiles.datenum]);
intanFiles = intanFiles(intanIDX) ;

%% load raw intan files
raw.channelData = [];
raw.timeData = [] ;
for iFile = 1:size(intanFiles,1)
    rawIntanFile = read_Intan_RHD2000_file_mpb(dataPathRaw, intanFiles(iFile).name) ;
    if iFile == 1
        raw.channelInfo = rawIntanFile.amplifier_channels ;
        raw.samplingRate = rawIntanFile.sample_rate;
    end
    raw.channelData = [raw.channelData, rawIntanFile.amplifier_data] ;
    raw.timeData = [raw.timeData, rawIntanFile.t_amplifier] ;
    clear rawIntanFile
end

%% find spikes in raw channels
% first pre-populate spikeData so that par-for loop can be run.
for iChan = 1:size(raw.channelData,1)
    spikeData{iChan,1} = [] ;
end

% run par-for loop: memory issues. Don't par-for. Even if only using 2 workers - don't understand. 
for iChan = 1:size(raw.channelData,1)
    disp(sprintf('Channel %i', iChan))
    spikeData{iChan,1} = findRawIntanSpikes(raw.channelData(iChan, :)', raw.timeData', raw.samplingRate, hiPassFilt, spikeThreshold) ;
end

raw.spikeData = array2table(([1:size(raw.channelData,1)])', 'VariableNames', {'ChannelNumber'}) ;
raw.spikeData.SpikeData = spikeData ;
raw.spikeData.Channel_Xposition = map.channelPositions(:,1);
raw.spikeData.Channel_Yposition = map.channelPositions(:,2);
raw.spikeData.ChannelBrainLocation = map.channelBrainLocations(:,2) ;








