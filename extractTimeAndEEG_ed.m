function [EEGTable] = extractTimeAndEEG_ed(MouseDatabase)
% parent function: StartHere.m

% this function grabs MouseDatabase to extract EEG trace for each seizure 

SeizureIDs= unique(MouseDatabase.SeizureNumber); % what are seizure numbers?
maxSeizureID = max(SeizureIDs); % find the last seizure
shortMouseDatabase = MouseDatabase(1:maxSeizureID,:); % use maxSeizureID to extract seizures for one structure and so they don't repeat
EEGs = cell(maxSeizureID,2);
for iSeiz = 1:maxSeizureID
    times = [];
    currentSeizure = shortMouseDatabase(iSeiz,:); % extract row for current seizure
    seizureBeggining = currentSeizure.SWD_Props{1,1}.SWD_startTime; % when did the seizure start??
    seizureEnd = seizureBeggining + currentSeizure.SeizureDuration; % when did this seizure end??
    times = currentSeizure.SWD_Props{1,1}.SWD_timeCol{1,1}; % rename for simpliciy
    [BegInx,~] = find(times == seizureBeggining); % find index in times to the seizure beggining
    %[EndInx,~] = find(times == seizureEnd); % find index in times to seizure end
    [~, EndInx] = min(abs(times - seizureEnd)); % line above generates a floating-point problem
    time = currentSeizure.SWD_Props{1,1}.SWD_timeCol{1,1}(BegInx:EndInx,1); % extract time during seizure only
    EEGs{iSeiz,1} = time; % save time in EEGs that holds time values for all seizures
    EEG = currentSeizure.SWD_Props{1,1}.SWD_EEG{1,1}(BegInx:EndInx,1); % extract voltage during seizure only
    EEGs{iSeiz,2} = EEG; % save in EEGs that holds voltage values for all seizures
end
    EEGTable = cell2table(EEGs, 'VariableNames', {'Time', 'EEG'});
end
