function [whatStructures,PreSeizure,MinimumSeizureDuration,binSize,...
         leftLimit,rightLimit,numBins,numBinsA,mouseIDs,mouseColors, MinPreSeizureDuration] = setImportantSpecs(allDataBases) 
MinPreSeizureDuration = 4; % focus on events that have long enough pre-seizure duration (in seconds)
PreSeizure = -MinPreSeizureDuration; % how far back do we want to look
MinimumSeizureDuration = 4; % cut off for seizure duration in seconds. Shorter seizures will be excluded 
binSize = 1; % specify bin size (1 second) 
leftLimit = -3; % after seizure - leftLimit
rightLimit = 7; % after seizure - rightLimit
numBins = (MinimumSeizureDuration-PreSeizure)/binSize;
numBinsA = (rightLimit-leftLimit)/binSize;
mouseIDs = unique(allDataBases.MouseID); 
mouseColors = parula(numel(mouseIDs));

%% Extract whatStructures (names of lumped brain structures) 
LumpedStructure = allDataBases.LumpedStructure;

% Initialize an empty cell array to store unique structure names
uniqueNames = {};

% Loop through each cell in LumpedStructure
for i = 1:numel(LumpedStructure)
    % Get the inner cell containing the structure name
    innerCell = LumpedStructure{i};
    % Check if the inner cell is not empty and contains a single element
    if ~isempty(innerCell) && numel(innerCell) == 1
        % Get the structure name from the inner cell and add it to uniqueNames
        structureName = innerCell{1};
        uniqueNames{1+end} = structureName;
    end
end

whatStructures = unique(uniqueNames)';

end
