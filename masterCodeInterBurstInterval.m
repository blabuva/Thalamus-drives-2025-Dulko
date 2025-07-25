% master code for calculating inter-burst interval 

%% load the database 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase/2025_05_16__08_17_52';
load('2025_05_16__08_17_52_allDataBases.mat'); % Load the database
strainName = 'Gria4'; % choose the mouse 

%% Define where the figures will be saved  
    PathToFigures = '/media/elaX/MyFigures/ISI/';  % general path for both stg and gria4 mice
    
    % Generate folder name with the strain and timestamp
    timestamp = datestr(now, 'yyyymmdd_HHMMSS'); % e.g., '20241118_134530'
    folderName = fullfile(PathToFigures, [strainName, '_', timestamp]);
    
    % Create the folder if it doesn't exist
    if ~exist(folderName, 'dir')
        mkdir(folderName);
    end

%% Index to one mouse strain in the database 
logicalIndexStrain = strcmp(allDataBases.Strain, strainName);% keep one strain only 
[originalDB] = BigLag_241118(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
allDataBases=originalDB; % change the name for simplicity 
% Inspect the database 
[whatStructures,PreSeizure,MinimumSeizureDuration, ... ,
binSize,leftLimit,rightLimit,numBins,numBinsA,mouseIDs,mouseColors,MinPreSeizureDuration] = setImportantSpecs241118(allDataBases);

for iStructure =  [8,19,21,25,26] 
    % Extract and store brain structure's name  
    display(iStructure); targetStructure = whatStructures{iStructure};
   
    % Index to one brain structure 
    [StructureDatabase] = indexToOneBrainStructure241118(allDataBases,targetStructure);

    % Calc inter-burst duration, plot a histogram 
    detectBursts_ed(StructureDatabase, targetStructure,folderName); 
       
   
end

