function spikeData = findRawIntanSpikes(rawChannel, channelTime, samplingRate, hiPassFilt, threshold) 
% Parent Function: threshRawIntanData.m

save('/home/mark/matlab_temp_variables/intanSpikes') ;
% ccc
% load('/home/mark/matlab_temp_variables/intanSpikes') ;

%% high pass filter the data
filtChan = highpass(rawChannel, hiPassFilt, samplingRate) ;

%% calculate RMS of entire channel
rmsChan = rms(filtChan) ;

%% calculate spike threshold (i.e., RMS * user defined threshold)
spikeThreshold = threshold * rmsChan ;

%% zero out sub-threshold points on channel (will facilitate peak detection)
zeroedChan = zeros(length(filtChan),1) ;
hiIDX = find(filtChan > spikeThreshold) ;
loIDX = find(filtChan < spikeThreshold *-1) ;

zeroedChan(hiIDX) = filtChan(hiIDX) ;
% zeroedChan(loIDX) = filtChan(loIDX) ;

%% find peaks of spikes
[peaks, locs] = findpeaks(zeroedChan, samplingRate,  'MinPeakDistance', 0.003) ;
spikes(:,1) = locs ;
spikes(:,2) = peaks;
spikeData = sortrows(spikes, 1) ;

skip =1 ;
if skip == 0
    %% plot channel
    subplot(2,1,1)
        plot(channelTime, filtChan, 'k')
        % and RMS:
        hold on
        plot(channelTime, ones(length(channelTime), 1)*rmsChan, 'g')
        plot(channelTime, ones(length(channelTime), 1)*rmsChan*-1, 'g')
        % and spike threshold
        plot(channelTime, ones(length(channelTime), 1)*spikeThreshold, 'r')
        plot(channelTime, ones(length(channelTime), 1)*spikeThreshold*-1, 'r')
    %     plot(channelTime(locs), filtChan(locs), 'ro')
        plot(locs, peaks, 'ro')
    
        axis([0, channelTime(end), -300, 300])
    
    subplot(2,1,2)
        plot(channelTime, zeroedChan, 'k')
       axis([0, channelTime(end), -300, 300])
    
    %% position figure
    set(gcf, 'units', 'normalized', 'position', [0.05, 0.1 , 0.9, 0.7])
end