
%%
ccc

%% set path to files
dataPath = '/media/probeX/intanData/ela/markTemp' ;

%% get intan file
intanPath = uigetdir(dataPath) ;
intanFilesPath = sprintf('%s/rawData/', intanPath) ;
rhdFiles = dir(sprintf('%s*.rhd', intanFilesPath)) ;

%% create empty variables for concatenation
eegAll = [] ;
timeC = [] ;

%% extract EEG from rhd files
for iFile = 1:size(rhdFiles,1)
    allData = read_Intan_RHD2000_file_mpb(intanFilesPath, rhdFiles(iFile).name) ;
    timeC = [timeC; allData.t_amplifier'] ;
    eegAll = [eegAll; allData.board_adc_data(1,:)'] ;
    clear allData 
end

%% downsample EEG
SI = timeC(2) - timeC(1) ;
targetSI = 1/400 ;
DSamount = round(targetSI/SI) ;
timeCDS = downsample(timeC, DSamount)*1000 ;
eegDS = downsample(eegAll, DSamount) ;

%% combine into 1 variable
EEG = [timeCDS, eegDS] ;

%% save EEG as text file
slashesLocs = strfind(intanFilesPath, '/') ;
mouseID = intanFilesPath(slashesLocs(end-2)+1: slashesLocs(end-1)-1) ;
textFilePath = sprintf('%s%s_EEG.txt', intanFilesPath, mouseID) ;
writematrix(EEG, textFilePath) ;