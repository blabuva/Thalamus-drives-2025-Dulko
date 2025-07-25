%% this is the master function to run other functions for Zscore calc 
ccc; 

%% load the database 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase/2025_05_16__08_17_52';
load('2025_05_16__08_17_52_allDataBases.mat'); % Load the database
strainName = 'Stargazer'; % choose the mouse 

%% Specify where you want the figures to be saved 
    PathToFigures = '/media/elaX/MyFigures/FiringRateZscored/';  % general path for both stg and gria4 mice
    
    % Generate folder name with the strain and timestamp
    timestamp = datestr(now, 'yyyymmdd_HHMMSS'); % e.g., '20241118_134530'
    folderName = fullfile(PathToFigures, [strainName, '_', timestamp]);
    
    % Create the folder if it doesn't exist
    if ~exist(folderName, 'dir')
        mkdir(folderName);
    end
%% Index to one mouse in the database 
logicalIndexStrain = strcmp(allDataBases.Strain, strainName);% keep one strain only 
[originalDB] = BigLag_241118(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
allDataBases=originalDB; % change the name for simplicity 
% Inspect the database 
[whatStructures,PreSeizure,MinimumSeizureDuration, ... ,
binSize,leftLimit,rightLimit,numBins,numBinsA,mouseIDs,mouseColors,MinPreSeizureDuration] = setImportantSpecs241118(allDataBases);
  
%% Collect BASELINE and SEIZURE firing rates for each neuron within a structure  
firingDuringNonSeizures = cell(size(whatStructures,1),1); %  stores all FF during NON seizures for each neuron in specific structure
%meanEEGNonSeizures = cell(length(whatStructures),1); % for storing EEG 
firingDuringSeizures = cell(size(whatStructures,1),1); %  stores mean FF during seizures for each neuron in specific structure

% make a table for % of valid trials 
ValidTrials = whatStructures; 

% IMPORTANT. Don't analyze brain structures <10 neurons.
% IMPLEMENT LATER % minNumberNeurons = 10 
GiantZscoreMatrix = []; 
GiantZscoreLabels = []; % added 4-30-2025 

% 02/08 one z score for each brain structure 
numStructures = size(whatStructures,1); 
ZforBarGraph = zeros(numStructures,1); 

% Store all z-score values for each brain structure 
allZscores = []; 

% sort brain structures so they go in order (magnitude of decrease /
% increase) 
% SORT for Gria based on decrease / increase 
%sortIdx = [27, 23, 26, 14, 2, 17, 24, 22, 13, 18, 10, 12, 16, 8, 4, 11, 21, 19, ...
           %7, 25, 20, 3, 15, 9, 6, 1, 5];
%whatStructures = whatStructures(sortIdx,1); 
%%
for iStructure = 1:length(whatStructures) % loop through structures  
% [10,16,12,2,17,4,7,5]
%for iStructure = [17,4,7,5]
    % if iStructure == 18 % Skip PC (doens't have seizures that are long enough For gria4! ) 
    %     continue 
    % end 
    display(iStructure);
    targetStructure = whatStructures{iStructure};

    % if targetStructure is "DontAnalyze" then skip 
    if strcmp(targetStructure, 'DontAnalyze')
         continue 
     end

    [StructureDatabase] = indexToOneBrainStructure241118(allDataBases,targetStructure);
   
    % keep only seizures that last > min seizure duration 
    LongSeizuresLog = (StructureDatabase.SeizureDuration >= MinimumSeizureDuration);
    StructureDatabase = StructureDatabase(LongSeizuresLog,:); % keep only seizures that are long enough 
    LongPreSeizurePeriod = (StructureDatabase.PreSeizureDuration >= MinPreSeizureDuration); 
    StructureDatabase = StructureDatabase(LongPreSeizurePeriod,:); % keep only seizures that have sufficient Pre Seizure time
    % if there is no Structure database 
    % if isempty(StructureDatabase) % if StructureDatabase is empty skip to the next iteration (next brain structure) 
    %     continue 
    % end 
    % 
     if isempty(StructureDatabase.SingleUnitsSWD{1,1}.all)  % if there is no single neurons skip to the next iteration (next brain structure)
          continue 
     end
  
    
    % B A S E L I N E 
    localMice = unique(StructureDatabase.MouseID); % what mice are in this specific brain structure 
    numMice = size(localMice,1); % check how many mice 
    % if numMice <1  % if there is less than 1 mouse, skip this brain structure 
    %     continue % don't analyze this brain structure 
    % end
   
    [EEG_Time_NonSeizures,allNeuronsOneStructureNonS,baselineMatrix] = extractEEGandSpikesZscore(StructureDatabase,PreSeizure,MinimumSeizureDuration,binSize,numBins);  
    firingDuringNonSeizures{iStructure} = allNeuronsOneStructureNonS; % store spikes 
    
    % S E I Z U R E S
    meanEEGforEachStructure = cell(length(whatStructures),1); % for storing EEG 
    [meanEEGforEachStructure] = extractEEGtraces(localMice,StructureDatabase,PreSeizure,MinimumSeizureDuration,meanEEGforEachStructure,mouseIDs,iStructure); % extract EEGs 
    [allCountsSeizure,seizureMatrix,uniqueNeurons,allLabels] = extractSpikesInRangeSEIZURE(StructureDatabase,PreSeizure,binSize,MinimumSeizureDuration,numBins); 
    firingDuringSeizures{iStructure} = allCountsSeizure; % store ff for each neuron in this structure

   % Plot firing leading to a non seizure, seizure, and z-score for all
   % events (no averaging) 
    [sumSeizures,sumNeurons] = countEventsZscoresForPlots(StructureDatabase); % count no of seizures and neurons (will be displayed on the figure) 
    %[seizureOrdered,baselineOrdered,zScoresSeizure] = plotNeuronFiringWithZScores(allNeuronsOneStructureNonS, allCountsSeizure,iStructure,whatStructures,folderName,sumNeurons,sumSeizures);
    % Function below will separate trials based on the z-scores during
    % seizrues. If they are significant they will be classified as such. 
    [seizureOrdered,zScoresSeizure,percentValid] = calcZscores_12_02(allNeuronsOneStructureNonS,allCountsSeizure,sumNeurons,sumSeizures,folderName,whatStructures,iStructure); 
    ValidTrials{iStructure,2} = percentValid; % store the percent 


    % 12/14 
    % Plot a giant heatmap for all neurons in this brain structure 
    [allNeuronsMatrix,zScores] = zScoreGiantMatrix(baselineMatrix,seizureMatrix,uniqueNeurons,targetStructure,folderName,allLabels); % 
    
    % sort rows based on peak z-score (before concating) + SORT LABELS 
    [allNeuronsMatrix,sortedAllLabels] = sortAllNeuronsMatrix(allNeuronsMatrix,allLabels,folderName,targetStructure); 
    allZscores{iStructure,2} = allNeuronsMatrix; % store z score values 
    allZscores{iStructure,1} = targetStructure; 


    % 02/08 calculate one value (mean z during the first 4 sec-s of the seizure) for each brain structure 
    meanZscoreAll = calculateMeanZscoreForEachStructure(allNeuronsMatrix); 
    display(meanZscoreAll)
    ZforBarGraph(iStructure) = meanZscoreAll; % store this value 



    % add rows with zeros to separate different structures 
        breakRows = 20*ones(20,24);
        breakRows(breakRows == 20) = NaN; % change 10 to NaNs 
        allNeuronsMatrix = [allNeuronsMatrix;breakRows]; 
    GiantZscoreMatrix = [GiantZscoreMatrix;allNeuronsMatrix];
    GiantZscoreLabels = [GiantZscoreLabels;sortedAllLabels]; 
    % Access how many trials had a significant z-score when the seizure has
   % happened  
   %[percentValid] = findSeizureModulatedNeurons(zScoresSeizure); 
   %ValidTrials{iStructure,2} = percentValid; % store the percent 
  % clean up 
  allNeuronsMatrix = []; 

end
%% 12/22 Plot zscore heatmap for all brain structures 
plotGiantZscoreMatrix(GiantZscoreMatrix,folderName); 


%% Visualize brain structres and percent of valid structures 
% plot a bar graph 
Gria4validTrials = ValidTrials; 
StargazervalidTrials = ValidTrials; 
cell2mat(ValidTrials(:,2))
% figure; 
% bar(ans)

%% Bar graph of mean z-scores 
plotBarGraphZscores(ZforBarGraph,whatStructures); % plot a bar graph of z-scores 

%% Box graph + scatter (note that it plots 50% of data points for each structure) 
boxAndScatterZscoreUnsorted(numStructures,allZscores); 

%% Box + scatter sorted (plots all data points) 
sortedBoxAndScatterZscore(allZscores); 

