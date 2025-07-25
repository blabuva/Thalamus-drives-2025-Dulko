function GetCurrentNoOfUnitsAndSeizures 
% load the database 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase'/2025_05_16__08_17_52/;
load('2025_05_16__08_17_52_allDataBases.mat'); % Load the database 

%% Analyze allDataBase for Gria mouse  
    logicalIndexStrain = strcmp(allDataBases.Strain, 'Gria4');% keep Gria4 only 
    [originalDB] = BigLag_240405(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
    allDataBases=originalDB; % change the name for simplicity 
    % What brain structures are in the database?  
    [whatStructures,mouseIDs] = setImportantSpecs(allDataBases);
    
    % Count single-units:
    [SingleUnits] = countUnits(allDataBases,whatStructures,mouseIDs); 
    % Counts seizures now: 
    [Seizures] = countSeizures(allDataBases); % NOTE: all rec-ed seizures are included. Even the ones that did not have SUs.
    % I think it's fair since we can also analyze multiunit activity. 
      
    allDataBases = []; 
%% Analyze allDataBase for Stargazer mouse 
    addpath '/media/elaX/intanData/ela/individualExperimentDataBase'/2025_05_16__08_17_52/
    load('2025_05_16__08_17_52_allDataBases.mat') % Load the database
    logicalIndexStrain = strcmp(allDataBases.Strain, 'Stargazer'); % keep Stargazer only 
    [originalDB] = BigLag_240405(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
    allDataBases = originalDB; % change the name for simplicity 
    % What brain structures are in the database?  
    [whatStructures,mouseIDs] = setImportantSpecs(allDataBases);
        
    
    % Count single-units:
    [SingleUnits_Stg] = countUnits(allDataBases,whatStructures,mouseIDs); 
    % Counts seizures now: 
    [Seizures_Stg] = countSeizures(allDataBases); 

%% Plot bar graphs 
plotNumberOfUnitsAndNoOfMice(SingleUnits,SingleUnits_Stg); 

end