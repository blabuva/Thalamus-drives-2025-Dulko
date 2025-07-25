[averages] = ExtractLocalLFP(MouseDatabase,howFarBack,howFarInto); % get local LFPs 
% parent function: Phase_ela.m 

% settings for the spectrogram
winLen = 0.3; % FFT window length in seconds
overLap = 0.275; % window overlap (seconds)
frequency = 1000; % sampling in Hz 
step = winLen -overLap; 
frange = [1 100]; % frequency range used for spectrogram (Hz)

%% iSeizure = 2 
iSeizure = 2; 
figure; 
Fs = 1000; 
subplot(6,1,1); % cortical LFP 
    plot(EEGs{iSeizure,1}); xlim([0, 1300]); 
subplot(6,1,2); % wavelet analysis for cortical LFP  
    [cft,frq] = cwt(EEGs{iSeizure,1},Fs); % obtain cont wavelet transpform 
    tms = EEGs{iSeizure,2}; % time vector for a given seizure 
    surface(tms,frq,(abs(cft))); 
    set(gca, 'YScale', 'log');
    axis tight; shading("flat"); ylim([0,100]);
    ylabel('Frequency (log)'); 
   % add lines at 5 and 11 Hz to indicate the range of interest for us: 
   yline(5, 'w--', 'LineWidth', 1.5); 
   yline(11, 'w--', 'LineWidth', 1.5);
subplot(6,1,3); % spectrogram for cortical LFP
    Time = EEGs(iSeizure,2);
    EEG = EEGs(iSeizure,1); 
    LFP = [Time{1,1},EEG{1,1}]; % LFP is an Nx2 matrix. Column 1 is time, col2 is voltage data
    [spectrogram,t,f] = MTSpectrogram(LFP,...
    'window',winLen,'overlap',overLap, ...
    'range',frange); % computes the spectrogram
    %ax = axes('Position',[0.1, 0.1, 0.8, 0.8]); 
    imagesc(t,f,spectrogram); % power scales logarithmically with frequency, so take the log of the specgram
    colormap(jet); 
    set(gca,'YDir','normal');
    ylabel('Frequency [Hz]'); 
    xlabel('bin');
    ylim([0, 30]); 
    yline(5, 'w--', 'LineWidth', 1.5); 
    yline(11, 'w--', 'LineWidth', 1.5); 
subplot(6,1,4); % local LFP 
    plot(EEGs(iSeizure,:),'-r'); 
    %xlim([0,1300]); 
    axis tight; 
    ylim([-2000 1000]); 
subplot(6,1,5); % Raster for firing   
    leftEdge = tms(1,1); 
    rightEdge = tms(end); 
    allSpikes = []; 
    for iNeuron= 1:size(MouseDatabase.SingleUnitsAll{15,1}.all.CurrentSWD,1) 
        Spikes = MouseDatabase.SingleUnitsAll{15,1}.all.CurrentSWD(iNeuron,:); 
        spikes = Spikes.SpikeTimesSec{1,1}; 
        filteredSpikes = spikes(spikes >= leftEdge & spikes <= rightEdge);
        allSpikes = [allSpikes;filteredSpikes]; 
        APs = size(filteredSpikes,1); 
        for iAP = 1:APs
            line([filteredSpikes(iAP) filteredSpikes(iAP)], [iNeuron-0.5 iNeuron+0.5], 'Color', 'b')
        end
    end
    xlim([leftEdge,rightEdge]); ylabel('Neuron number'); 
    ylim([0,30])
subplot(6,1,6); % histogram 
    counts =  histcounts(allSpikes,leftEdge:2*binSize:rightEdge); % 10 ms as of now 
    bar(counts); ylabel('Sum of APs');
    
svgFileName = fullfile(figurePath, ['seizure2_02' '.svg']);        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

%% iSeizure = 8 
iSeizure = 8; 
figure; 
title('Seizure 8'); 
Fs = 1000; 
subplot(5,1,1); % cortical LFP 
    plot(EEGs{iSeizure,1}); xlim([0, 1300]); 
