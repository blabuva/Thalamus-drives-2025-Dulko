%%
ccc

%% gather all experimental databases
%folderTimeStamp = '2024_01_23__22_53_33' ;
folderTimeStamp = '2025_05_16__08_17_52';
databaseUberFolder = sprintf('/media/elaX/intanData/ela/individualExperimentDataBase/%s', folderTimeStamp) ;

%% database folders
experimentFolders = dir(sprintf('%s/0*', databaseUberFolder)) ;

%% loop through
allDataBases = [] ;
for iExpt = 1:length(experimentFolders)
    currentFile = dir(sprintf('%s/%s/0*', databaseUberFolder, experimentFolders(iExpt).name)) ;
    load(sprintf('%s/%s/%s', databaseUberFolder, experimentFolders(iExpt).name, currentFile.name)) ;
    allDataBases = [allDataBases; dataBase] ;
end

%% save all data base
save(sprintf('%s/%s_allDataBases', databaseUberFolder, folderTimeStamp), 'allDataBases','-v7.3')

% tic
%load(sprintf('%s/%s_allDataBases.mat', databaseUberFolder, folderTimeStamp)) ;
% toc

