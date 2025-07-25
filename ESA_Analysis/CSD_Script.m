%% Set up channel information
% chI = [65,128,66,127,67,128,68,125,69,124,70,123,71,...
%     122,72,121,73,120,74,119,75]'; % depth-ordered channel indices - Shank 1 from left

% chI = [64,1,63,2,62,3,61,4,60,5,59,6,...
%     58,7,57,8,56,9,55,10,54]'; % depth-ordered channel indices - Shank 2 from left

% chI = [256,193,255,194,254,195,253,...
% 196,252,197,251,198,250,199,249,200,248,201,247,202,246]'; % depth-ordered channel indices - Shank 3 from left

chI = [129,192,130,191,131,190,132,189,133,...
188,134,187,135,186,136,185,137,184,138,183,139]'; % depth-ordered channel indices - Shank 4 from left

chDepths = [0:50:1000]'; % relative channel depths (microns)
ch1Depth = 25; % depth of most superficial channel (microns)
chDepths = chDepths+ch1Depth;

%% Load in relevant data
fname = '\\172.28.76.244\probeX\intanData\ela\markTemp\0043\rawData\combined.bin';
SWDfn = '\\172.28.76.244\probeX\intanData\ela\markTemp\0043\detectedSeizures\0043_detectedSeizures002.mat';
% fname = '\\172.28.76.244\probeX\intanData\ela\markTemp\0066\rawData\combined.bin';
% SWDfn = '\\172.28.76.244\probeX\intanData\ela\markTemp\0066\detectedSeizures\0066_detectedSeizures002.mat';

% -- Memory map the PSR data and set some window parameters -- %
numChans = 256;
% fname = 'Y:\robbieX\PSR_Data\PSR_15\PSR_15_Rec2_231010_171850\combined.bin';
% fname = '\\172.28.76.244\probeX\intanData\ela\markTemp\0043\rawData\combined.bin';
md = psr_mapBinData(fname,numChans);
FS = 30000; % sampling frequency
numSamps = size(md.Data.ch,2);
timeVec = (0:numSamps-1)./FS;
winSize = 0.1;               % in seconds
hwins = round(winSize*FS/2); % half window size (in # samples)
TV = (-hwins:hwins) ./ FS;   % convert the window to time units (
TVms = TV*1000;              % convert that to milliseconds 

% -- Load in the SWD data -- %
% SWDfn = 'Y:\robbieX\PSR_Data\PSR_15\PSR_15_Rec2_231010_171850\analogData_seizures_curated_20231108_16_00_26.mat';
% SWDfn = '\\172.28.76.244\probeX\intanData\ela\markTemp\0043\detectedSeizures\0043_detectedSeizures002.mat';
load(SWDfn,'curated_seizures');
seizures = curated_seizures;
rmLog = strcmp({seizures.type},'3') | strcmp({seizures.type},'2');
SWD = seizures(~rmLog);

%% Low pass filter the traces
ufc = 50; % Upper cutoff frequency in Hz
dsFactor = 100; % down sampling factor
fs = FS/dsFactor;
[b, a] = butter(4, ufc / (fs / 2), 'low'); % 4th order low pass Butterworth filter
scaleFactor = 0.195 * 1e-6;   % factor used to convert amplifier_data unit to VOLTS (0.195 from Intan)

%% Calculate CSD for each SWD cycle and store in structure 'CSD'
for szi = 1:numel(SWD)
    fprintf('Calculating CSDs for SWD #%d...\n',szi);
    % -- Find time in LFP data closest to SW trough time -- %
    trTimes = SWD(szi).time(SWD(szi).trTimeInds); % get trough times from current seizure
    tempCSD = []; % intialize CSD matrix
    tempTime = []; % intialize time matrix
    for tri = 1:numel(trTimes)
        [~, minI] = min(abs(timeVec-trTimes(tri)));      % find closest point in recording to current trough
        startI = minI-hwins;                             % PROBABLY NEED EDGE CONDITIONS FOR THIS!!!!
        endI = minI+hwins;                               % end of cycle index
        dsIndex = startI:dsFactor:endI;                  % create downsampled indexing vector
        cycleTime = timeVec(dsIndex);                    % get the time vector from current cycle
        winData = double(md.Data.ch(chI,dsIndex));       % get LFPs during seizure
        winData = winData.*scaleFactor;                  % convert data to VOLTS
        winMed = median(winData,2);                      % get the median value for each channel
        medMat = repmat(winMed,1,size(winData,2));       % make a matrix with medians for each trace
        winNorm = winData-medMat;                        % median subtraction
        filtTraces = filtfilt(b,a,winNorm')';            % filter normalized traces
        smoothTraces  = smoothdata(filtTraces,1, ...
            "movmean",3);                                % smooth traces vertically 
        [CSDmat, zs] = psr_calcCSD(smoothTraces, ...
            chDepths);                                   % calculate CSD
        tempCSD(:,:,tri) = CSDmat;
        tempTime(tri,:) = cycleTime;
    end
    CSD(szi).mat = tempCSD; %
    CSD(szi).time = tempTime; % 
    if szi == 3
        pause(1)
    end
end

%% Plotting
spacingFactor = 5000; % spacing between plots
modVec = (0:length(chI)-1).*spacingFactor;
modMat = repmat(modVec',1,size(filtTraces,2));
% figure; 
% plot(szTime,modMat-filtTraces,'k-');
% plot(szTime,modMat-smoothTraces,'k');
% set(gca,'YDir','reverse')
[~, startI] = min(abs(timeVec-SWD(szi).time(1)));
[~, endI] = min(abs(timeVec-SWD(szi).time(end)));
dsIndex = startI:dsFactor:endI;
szTime = timeVec(dsIndex);
szData = double(md.Data.ch(chI,dsIndex)); % get LFPs during seizure
szData = szData.*scaleFactor; % convert data to VOLTS
szdMed = median(szData,2); % get the median value for each channel
medMat = repmat(szdMed,1,size(szData,2)); % make a matrix with medians for each trace
szdNorm = szData-medMat;   % median subtraction
filtTraces = filtfilt(b,a,szdNorm')';
[CSDmat, zs] = psr_calcCSD(filtTraces,chDepths);

smoothTraces = smoothdata(filtTraces,1,'movmean',3);

% -- Transform the traces so the fit on the heatmap -- %
spacingFactor = 1; % spacing between plots
modVec = (0:length(chI)-1).*spacingFactor;
modMat = repmat(modVec',1,size(filtTraces,2));
figure;
imagesc(szTime,modVec,smoothTraces);
% clim([-5000 5000]);
colormap(redblue);
hold on
plot(szTime,modMat-(filtTraces*2500), ...
    'k-','LineWidth',1.5);
% plot(szTime,modMat-(smoothTraces*1), ...
%     'k-','LineWidth',1.5);
hold off

set(gcf().Children,'FontSize',18)
xlabel('Time (seconds)')
