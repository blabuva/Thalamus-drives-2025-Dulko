
% cohr = abs(avSXY) ./ (sqrt(avSXX) .* sqrt(avSYY));

function [coherence] = calcCoherence(crossSpectrum, avgP, meanPowerSpikes,f)
    % calcCoherence computes the coherence between LFP and spike data
    
    %avSXY = mean(crossSpectrum, 2);  % Average the cross-spectrum across trials
    
    % Compute the coherence using the formula
    coherence = abs(crossSpectrum) ./ (sqrt(avgP) .* sqrt(meanPowerSpikes));  % 513 x 1
    
    % Plot the coherence if you wish 
    % figure; plot(f, coherence); xlabel('Frequency (Hz)'); ylabel('Coherence');
    % xlim([0 50]); title('Coherence between LFP and Spike Data');
end
