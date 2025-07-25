
function [IBIs] = calculateIBI_2(singleUnits, minSpikesInBurst, burstISIthreshold, iRow, folderName, targetStructure, eeg, time, seizureStart, seizureEnd)
% parent function: detectBursts_ed.m 

% Burst definition according to Crunelli  

silenceBeforeBurst = 0.1; % 100 ms of silence before a burst

figure; 
subplot(2,1,1); % plot EEG
plot(time, eeg, 'k-'); 
xlim([seizureStart, seizureEnd]); 

subplot(2,1,2); % plot the raster
IBIs = []; % store IBIs for all neurons in this seizure

for irow = 1:size(singleUnits, 1)
    spikeTimes = singleUnits.SWD_Spikes{irow,1}; % spike times for one neuron

    if isempty(spikeTimes) || numel(spikeTimes) < minSpikesInBurst
        continue
    end

    hold on;
    yLevel = irow;

    % Plot all spikes in black
    for k = 1:length(spikeTimes)
        line([spikeTimes(k) spikeTimes(k)], [yLevel - 0.4 yLevel + 0.4], 'Color', 'k');
    end

    burstStartTimes = [];

    i = 1;
    while i <= length(spikeTimes) - (minSpikesInBurst - 1)
        windowSpikes = spikeTimes(i:i+minSpikesInBurst-1);
        ISIs = diff(windowSpikes);

        if all(ISIs <= burstISIthreshold)
            if i == 1 || (spikeTimes(i) - spikeTimes(i-1)) >= silenceBeforeBurst
                % Found a burst; extend it if more spikes with short ISI follow
                burstEnd = i + minSpikesInBurst - 1;
                while burstEnd < length(spikeTimes) && (spikeTimes(burstEnd+1) - spikeTimes(burstEnd)) <= burstISIthreshold
                    burstEnd = burstEnd + 1;
                end

                burstStartTimes(end+1,1) = spikeTimes(i); % store burst start
                % Optional: could store full burst here if needed

                % Plot red line for burst start
                line([spikeTimes(i) spikeTimes(i)], [yLevel - 0.4 yLevel + 0.4], 'Color', 'r', 'LineWidth', 2);

                i = burstEnd + 1; % skip past this burst
                continue
            end
        end

        i = i + 1;
    end

    % Compute IBIs if more than one burst
    if numel(burstStartTimes) >= 2
        interBurstIntervals = diff(burstStartTimes);
        IBIs = [IBIs; interBurstIntervals];
    end
end

xlim([seizureStart, seizureEnd]);

% Save the figure
fileName = sprintf('%s_Row%d.png', targetStructure, iRow);
savePath = fullfile(folderName, fileName);
saveas(gcf, savePath);

close
end
