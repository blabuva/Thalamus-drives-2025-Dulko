%%
clear all; close all; clc
load('\\172.28.76.244\probeX\intanData\ela\markTemp\0022\analyzedData\SPIKYoutput.mat','allspk');
for br = 1:size(allspk,1) % brain region
    syncVals = [];
    ctrlVals = [];
    for szn = 1:numel(allspk{br,2}) % seizure number
        for ti = 2:3
            szwv = allspk{br,ti}{szn}; % seizure window
            if ti == 2
                % syncVals = [syncVals;szwv.SPIKE_synchro.profile'];
                syncVals = [syncVals;szwv.SPIKE.profile'];

            elseif ti == 3
                % ctrlVals = [ctrlVals;szwv.SPIKE_synchro.profile'];
                ctrlVals = [ctrlVals;szwv.SPIKE.profile'];

            end
        end
    end

    %%
    figure;
    subplot(2,2,[1,3])
    binWidth = 0.05;
    histBE = 0:.05:1; % histogram bin edges
    histBC = histBE(2:end)-(binWidth/2);
    ctrlH = histcounts(ctrlVals,histBE,'Normalization','cdf');
    syncH = histcounts(syncVals,histBE,'Normalization','cdf');
    plot(histBC,ctrlH,'k');
    hold on
    plot(histBC,syncH,'r');
    hold off
    ylim([0 1]);
    ylabel('Cumulative probability');
    xlabel('Synchrony Value')

    numCells = size(szwv.spikes,2);
    brName = sprintf('%s (%d cells)',allspk{br,1}{1},numCells);
    title(brName);

    subplot(2,2,2);
    histogram(ctrlVals,histBE,'Normalization','Probability','FaceColor','k');
    title([brName, ' Control']);
    ylim([0 1]);
    xlim([0 1]);
    ylabel('Probability');
    xlabel('Synchrony Value')

    subplot(2,2,4);
    histogram(syncVals,histBE,'Normalization','Probability','FaceColor','r');
    title([brName, ' Seizure']);
    ylim([0 1]);
    xlim([0 1]);
    ylabel('Probability');
    xlabel('Synchrony Value')
end