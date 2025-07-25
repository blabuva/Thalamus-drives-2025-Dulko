function prepareDataForPlottingHistogramsInR_Inh(neatDataWithPInh,strainOfInterest) 
% parent function: MasterCodePhaseEla20250212.m 

% this function prepares data for plotting histograms in R 
folderPath = '/media/elaX/MyFigures/PhaseAnalysis'; % this is where excel files will be saved 

%% Remove Dont Analyze 
idxDA = find(strcmp(neatDataWithPInh(:,1), 'DontAnalyze')); % Find the row index
neatDataWithPInh(idxDA, :) = []; % Remove the row

%% Save  S E I Z U R E  data for R 
% Convert cell array to a table
brainStructures = neatDataWithPInh(:,1); % First column (brain structure names)
SWDhistcounts = neatDataWithPInh(:,3); % Second column for seizure data (1x100 doubles)

% Preallocate a table
dataTable = table();

% Loop through each structure and concatenate the histogram counts
for i = 1:length(brainStructures)
    % Convert histogram counts to a table row
    tempTable = array2table(SWDhistcounts{i}, 'VariableNames', strcat('Bin', string(1:100))); 
    
    % Add the corresponding brain structure name
    tempTable.BrainStructure = repmat(string(brainStructures{i}), size(tempTable, 1), 1);
    
    % Concatenate tables correctly
    dataTable = [dataTable; tempTable]; 
end

% Reorder columns so that BrainStructure is first
dataTable = movevars(dataTable, 'BrainStructure', 'Before', 1);

% Save to CSV 
fileName = sprintf('Inh_histogramsSWDs_%s.csv', strainOfInterest); 
fullFilePath = fullfile(folderPath, fileName); % Combine folder and filename
writetable(dataTable, fullFilePath); % Save the file

%% Save N O N   -  S E I Z U R E  data for R 

% save for R 
% Convert cell array to a table
nonSWDshistounts = neatDataWithPInh(:,2); % Second column for non seizures (1x100 doubles)

% Preallocate a table
dataTable = table();

% Loop through each structure and concatenate the histogram counts
for i = 1:length(brainStructures)
    % Convert histogram counts to a table row
    tempTable = array2table(nonSWDshistounts{i}, 'VariableNames', strcat('Bin', string(1:100))); 
    
    % Add the corresponding brain structure name
    tempTable.BrainStructure = repmat(string(brainStructures{i}), size(tempTable, 1), 1);
    
    % Concatenate tables correctly
    dataTable = [dataTable; tempTable]; 
end

% Reorder columns so that BrainStructure is first
dataTable = movevars(dataTable, 'BrainStructure', 'Before', 1);

% Save to CSV
fileName = sprintf('Inh_histogramsNONSWDs_%s.csv', strainOfInterest); 
fullFilePath = fullfile(folderPath, fileName); % Combine folder and filename
writetable(dataTable, fullFilePath); % Save the file


end 