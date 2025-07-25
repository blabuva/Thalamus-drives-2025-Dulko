% Master Code for synchrony analysis within the same brain structure 

    % modification done on 24/11/09 lumps some structures together  
%% IMPORTANT parameters 
% option 1: 
binSize = 0.025; % 10 ms; prev was: binSize = 0.025; % 25 ms

% option 2: 
%binSize = 0.025; 
minNumberNeurons = 5; % min number of neurons to include recording in the analysis 

% load the most recent DataBase 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase/2025_05_16__08_17_52'
load('2025_05_16__08_17_52_allDataBases.mat') % Load the database 
logicalIndexStrain = strcmp(allDataBases.Strain, 'Gria4');% keep one mouse only 
allDataBases = allDataBases(logicalIndexStrain, :); % now allDataBases includes one mouse only

%% Lump structures based on Mark's code;
[whatStructures,allDataBases] = LumpStructuresForSynchronyCode(allDataBases); 
 
%% Check number of structures and mice. Initialize empty cells for storing output 
% create a structure for collecting synchrony data from all mice and all
% structures all seizures
numStructures = length(whatStructures);
whatMice = unique(allDataBases.MouseID); % what mice are here 
numMice = length(whatMice); % how many mice are here

%BEFORE SEIZURES 
    masterRawResultsBefore = cell(length(whatStructures),numMice);
    averageMatricesBefore = cell(length(whatStructures),numMice);
    masterFiringDataBefore = cell(length(whatStructures),numMice); % store firing as well 

%DURING SEIZURES
    masterRawResults = cell(length(whatStructures),numMice);
    averageMatrices = cell(length(whatStructures),numMice);
    masterFiringData = cell(length(whatStructures),numMice); % store firing as well 

%AFTER SEIZURES
    masterRawResultsAfter = cell(length(whatStructures),numMice);
    averageMatricesAfter = cell(length(whatStructures),numMice); 
 
%% Loop through structures and calculate the correlations before, during, and after seizures 
for iStructure = 1:length(whatStructures)
    display(iStructure)

    % Skip the structure if it is 'DontAnalyze'
    if strcmp(whatStructures{iStructure}, 'DontAnalyze')
        continue 
    end
    
    logicalIndex = cellfun(@(x) strcmp(x{1}, whatStructures{iStructure}), allDataBases.LumpedStructure);% Access the inner cell content for comparison
    StructureDatabase = allDataBases(logicalIndex, :); % Use the logical index to filter rows
    [whatMiceStructure, whatMiceInd] = unique(StructureDatabase.MouseID);
    
    for iMouse = 1:length(whatMiceInd)
        display(iMouse)
        storeInd = find(strcmp(whatMice,whatMiceStructure{iMouse}));
        logicalIndex = strcmp(StructureDatabase.MouseID, whatMiceStructure(iMouse));
        StructureMouseDatabase = StructureDatabase(logicalIndex,:);
         
        
            % BEFORE SEIZURES 
            [spikesBeforeSeizures,numClusters] = CalculateFiringRateBeforeSWS(StructureMouseDatabase,binSize);
            masterFiringDataBefore{iStructure,storeInd} = spikesBeforeSeizures; % store firing before  
            if numClusters < minNumberNeurons % IF there is less than 5 neurons the mouse will not be analyzed 
                    continue 
                end 
            [correlationMatricesBefore, averageMatrixBefore] = CorrCoef_Before240213(spikesBeforeSeizures);
            averageMatricesBefore{iStructure,storeInd} = averageMatrixBefore; 
            masterRawResultsBefore{iStructure,storeInd}=correlationMatricesBefore; 
            
            % DURING SEIZURES 
            spikesDuringSeizures = CalculateFiringRateDuringSWS(StructureMouseDatabase,binSize); 
            masterFiringData{iStructure,storeInd} = spikesDuringSeizures; % store firing 
            [correlationMatrices, averageMatrix] = CorrCoef_240212(spikesDuringSeizures);
            averageMatrices{iStructure,storeInd} = averageMatrix; 
            masterRawResults{iStructure,storeInd} = correlationMatrices; 
            
            % % AFTER SEIZURES 
            % spikesAfterSeizures = CalculateFiringRateAfterSWS(StructureMouseDatabase,binSize);
            % [correlationMatricesAfter, averageMatrixAfter] = CorrCoef_After240213(spikesAfterSeizures);
            % averageMatricesAfter{iStructure,storeInd} = averageMatrixAfter; 
            % masterRawResultsAfter{iStructure,storeInd} = correlationMatricesAfter;
    end
end
% plot
%run Plot_brainStructure_correlation_manyMice.m

%% Calculate difference (corr during seizure - before) for each structure and each mouse separately 
[difference] = calcDifferenceInCorr(averageMatrices,averageMatricesBefore); 

%% Plot a bar graph for all structures illustrating the increase of correlations (UN-ORDERED) 
barGraphUnorderedCorrelation(difference,whatStructures); 

%% Plot a bar graph for all structures illustrating the increase of correlations (ORDERED)
barGraphOrderedCorrelation(numStructures, difference, whatStructures, binSize); 

%% Investigate linear relationships 
investigateNumberOfNeuronsAndCorrelation(averageMatrices); % num neurons x correlation
investigateFiringRateAndCorrelation(masterFiringData, binSize, averageMatrices); % firing rate x correlation
investigateChangeInFiringAndCorrelation(whatStructures,numMice,averageMatricesBefore,averageMatrices,masterFiringDataBefore,masterFiringData); % firing change vs correlation change

%% OTHER
% Number of brain structures (columns)
% numStructures = size(difference, 2);
% 
% % Initialize arrays for storing mean values
% meanValues = nan(1, numStructures);
% 
% % Prepare a figure for the plot
% figure;
% hold on;
% 
% % Loop through each brain structure (column)
% for iStructure = 1:numStructures
%     % Extract the values for the current brain structure
%     values = difference(:, iStructure);
% 
%     % Filter out NaN and zero values
%     values = values(~isnan(values) & values ~= 0);
% 
%     % Calculate the mean of the non-zero, non-NaN values
%     meanValues(iStructure) = mean(values);
% 
%     % Plot individual values as dots, offset horizontally for clarity
%     scatter(repmat(iStructure, size(values)), values, 'filled', 'MarkerFaceAlpha', 0.6,'MarkerFaceColor','k');
% end
% 
% % Plot the bar graph for the mean values
% bar(meanValues, 'FaceAlpha', 0.5, 'EdgeColor', 'none');  % Semi-transparent bars
% 
% % Set plot aesthetics
% xlabel('Brain Structure');
% ylabel('Difference Value');
% ylim([0 0.2]); 
% title('Mean Difference with Individual Variability by Brain Structure');
% xticks(1:numStructures);  % Set x-axis ticks to match the number of brain structures
% xticklabels(whatStructures);  % Replace with actual names if available
% xlim([0, numStructures + 1]);  % Set x-axis limits
% legend({'Individual Values', 'Mean Value'}, 'Location', 'Best');
% 
% hold off;



