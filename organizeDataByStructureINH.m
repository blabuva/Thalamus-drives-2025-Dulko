function [organizedDataInh,uniqueStructures] = organizeDataByStructureINH(lumpedAllResultsInhTable) 
% parent function: masterInhPlotter.m 

% IMPORTANT: here we swap right and left part so spike of the seizure is on
% the 50th bin 

uniqueStructures = unique(lumpedAllResultsInhTable.BrainStructure); 
organizedDataInh = {}; % initiate the structure 

% loop through unique brain structures  

for iUniqBrain = 1:size(uniqueStructures,1)

    currentStructure = uniqueStructures{iUniqBrain}; % extract one unique brain structure name 
    % index to all rows that have that name in the lumpedAllResultsTable 
    RowIdx = strcmp(currentStructure,lumpedAllResultsInhTable.BrainStructure); 
    filteredData = lumpedAllResultsInhTable(RowIdx == 1, :); %extract only rows that match this brain structure's name 
    % sum up data from multiple mice and save as one variable  
    concatValuesNonSWDs = []; 
    concatValuesSWDs = []; 

    for iRowFiltered = 1:size(filteredData,1)
        % concatenate NON_SWDs 
            oneMouseNON_SWDs = filteredData(iRowFiltered,2); % 2 - NON_SWDs 
            valuesNON_SWDs = oneMouseNON_SWDs.NON_SWDs{1,1}; 
            % figure; bar(valuesNON_SWDs,'histc'); % wanna plot?  
            concatValuesNonSWDs = [concatValuesNonSWDs; valuesNON_SWDs]; 
            sumNON_SWDs = sum(concatValuesNonSWDs,1); % sum by column 
        % concatenate SWDs 
            oneMouseSWDs = filteredData(iRowFiltered,3); % 3 - SWDs
            valuesSWDs = oneMouseSWDs.SWDs{1,1}; 
            %figure; bar(swaped,'histc');  % wanna plot? 
            concatValuesSWDs = [concatValuesSWDs; valuesSWDs];
            sumSWDs = sum(concatValuesSWDs,1); % sum by column 


         % change order so the "spike" of SWD is on the 50th bin 
            if isempty(sumNON_SWDs) 
                continue 
            else 
            % for NON SWDs    
            leftPart =  sumNON_SWDs(1,51:100); 
            rightPart =  sumNON_SWDs(1,1:50); 
            swaped = [leftPart, rightPart]; 
            sumNON_SWDs = swaped; % change name 
            leftPart = []; rightPart = []; % clean  
            % for SWDs  
            leftPart = sumSWDs(1,51:100); 
            rightPart = sumSWDs(1,1:50); 
            swaped = [leftPart, rightPart]; 
            sumSWDs = swaped; % change name 

            end

          
        
    end 
    % store the sums 
    organizedDataInh{iUniqBrain,1} = currentStructure; 
    organizedDataInh{iUniqBrain,2} = sumNON_SWDs; 
    organizedDataInh{iUniqBrain,3} = sumSWDs; 


end

end % function end 