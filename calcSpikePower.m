function [f,s_spikes, meanPowerSpikes] = calcSpikePower(counts)
    % calcSpikePower computes the mean power spectrum for spike data using windowing
    
    % Parameters
    windowSize = 500;  % Define window size (number of samples per window)
    overlap = 250;     % Overlap between windows (e.g., 50% overlap)
    nfft = 1024;       % Number of points for FFT
    Fs = 1000;
    dt = 1/Fs; % 1 divided by sampling frequency dt - time step
    
    
    [meanPowerSpikes, f] = pwelch(counts, hamming(windowSize), overlap, nfft, Fs);
    
    % calculate the Fourier transform of spikes -> will be used for phase
    % analysis later 
    % Compute the Fourier transform of the spike counts
   
    % ~~ added 9/27/2024 in order to get the phase info 
  % Compute the spectrogram of the spike counts (S_spikes is the complex Fourier coefficients)
    [s,~,~] = spectrogram(counts, hamming(windowSize), overlap, nfft, Fs);
    s_spikes = s; % assign new name 

  


end 