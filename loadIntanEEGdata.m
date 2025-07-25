function EEG = loadIntanEEGdata(filename, targetFS)

eegChannel = 1 ;
EEG = intanLoadEEG(filename,eegChannel,targetFS);   % loads .rhd files


