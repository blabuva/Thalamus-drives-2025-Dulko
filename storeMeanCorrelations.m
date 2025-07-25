function [CorrelationsDuringSWSs] = storeMeanCorrelations(MeanCorrelations, combinations, CorrelationsDuringSWSs, iMouse)
% parent function: MasterCodeBetweenNucleiCorrelation_2025_01_21.m

% this functions looks at the brain structure pairs that are in this
% recording. 2) Then looks for a match from all possible combinations in '
% combinations' variable 3) after finding the match mean correlations for
% each seizure are saved in the right row and column of
% 'CorrelationsDuringSWS' 

for iPair= 1:size(MeanCorrelations,1)

structure1 = MeanCorrelations(iPair,1); 
%structure1 = structure1{1,1}; % unpack 

structure2 = MeanCorrelations(iPair,2); 
%structure2 = structure2{1,1};

% Find matches (you'll get logical indexing) 
FirstColumnMatch = ismember(combinations(:,1),structure1); 
SecondColumnMatch = ismember(combinations(:,2),structure2); 

% convert logical to double 
FirstColumMatchNumerical = double(FirstColumnMatch); 
SecondColumnMatchNumerical = double(SecondColumnMatch); 

for iRow = 1:size(FirstColumnMatch,1) % loop through rows in search for '1' 
    val1 = FirstColumMatchNumerical(iRow); 
    val2 = SecondColumnMatchNumerical(iRow) ; 
    sumVal = val1+val2; 
    if sumVal == 2 % means that the code found the match 
        % if a match was found, extract mean correlation values 
        meanCorrsToBeStored = MeanCorrelations(iPair,3:size(MeanCorrelations,2)); 
        meanCorrsToBeStored = cell2mat(meanCorrsToBeStored); % convert to a numbers 
         
        % % Add a 'tail" of ones meanCorrelations so when the heatmap is
        % plotted we will be able to distinguish between mice) 
        meanCorrsToBeStored = [meanCorrsToBeStored, ones(1,1)];
        CorrelationsDuringSWSs{iRow,iMouse} = meanCorrsToBeStored;
    end 
   

end  

% Clean up before the next iteration 
FirstColumnMatch = []; 
SecondColumnMatch = []; 
end 

end 