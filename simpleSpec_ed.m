function simpleSpec_ed(timeForEEG,EEG)

% add path to the spectrogram 
%addpath('/home/Matlab/scottSeizureDetection/FMAToolbox-master/')
% I got this code from Scott :) 

LFP = [timeForEEG,EEG]; % LFP is an Nx2 matrix. Column 1 is time, col2 is voltage data
winLen = 1; % FFT window lengthseconds
overLap = 0.75; % window overlap (seconds)
frange = [1 100]; % frequency range used for spectrogram (Hz)
[spectrogram,t,f] = MTSpectrogram(LFP,...
    'window',winLen,'overlap',overLap, ...
    'range',frange); % computes the spectrogram
%ax = axes('Position',[0.1, 0.1, 0.8, 0.8]); 
imagesc(t, f, log(spectrogram)); % power scales logarithmically with frequency, so take the log of the specgram
colormap(jet); 
set(gca,'YDir','normal');
ylabel('Frequency [Hz]'); 
ylabel(colorbar, 'Log Power (μV²/Hz)');
xlabel('bin');
end

