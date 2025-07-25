% This code grabs allDataBase (multiple mice combined) and calculates the
% mean correlation between nuclei DURING seizures. The output is
% CorrelationInfo structure. 
ccc; 

%% Important parameters: 
binSize = 0.05; % 50 ms for now 
%% Load the most recent DataBase 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase/2025_05_16__08_17_52';
load('2025_05_16__08_17_52_allDataBases.mat'); % Load the database 
logicalIndexStrain = strcmp(allDataBases.Strain, 'Gria4');% keep one mouse only 
allDataBases = allDataBases(logicalIndexStrain, :); % now allDataBases includes one mouse only

%% Create the output folder
outputFolderName = sprintf('cross_nuclei_correlations%s', datestr(now, 'yyyy_mm_dd'));
path = '/media/elaX/MyFigures/Cross-nucleic-synchrony/'; 
outputFolderPath = fullfile(path, outputFolderName); % Create path relative to current folder
if ~exist(outputFolderPath, 'dir')
    mkdir(outputFolderPath); % Create the folder if it doesn't exist
end
%% Lump structures based on Mark's code;
[whatStructures,allDataBases] = LumpStructuresForSynchronyCode(allDataBases); 
whatMice = unique(allDataBases.MouseID); % what mice are here 
numMice = length(whatMice); % how many mice are here

%% Loop through mice (recordings) 
combinations = nchoosek(whatStructures,2); % Generate unique combinations of two structures
reverseCombinations = flip(combinations, 2); % Flip the order of each pair
allCombinations = [combinations; reverseCombinations]; % Combine original and reversed pairs
combinations = allCombinations; 

CorrelationsDuringSWSs = {}; % initiate struct for storing SWSs corrs 
CorrelationsDuringNonSWSs = {}; % initiate struct for storing nonSWSs corrs
Differences = {}; % initiate struct for storing differences 

for iMouse = 1:numMice
    display(iMouse)
    logicalIndex = strcmp(allDataBases.MouseID, whatMice{iMouse}); % keep one mouse 
    MouseDatabase = allDataBases(logicalIndex, :); % logical index to one mouse 
    MouseDatabase = removeDontAnalyzeStructure(MouseDatabase); % remove DontAnalyze structures
    MouseDatabase = removeRowsWithNoSingleUnits(MouseDatabase);  % NOW remove rows (seizures where there is no single units)
    % if there is no rows left let me know and don't analyze 

       if size(MouseDatabase,1) == 0
           display('no data to analyze due to NaNs or NO single units')
           continue 
       end 

    realID = MouseDatabase.MouseID{1,1}; % extract real mouse ID 
    % analyze this REC only if more than 1 brain structure 
    structureNames = cellfun(@(x) x{1}, MouseDatabase.LumpedStructure, 'UniformOutput', false);
    % what are the unique structures 
    UniqueStructures = unique(structureNames); % how many unique structures are in this one seizure
    numUniqueStr = length(UniqueStructures);

    %numUniqueStr = size(unique(structureNames),1); 
    if numUniqueStr <2 % skip this rec if there is less than 2 brain structures  
        continue 
    end
    
    % if iMouse == 13 % just for now. This mouse doens't have many single units 
    %     continue 
    % end

    whatSeizures = unique(MouseDatabase.SeizureNumber);
    numSeizures = length(whatSeizures); 
    if numSeizures < 3  % for now rec-s with less than 3 seizures will not be analyzed 
        continue 
    end 
    % Calculate correlation coefficient for each seizure separately 
    [CorrelationsAllSeizures, CorrelationsAllNonSeizures, Labels] = calculateCorrelationCoeffForNeuronsEachSeizure(numSeizures,MouseDatabase,whatSeizures,binSize);
    
    % Compute the mean correlation for each pair 
    % ---- SEIZURES 
    [MeanCorrelations] = computeMeanCorrelation(CorrelationsAllSeizures, Labels,numSeizures,numUniqueStr, UniqueStructures); 
    % ---- NON SEIZURES 
    [MeanCorrelationsNonSWSs] = computeMeanCorrelation(CorrelationsAllNonSeizures, Labels,numSeizures,numUniqueStr, UniqueStructures); 
    % Plot  
    % - option 1:   visualize mean correlations for NonSWSs and SWSs (no difference) 
    % plotLineGraphAndHeatmapsForNonSWSsandSWSSeizures(MeanCorrelations,MeanCorrelationsNonSWSs,numSeizures); 
    % - option 2:   visualize difference as well 
    [allValuesDifference,MeanDifference] = visualizeCorrDifference(numSeizures,MeanCorrelations,MeanCorrelationsNonSWSs,numUniqueStr,UniqueStructures); 
        % save the figure 
        saveFilePath = fullfile(outputFolderPath, sprintf('%s.png', realID));
        saveas(gcf, saveFilePath); % Save as PNG
        close(gcf); % Close the figure to avoid clutter
     
    % store mean correlations in a big structure 
        % for Seizures: 
        [CorrelationsDuringSWSs] = storeMeanCorrelations(MeanCorrelations, combinations, CorrelationsDuringSWSs, iMouse); 
        % for Non Seizures: 
        [CorrelationsDuringNonSWSs] = storeMeanCorrelationsNonSWSs(MeanCorrelationsNonSWSs, combinations, CorrelationsDuringNonSWSs, iMouse); 
        % for Differences:
        [Differences] = storeDifference(MeanDifference, combinations, Differences, iMouse); 

end 
%%
VisualizeAllCorrelationsAsHeatmap(CorrelationsDuringSWSs,CorrelationsDuringNonSWSs,Differences,combinations) ; 
   
   