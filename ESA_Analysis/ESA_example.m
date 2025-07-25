%%
locDir = 'C:\Ela_ESA\';
mouseID = 32;
topDir = 'S:\intanData\ela\markTemp\'; 
dirpath = sprintf('%s00%d\\rawData',topDir,mouseID);
dd = dir(dirpath);
fnames = {dd.name};
fnames(~contains(fnames,'.rhd')) = [];

%%
ch = 115;
IDtime = [];
eegData = [];
chData = [];
for fi = 1:numel(fnames)
    filename = fullfile(dirpath,fnames{fi});
    ID = sk_readRHD(filename);
    eegData = [eegData,ID.board_adc_data(1,:)];
    IDtime = [IDtime,ID.t_amplifier];
    chData = [chData,ID.amplifier_data(ch,:)];
end
IDtime = (double(IDtime)-1)./ID.sample_rate;

%%
rawData = double(chData)'.*ID.scaleFactor;

[~, b] = psr_makeFIRfilter_300to12500Hz;    % return filter coefficients for 0.3 to 12.5kHz equiripple FIR-filter (assumes 30kHz Fs)
BPdata = filtfilt(b, 1, rawData);   % band-pass-filtered data
BPD_rect = abs(BPdata);                     % rectify the band-pass-filtered data

% -- Prepare Gaussian Kernel for Convolution -- %
sigma = 0.005;                                                  % sigma value for Gaussian kernel convolution (in seconds)
num_points = 201*30;                                            % number of samples over which Gaussian will be convolved (201 is 201ms if sampling frequency is 1kHz)
sigmaSamp = sigma*ID.sample_rate;                               % desired sigma x sampling rate
x = linspace(-(num_points-1)/2, (num_points-1)/2, num_points);  % generate the range of x values
gaussKern = exp(-0.5 * (x / sigmaSamp).^2);                     % compute the Gaussian kernel
gaussKern = gaussKern / sum(gaussKern);                         % normalize the kernel

% % -- Apply Convolution -- %
ESA = conv(BPD_rect,gaussKern,'same');

%% === Plot it all === %%
% figure
% plot(IDtime,eegData);
% xl = [250 300]
ds = 30; % downsample factor for plotting
bf = figure;
sax(1) = subplot(511);
plot(IDtime(1:ds:end),eegData(1:ds:end));

sax(2) = subplot(512);
plot(IDtime(1:ds:end),rawData(1:ds:end));

sax(5) = subplot(513);
plot(IDtime(1:ds:end),BPdata(1:ds:end));

sax(3) = subplot(514);
plot(IDtime(1:ds:end),BPD_rect(1:ds:end));

sax(4) = subplot(515);
plot(IDtime(1:ds:end),ESA(1:ds:end));

linkaxes(sax,'x');