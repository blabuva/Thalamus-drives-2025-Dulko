function [f, s_eeg, avgP] = SEPTcalcPower(EEG)

% ~~~ parent function: SEPTcalcPower(EEG,dt) 
% calculate mean power across different windows 
% S - variable will be used to study the phase relationship 

% Parameters
windowSize = 500;  % Define window size (number of samples per window)
overlap = 250;     % Overlap between windows (e.g., 50% overlap)
nfft = 1024;       % Number of points for FFT
Fs = 1000;
dt = 1/Fs; % 1 divided by sampling frequency dt - time step


% Compute the spectrogram (this also gives you the power spectrum over time)
[S, f, t, P] = spectrogram(EEG, hamming(windowSize), overlap, nfft, 1/dt,'psd'); 
s_eeg = S; 
% Compute the average PSD across all time windows
avgP = mean(P, 2); % Average over columns (time windows)

% Plot the average PSD
plot(f, avgP); % Convert to decibels
xlabel('Frequency (Hz)');
xlim([0 50]);
ylabel('Power/Frequency (mV^2/Hz)'); % IF OUR VOLTAGE IS IN mV. NEED TO CHECK THAT 
title('Spectral Density - LFP ');


% Previous versions 

% Compute power spectrum from spectrogram
%Sxx = abs(S).^2;

% There are multiple lines because of the windowing 
% Plot power spectrum (linear or log scale)
% figure;
% plot(f, abs(Sxx)); % Linear scale for power
% xlabel('Frequency (Hz)');
% ylabel('Power');
% title('Power Spectrum');
% xlim([0 50]); % Limit frequency range to 0-50 Hz

%% Now we calculate the mean across all windows. The line will be smoother 
% Plot power spectrum (linear or log scale)
% Assuming 'Sxx' contains the power spectrum for each window
% and 'f' is the frequency axis (same for all windows)

% 1. Compute the mean power spectrum across all windows
%meanPower = mean(Sxx, 2);  % Take the mean across windows (dimension 2)
    % Normalize by frequency bin width to get mV^2/Hz
    %freqResolution = f(2) - f(1); % The width of each frequency bin
    %Sxx_mV2_Hz = Sxx / freqResolution;

    % Compute the mean power spectrum across windows
    %meanPower_mV2_Hz = mean(Sxx_mV2_Hz, 2)


% 2. Plot the mean power spectrum
% plot(f, meanPower_mV2_Hz);
% xlabel('Frequency (Hz)');
% ylabel('Power in mV^2');
% xlim([0 50]);  % Limit frequency axis to 0-50 Hz
% title('Mean Power Spectrum');

end
