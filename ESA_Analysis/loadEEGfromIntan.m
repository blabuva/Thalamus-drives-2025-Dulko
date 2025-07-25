%%

dirpath = 'S:\intanData\ela\markTemp\0032\rawData';
dd = dir(dirpath);
fnames = {dd.name};
fnames(~contains(fnames,'.rhd')) = [];

%%
eeg.time = [];
eeg.data = [];
for fi = 1:numel(fnames)
    filename = fullfile(dirpath,fnames{fi});
    ID = sk_readRHD_analogOnly(filename);
    eeg.data = [eeg.data,ID.board_adc_data(1,:)];
    eeg.time = [eeg.time,ID.t_amplifier];
end