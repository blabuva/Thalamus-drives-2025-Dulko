%% Calculates the PETH and autocorrelation during seizures for ESA
function [AC, OI, swdpeth, trpeth,PA] = ESA_PETHandXCorr(mouseID,chanList)

%% === Set up files etc === %
% --- User Inputs --- %
topDir = 'S:\intanData\ela\markTemp\';
locDir = 'C:\Ela_ESA\';
lagSec = 1; % maximum lag for autocorr (seconds)
ptwin = [.05 .2]; % peak & trough window (in seconds)
swdPD = 10; % peri-SWD duration [seconds] (i.e. how long to look around SWD starts and ends)
npPD = .25; % peri-negative peak (trough) duration [seconds] (i.e. how long to took around SWD troughs (negative peaks))


% -- Retrieve the correct 'detectedSeizures.mat' file (i.e. not those detected from S1) -- %
dirCon = dir(sprintf('%s00%d\\detectedSeizures',topDir,mouseID));
kpLog = contains({dirCon.name},'detectedSeizures') & ~contains({dirCon.name},'S1'); % find files that contain "detectedSeizures" in name and don't contain "S1"
szFile = sprintf('%s00%d\\detectedSeizures\\%s',topDir,mouseID,dirCon(kpLog).name);
load(szFile,'curated_seizures');

%% === Load data and initialize stuff === %
load(sprintf('%s00%d\\timevec.mat',locDir,mouseID),'timevec');
Fs = 1/(diff(timevec(1:2)));

% --- Convert windows and lags from seconds to # samples units --- %
lagFS = lagSec * Fs;
swdFS = swdPD*Fs;
npFS = npPD*Fs;
swdpeth.time = (-swdFS:swdFS)/Fs;
trpeth.time = (-npFS:npFS)/Fs;
% -- Remove 'type 3' seizures -- %
rmLog = strcmp({curated_seizures.type},'3');    % find type 3s
curated_seizures(rmLog) = [];                   % remove type 3s
sz = curated_seizures; % curated_seizures is too long a name
numSZ = numel(curated_seizures);% number of type 1 and 2 seizures

ictLog = false(size(timevec));
trIDX = []; % intialize trough index vector for storing indices to SWD troughs
for szi = 1:numSZ
    ctrIDX = sz(szi).trTimeInds;
    % if szi == 6 % useful for troubleshooting
    %     disp(szi)
    % end
    seSWD(szi,:) = sz(szi).time(ctrIDX([1,end]))'; % starts and ends of SWD (in seconds)
    swdIDX(szi,1) = find(timevec>=seSWD(szi,1),1,'first'); % SWD START index
    swdIDX(szi,2) = find(timevec<=seSWD(szi,2),1,'last'); % SWD END index
    ictLog(swdIDX(szi,1):swdIDX(szi,2)) = true; % settings the ictal log to true where SWDs happen
    for tri = 1:numel(ctrIDX)
        ctrTime = sz(szi).time(ctrIDX(tri)); % return current trough time (in seconds)
        [~,cidx] = min(abs(ctrTime-timevec));
        trIDX = [trIDX; cidx];
    end
end

% --- Ignoring SWDs and troughs if too close to start or end of recording --- %
checkFlag = 1;
while checkFlag
    if (swdIDX(1,1) -swdFS) < 0
        swdIDX(1,:) = []; % remove if the SWD start is too close to time 0
    elseif (swdIDX(end,2)+ swdFS) > numel(timevec)
        swdIDX(end,:) = [];
    elseif (trIDX(1)-npFS) < 0
        trIDX(1) = [];
    elseif (trIDX(end)+npFS) > numel(timevec)
        trIDX(end) = [];
    end
    checkFlag = 0;
end

numSZ = size(swdIDX,1); % updating # of seizures after removing problematic ones (those with edge conflicts)


%% === Main Loop === %
% --- I should probably initialize data storage stuff here --- %
for chi = 1:numel(chanList)
    cch = chanList(chi);
    chanClock = tic;
    fprintf('Channel %d processing...\n',cch);
    ESAfp = sprintf('%s00%d\\ch%d.bin',locDir,mouseID,cch);
    fid = fopen(ESAfp);
    ESA = fread(fid,'double');
    szESA = psr_ESAPhase(ESA,timevec,sz);
    PA(chi) = psr_ESA_PAcoupling(szESA,0); % no plotting

    ESA=zscore(ESA); % z-scoring the ESA

    [AC.ic(chi,:)] = xcorr(ESA(ictLog),lagFS,'normalized');
    [AC.non(chi,:), LAGS] = xcorr(ESA(~ictLog),lagFS,'normalized');
    OI.ic(chi,1) = calcOI(AC.ic(chi,:),LAGS/Fs,ptwin);
    OI.nonic(chi,1) = calcOI(AC.non(chi,:),LAGS/Fs,ptwin);

    for tri = 1:numel(trIDX) % loop through all the troughs
        cptidx = (trIDX(tri)-npFS):(trIDX(tri)+npFS); % peri-trough indices for current loop
        trpeth.data(chi,tri,:) = ESA(cptidx);
    end

    for szi = 1:numSZ
        for sii = 1:2 % starts and ends
            cpidx = [swdIDX(szi, sii) - swdFS,...
                swdIDX(szi,sii) + swdFS]; % indices to PETH indices
            if sii == 1
                swdpeth.starts(chi,szi,:) = ESA(cpidx(1):cpidx(2));
            elseif sii == 2
                swdpeth.ends(chi,szi,:) = ESA(cpidx(1):cpidx(2));
            end
        end

    end

    fclose(fid);
    fprintf('took %.2f seconds\n',toc(chanClock));

end
AC.lags = LAGS/Fs;

end % function end