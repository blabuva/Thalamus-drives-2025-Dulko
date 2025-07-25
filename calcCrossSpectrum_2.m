function [crossSpectrum] = calcCrossSpectrum_2(meanPowerSpikes,avgP)

S_yy = meanPowerSpikes; % in mV^2 / Hz  
S_xx = avgP; % in mV^2 / Hz

crossSpectrum = S_xx .* S_yy; % in (mV^2/Hz)^2

% Plot the cross-spectrum magnitude
% figure;
% plot(f, abs(crossSpectrum)); % Use abs() to plot magnitude
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (mV^2/Hz)^2');
% title('Cross-Spectrum Magnitude');
% grid on;

end 

