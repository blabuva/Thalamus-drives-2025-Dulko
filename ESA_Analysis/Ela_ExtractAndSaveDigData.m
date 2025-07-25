%% === Ela Extract and Save Digital Data === %
% ----------- Put path to directory below ------------- %
currDirPath = 'S:\intanData\ela\markTemp\0022\rawData\'; % path to directory with raw data
% ----------------------------------------------------- %
%% === Main Loop Below === %%
fprintf('Processing %s...\n',currDirPath)
currFiles = dir(currDirPath); % get contents of current folder
currNames = {currFiles.name}';
rhdLog = endsWith(currNames,'.rhd'); % find rhd files
currNames(~rhdLog) = []; % remove those that aren't rhd files
dig.data = logical([]);
dig.time = [];
for fi = 1:numel(currNames)
    cf = sprintf('%s%s',currDirPath,currNames{fi}); % current file to read
    ID = sk_readRHD(cf); % Intan Data Structure
    dig.data = [dig.data,logical(ID.board_dig_in_data)];
    dig.time = [dig.time,ID.t_amplifier];
end
% digDataLog(di) = sum(dig.data,"all")>0;
digFileName = sprintf('%s%s',currDirPath,'digitalData.mat');
save(digFileName,'dig','-v7.3');