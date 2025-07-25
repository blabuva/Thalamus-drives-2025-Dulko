%%
mouseID = 32; 
ch_oneInd = 115;
topDir = 'S:\intanData\ela\markTemp\';
ESAfp = sprintf('C:\\Ela_ESA\\00%d\\ch%d.bin',mouseID,ch_oneInd);

% md = memmapfile();
fid = fopen(ESAfp);
ESA = fread(fid,'double');
load(sprintf('C:\\Ela_ESA\\00%d\\timevec.mat',mouseID),'timevec');

%%
load(sprintf('%s00%d\\rawData\\downsampled.mat',topDir,mouseID),'ds');
dstv = (0:size(ds.data,2)-1)/ds.fs; % time vector for 

%%
figure;
sax(1)= subplot(311);
plot(timevec,zscore(ESA),'k');
title('Local ESA')
sax(2) = subplot(312);
plot(dstv,ds.data(ch_oneInd,:),'k');
title('Local Raw LFP')
% sax(3) = subplot(313);
% plot(double(eeg.time-1)/30000,eeg.data);
% title('EEG from cortex surface')

linkaxes(sax,'x');