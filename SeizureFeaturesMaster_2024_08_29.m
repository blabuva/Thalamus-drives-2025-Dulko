% Analyze Gria4 mouse 
    mouse = 'Gria4'; 
    recDurations = readtable('/media/elaX/Publications/Figures/Figure1_Approach/Gria4VSstargazerFeatures/seizureComparison_moreFiles/RecDurationGria.xlsx');
    addpath '/media/elaX/intanData/ela/individualExperimentDataBase'/2025_05_16__08_17_52/;
    load('2025_05_16__08_17_52_allDataBases.mat'); % Load the database
    logicalIndexStrain = strcmp(allDataBases.Strain, mouse);% keep one mouse model only 
    [originalDB] = BigLag_240405(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
    allDataBases = originalDB; % Inspect the database 
    [whatStructures,PreSeizure,MinimumSeizureDuration,binSize,leftLimit,rightLimit,numBins,numBinsA,mouseIDs,mouseColors] = setImportantSpecs(allDataBases);
    animalData = allDataBases; 

    % Calculate different seizure features 
    % # of seizures / min 
    [avgNumberSeizures] = calcSeizureFrequency(animalData,recDurations); 
    % seizure duration ; cycle duration ; # of cycles (rows are different mice) 
    [avgDuration,avgCycleDuration,AvgNumCycles] = calcSeizureDuration(animalData); 
    % Save in a structure
    seizureData.(mouse).avgNumberSeizures = avgNumberSeizures;
    seizureData.(mouse).avgDuration = avgDuration;
    seizureData.(mouse).avgCycleDuration = avgCycleDuration;
    seizureData.(mouse).AvgNumCycles = AvgNumCycles;

% Analyze Stargazer mouse 
    clear allDataBases
    mouse = 'Stargazer'; 
    recDurations = readtable('/media/elaX/Publications/Figures/Figure1_Approach/Gria4VSstargazerFeatures/seizureComparison_moreFiles//RecDurationStargazer.xlsx');
    load('2025_05_16__08_17_52_allDataBases.mat'); % load the database 
    logicalIndexStrain = strcmp(allDataBases.Strain, mouse);% keep one mouse model only 
    [originalDB] = BigLag_240405(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
    allDataBases = originalDB; % Inspect the database 
    [whatStructures,PreSeizure,MinimumSeizureDuration,binSize,leftLimit,rightLimit,numBins,numBinsA,mouseIDs,mouseColors] = setImportantSpecs(allDataBases);
    animalData = allDataBases; 

    % Calculate different seizure features 
    % # of seizures / min 
    [avgNumberSeizures] = calcSeizureFrequency(animalData,recDurations); 
    % seizure duration ; cycle duration ; # of cycles (rows are different mice) 
    [avgDuration,avgCycleDuration,AvgNumCycles] = calcSeizureDuration(animalData); 
    % Save in a structure
    seizureData.(mouse).avgNumberSeizures = avgNumberSeizures;
    seizureData.(mouse).avgDuration = avgDuration;
    seizureData.(mouse).avgCycleDuration = avgCycleDuration;
    seizureData.(mouse).AvgNumCycles = AvgNumCycles;

% Perform statistical analysis 
[pValues] = checkStatisticsSeizureFeature(dataGria4,dataStargazer);

% Plot in matlab 
plotAllFeatures(seizureData); 
figurePath = ('/media/elaX/Publications/Figures/Figure1_Approach/Gria4VSstargazerFeatures/');
svgFileName = fullfile(figurePath, ['SeizureComparison6-18-2025_'  '.svg']);    
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

%% Save the output as an excel file if you'd like to use prism  
saveFolderPath = '/media/ela2X/'; % where do you want to save the file  
fileName = sprintf('%s_%s.xlsx', mouse, datestr(now, 'yyyy-mm-dd')); % include the mouse and today's date in the file name 
fullFilePath = fullfile(saveFolderPath, fileName); % Full path to save the file

% Convert your output data into tables or cell arrays
% Assuming avgNumberSeizures, avgDuration, avgCycleDuration, and meanNumCycles are vectors or matrices
avgNumberSeizuresTable = array2table(avgNumberSeizures, 'VariableNames', {'AvgNumberSeizures'});
avgDurationTable = array2table(avgDuration, 'VariableNames', {'AvgDuration'});
avgCycleDurationTable = array2table(avgCycleDuration, 'VariableNames', {'AvgCycleDuration'});
numCyclesTable = array2table(AvgNumCycles, 'VariableNames', {'MeanNumCycles'});

% Save each table to a different sheet in the Excel file
writetable(avgNumberSeizuresTable, fullFilePath, 'Sheet', 'AvgNumberSeizures');
writetable(avgDurationTable, fullFilePath, 'Sheet', 'AvgDuration');
writetable(avgCycleDurationTable, fullFilePath, 'Sheet', 'AvgCycleDuration');
writetable(numCyclesTable, fullFilePath, 'Sheet', 'MeanNumCycles');

% Display a message indicating the save was successful
fprintf('Data has been saved to %s\n', fullFilePath);




 