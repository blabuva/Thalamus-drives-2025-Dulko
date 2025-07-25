% masterCodeTonicAndBurst 

% Define the cut off: 
CutOff = 200; % in Hz 

% Prepare output: 
SummaryTonic = {}; 
SummaryBurst = {};

% Folder path
folderPath = '/media/elaX/MyFigures/ISI/';

% Get all .txt files
allFiles = dir(fullfile(folderPath, '*.txt'));

%% Analize Non Seizures 
% Filter for *_nonSeizure.txt using case-insensitive match
nonSeizureFiles = allFiles(~cellfun(@isempty, ...
    regexpi({allFiles.name}, '_nonSeizure\.txt$')));

% Preallocate storage
structureNames = {};
tonicPercent = [];
burstPercent = [];

% Loop through filtered nonSeizure files
for i = 1:length(nonSeizureFiles)
    
    % Extract structure name (before _nonSeizure)
    fileName = nonSeizureFiles(i).name;
    structureName = erase(fileName, '_nonSeizure.txt');
    structureNames{i} = structureName;
    SummaryTonic{i,1} = structureName; 
    SummaryBurst{i,1} = structureName; 

    % Read data
    dataPath = fullfile(folderPath, fileName);
    firingRates = readmatrix(dataPath);

    % Remove invalid entries
    firingRates = firingRates(~isnan(firingRates));

    % Classify
    numTonic = sum(firingRates < CutOff);
    numBurst = sum(firingRates >= CutOff);
    total = numTonic + numBurst;

    % Calculate percentage 
    SummaryTonic{i,2} = (numTonic / total) * 100;
    SummaryBurst{i,2} = (numBurst / total) * 100; 
   
end

%% Analize Seizures  
% Filter for *_Seizure.txt using case-insensitive match
SeizureFiles = allFiles(~cellfun(@isempty, ...
    regexpi({allFiles.name}, '_Seizure\.txt$')));

% Preallocate storage
structureNames = {};

% Loop through filtered nonSeizure files
for i = 1:length(SeizureFiles)
    
    % Extract structure name (before _nonSeizure)
    fileName = SeizureFiles(i).name;
    structureName = erase(fileName, '_Seizure.txt');
    structureNames{i} = structureName;
    SummaryTonic{i,1} = structureName; 
    SummaryBurst{i,1} = structureName; 

    % Read data
    dataPath = fullfile(folderPath, fileName);
    firingRates = readmatrix(dataPath);

    % Remove invalid entries
    firingRates = firingRates(~isnan(firingRates));

    % Classify
    numTonic = sum(firingRates < CutOff);
    numBurst = sum(firingRates >= CutOff);
    total = numTonic + numBurst;

    % Calculate percentage 
    SummaryTonic{i,3} = (numTonic / total) * 100;
    SummaryBurst{i,3} = (numBurst / total) * 100; 
   
end

%% Plot a figure for tonic (do stats) 
plotTonicFiring(SummaryTonic);   
plotBurstFiring(SummaryBurst);  