subplot(5,1,2); % wavelet analysis 
    [cft,frq] = cwt(EEGs{iSeizure,1},Fs); % obtain cont wavelet transpform 
    tms = EEGs{iSeizure,2}; % time vector for a given seizure 
    surface(tms,frq,(abs(cft))); 
    set(gca, 'YScale', 'log');
    axis tight; shading("flat"); 
    ylabel('Frequency (log)'); clim([0 3]);
    ylim([0, 100]); % 0 to 100 Hz;
   % add lines at 5 and 8 Hz to indicate the range of interest for us: 
   yline(5, 'w--', 'LineWidth', 1.5); 
   yline(8, 'w--', 'LineWidth', 1.5);

subplot(5,1,3); % local LFP 
    plot(averages(iSeizure,:),'-r'); 
    %xlim([0,1300]); 
    axis tight; 
    ylim([-2000 1000]); 
subplot(5,1,4); % Raster for firing   
    leftEdge = tms(1,1); 
    rightEdge = tms(end); 
    allSpikes = []; 
    for iNeuron= 1:size(MouseDatabase.SingleUnitsAll{84,1}.all.CurrentSWD,1) 
        Spikes = MouseDatabase.SingleUnitsAll{84,1}.all.CurrentSWD(iNeuron,:); 
        spikes = Spikes.SpikeTimesSec{1,1}; 
        filteredSpikes = spikes(spikes >= leftEdge & spikes <= rightEdge);
        allSpikes = [allSpikes;filteredSpikes]; 
        APs = size(filteredSpikes,1); 
        for iAP = 1:APs
            line([filteredSpikes(iAP) filteredSpikes(iAP)], [iNeuron-0.5 iNeuron+0.5], 'Color', 'b')
        end
    end
    xlim([leftEdge,rightEdge]); 
    ylabel('Neuron number');  
subplot(5,1,5); % histogram 
    counts =  histcounts(allSpikes,leftEdge:2*binSize:rightEdge); % 10 ms as of now 
    bar(counts); ylabel('Sum of APs');
 
svgFileName = fullfile(figurePath, ['seizure8_02' '.svg']);        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
  
    
 %% iSeizure = 12 
iSeizure = 12; 
figure; 
title('Seizure 12'); 
Fs = 1000; 
subplot(5,1,1); % cortical LFP 
    plot(EEGs{iSeizure,1}); xlim([0, 1300]); 
subplot(5,1,2); % wavelet analysis 
    [cft,frq] = cwt(EEGs{iSeizure,1},Fs); % obtain cont wavelet transpform 
    tms = EEGs{iSeizure,2}; % time vector for a given seizure 
    surface(tms,frq,(abs(cft))); 
    set(gca, 'YScale', 'log');
    axis tight; shading("flat"); 
    ylabel('Frequency (log)'); clim([0 3]);
    ylim([0, 100]); % 0 to 100 Hz;
   % add lines at 5 and 8 Hz to indicate the range of interest for us: 
   yline(5, 'w--', 'LineWidth', 1.5); 
   yline(8, 'w--', 'LineWidth', 1.5);

subplot(5,1,3); % local LFP 
    plot(averages(iSeizure,:),'-r'); 
    %xlim([0,1300]); 
    axis tight; 
    ylim([-2000 1000]); 
subplot(5,1,4); % Raster for firing   
    leftEdge = tms(1,1); 
    rightEdge = tms(end); 
    allSpikes = []; 
    for iNeuron= 1:size(MouseDatabase.SingleUnitsAll{88,1}.all.CurrentSWD,1) 
        Spikes = MouseDatabase.SingleUnitsAll{88,1}.all.CurrentSWD(iNeuron,:); 
        spikes = Spikes.SpikeTimesSec{1,1}; 
        filteredSpikes = spikes(spikes >= leftEdge & spikes <= rightEdge);
        allSpikes = [allSpikes;filteredSpikes]; 
        APs = size(filteredSpikes,1); 
        for iAP = 1:APs
            line([filteredSpikes(iAP) filteredSpikes(iAP)], [iNeuron-0.5 iNeuron+0.5], 'Color', 'b')
        end
    end
    xlim([leftEdge,rightEdge]); 
    ylabel('Neuron number');  
subplot(5,1,5); % histogram 
    counts =  histcounts(allSpikes,leftEdge:2*binSize:rightEdge); % 10 ms as of now 
    bar(counts); ylabel('Sum of APs');

svgFileName = fullfile(figurePath, ['seizure12_02' '.svg']);        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
  