function computeESA(pathToData,outpath,numChans)

% Makes peri-event time histograms for ESA (entire spiking activity) signals
funClock = tic;

%% -- Point to proper directories and load relevant data -- %%
dataDir = sprintf('%s\\rawData',pathToData);
filename = fullfile(dataDir,'combined.bin');
% numChans = 256; % number of channels on the probe
md = psr_mapBinData(filename,numChans);

%% --- Set user-controllable parameters --- %%
pSZ = 5; % peri-seizure time window (seconds * sampling rate)
pTR = .25; % peri-trough time window (seconds * sampling rate)
ds.scaleFactor = 0.195; % scaling factor from Intan to convert to uV (almost always 0.195)
ds.fs = 30000; % original sampling frequency (usually 30kHz)

%% --- Prepare data for main processing loop --- %%
% -- Compute peri-trough time windows/vectors -- %
% -- DOWNSAMPLING TO SAVE ON MEMORY -- %%
dsFactor = 10; % downsample factor
tridx = pTR * (ds.fs*dsFactor);            % peri-trough time window (# samples)
tv = (-tridx:tridx) /ds.fs;     % time vector for peri-trough data

%% --- Calculate ESA with minute-by-minute loop --- %%
numSamps = size(md.Data.ch,2);
swin = ds.fs * 60; % 1 minute's worth of samples
nw = ceil(numSamps/swin);
dsIDXvec = 1:dsFactor:numSamps; % downsampled indexing vector
timevec = (dsIDXvec-1)/ds.fs;
% mkdir(fullfile(outpath,'ESA'));
for fi = 1:numChans
    cfn = sprintf('%s\\ch%d.bin',outpath,fi);
    FID(fi) = fopen(cfn,'w');         % create 'files to store ESA data
end

% --- SOMETIMES THIS FUNCTION FAILS IF THE LAST RHD FILE IS TOO SMALL TO FILTER --- %
nw = nw-1; % so we skip the last file

% -- Loop through minute-by-minute data -- %
for wi = 1:nw
    minClock = tic; % seizure loop clock start
    fprintf('Loop %d out of %d\n',wi,nw) % update user in command window

    % -- Grab fully sampled data minute-by-minute -- %
    if wi == nw
        cIDX = (wi-1)*swin+1:numSamps;  % IF last window go to last index
    else
        cIDX = (wi-1)*swin+1:wi*swin;   % ELSE just grab up to next window
    end
    ds.data = md.Data.ch(:,cIDX);  % retrieve data from memory-mapped variable
    cdsIDX = ismember(cIDX,dsIDXvec); % current sampled indexing vector

    % -- Compute the entire spiking activity -- %
    [ESA] = psr_calculateESA(ds, 1:numChans, 0); % compute ESA

    % -- Perform downsampling and writing to binary files -- %%
    writeClock = tic;
    for fi = 1:numChans
        fwrite(FID(fi),ESA(cdsIDX,fi),"double");
    end
    fprintf('Writing window %d took %.2f seconds\n',wi,toc(writeClock)) % update user in command window
    fprintf('Loop %d took %.2f seconds\n',wi,toc(minClock)) % update user in command window

end % seizure LOOP
tvfn = sprintf('%s\\timevec.mat',outpath);
save(tvfn,"timevec",'-v7.3');
fclose('all');
fprintf('Function took %.2f minutes\n',toc(funClock)/60) % update user in command window

end