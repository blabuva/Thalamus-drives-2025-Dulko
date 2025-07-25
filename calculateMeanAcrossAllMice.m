function [MeansAllMice] = calculateMeanAcrossAllMice(SumsAllMice,numBins)
% parent function: Phase_ela.m

% INPUT: 
% SumsAllMice - includes sum of spikes for each bin for each brain
% structure and mouse; rows: brain structures, columns: mice 

numStr = size(SumsAllMice,1); % how many brain structures 
%numBins = 80 %%%%%%%%%%%%%%%%%%%%%%% HARD CODED FOR NOW 

MeansAllMice = zeros(numStr,numBins); % initiate a variable to store means for all structures together 

% loop through brain structures (rows) 
for iStructure = 1:numStr 
    % extract non-empty fields 
    concatenatedData = []; % Initialize an empty matrix for concatenation
    
    % Loop through each field in the current row
    for iCol = 1:size(SumsAllMice, 2)
        currentData = SumsAllMice{iStructure, iCol};
        
        % Check if the current field is not empty
        if ~isempty(currentData)
            concatenatedData = [concatenatedData; currentData]; % Concatenate non-empty fields
        end
    end
    
    % Now 'concatenatedData' contains all non-empty fields concatenated
    % Perform further calculations on 'concatenatedData'
    
    % Example calculation: Calculate the mean of each column
    if ~isempty(concatenatedData)
        meanValues = mean(concatenatedData, 1);
        MeansAllMice(iStructure,:) = meanValues;
    end
end 

end % function end 