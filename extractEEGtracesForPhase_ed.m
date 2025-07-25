function [EEGs,BadSeizuresIndices] = extractEEGtracesForPhase_ed(MouseDatabase,howFarBack,howFarInto)
% parent function: Phase_ela.m

% this function grabs MouseDatabase to extract EEG trace for each seizure 
% variables leftEdge and rightEdge specify the time range that is looked at
% 

% Important consideration - sometimes seizures don't have enough pre-seizure time  
%Especially for Stargazer - therefore the 2nd part of the code checks how
%long extracted data is 

SeizureIDs= unique(MouseDatabase.SeizureNumber); % what are seizure numbers?
maxSeizureID = max(SeizureIDs); % find the last seizure
shortMouseDatabase = MouseDatabase(1:maxSeizureID,:); % use maxSeizureID to extract seizures for one structure and so they don't repeat
EEGs = cell(maxSeizureID,2);
for iSeiz = 1:maxSeizureID
    times = [];
    currentSeizure = shortMouseDatabase(iSeiz,:); % extract row for current seizure
    TroughTimes = currentSeizure.SWD_Props{1,1}.SWD_troughTimes; 
    
    relTime = TroughTimes{1,1}(1); % SEIZURE START 
    %relTime = TroughTimes{1,1}(end); % SEIZURE END 
    
    leftEdge = relTime-howFarBack; % left edge is specified so we look 200 ms before the first trough 
    rightEdge = relTime+howFarInto; % right edge is specified so we look 200 ms into the seizure 
    times = currentSeizure.SWD_Props{1,1}.SWD_timeCol{1,1}; % rename for simpliciy
    %[BegInx,~] = find(times == leftEdge); % find index in times to the seizure beggining
    %[EndInx,~] = find(times == seizureEnd); % find index in times to seizure end
    [~,BegInx] = min(abs(times - leftEdge)); % find index in times to seizure start without a floating-point problem 
    [~, EndInx] = min(abs(times - rightEdge)); % line above generates a floating-point problem
    EEG = currentSeizure.SWD_Props{1,1}.SWD_EEG{1,1}(BegInx:EndInx,1); % extract voltage during seizure only
    EEGs{iSeiz,1} = EEG; % save in EEGs that holds voltage values for all seizures
    tEEG = currentSeizure.SWD_Props{1,1}.SWD_timeCol{1,1}(BegInx:EndInx,1); % extract time during seizure only
    EEGs{iSeiz,2} = tEEG; 
end
% check if any seizures are shorter than 401 time points 

% Initialize a logical index array for rows to keep
SeizuresToKeep = true(size(EEGs, 1), 1);
% Initialize an array to store the indices of rows to be deleted
BadSeizuresIndices = [];


% Loop through each row

for i = 1:size(EEGs, 1)
    % Check the size of the elements in the first column
    if size(EEGs{i, 1}, 1) < (howFarInto+howFarBack)*1000+1 || size(EEGs{i, 2}, 1) < (howFarInto+howFarBack)*1000+1
        SeizuresToKeep(i) = false; % Mark row for deletion
        BadSeizuresIndices = [BadSeizuresIndices; i]; % Store the index of the row to be deleted
    end
end

% Delete the rows that do not meet the criteria
EEGs = EEGs(SeizuresToKeep, :);

% Output the indices of the rows that were deleted
BadSeizuresIndices

 
end
