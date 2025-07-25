%% load in all channels for experiment
ccc ;

%% define experiment and get rhd filenames
dataPath = '/media/probeX/intanData/ela/markTemp/0024/rawData/' ;
rhdFiles = dir(sprintf('%s*.rhd', dataPath)) ;

%% load rhd files and only keep raw channel data
allChannels = [] ;
timeCraw = [] ;
EEGraw = [] ;
for iFile = 1:size(rhdFiles,1)
    allData = read_Intan_RHD2000_file_mpb(dataPath, rhdFiles(iFile).name) ;
    allChannels = [allChannels, allData.amplifier_data] ;
    timeCraw = [timeCraw, allData.t_amplifier] ;
    EEGraw = [EEGraw, allData.board_adc_data] ;
    clear allData
end

%% decimate data
deciVal = 5 ;
reshapeAllChannels = allChannels' ; 
clear allChannels ;
decimatedAllChannels = downsample(reshapeAllChannels, deciVal) ;
allChannels = decimatedAllChannels' ;
timeC = downsample(timeCraw, deciVal) ;
EEG = downsample(EEGraw, deciVal) ;
keep timeC allChannels EEG;

%% define start and end time to collect
startTime = 200 ; % in sec
endTime = 400 ; % in sec

%% find indices of start/end times
startIDX = find(timeC >= startTime) ;
endIDX = find(timeC >= endTime) ;

%% seizure chunk
seizureChannels = allChannels(:, startIDX:endIDX) ;
timeCchunk = timeC(startIDX:endIDX) ;
EEGchunk = EEG(startIDX:endIDX) ;

%% place data into structure
channels0024.allChannels = seizureChannels ;
channels0024.timeC = timeCchunk ;
channels0024.EEG = EEGchunk ;
clear allChannels timeC seizureChannels timeCchunk;

%% save  chunk 
save('/media/probeX/intanData/ela/markTemp/0024/rawData/rawChannels0024_seizure01', 'channels0024') ;


