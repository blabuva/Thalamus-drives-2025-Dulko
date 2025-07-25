function dataBase = addChanDataToDataBase(dataBase, map, channelData_DS, channelSampFreq, ...
     seizureFreeLeadTime, seizureFreePostTime, dataBaseDump, iJumper, experimentInfo, iStruc, iSWD) 

%%%% JUST SAVE PATH TO SAVED DATA IN TABLE:
theChannelData.chanData = array2table(map.channelBrainLocations, 'variablenames', {'ChanNum', 'BrainLocation'}) ;
theChannelData.chanData.X = map.channelPositions(:,1) ;
theChannelData.chanData.Y = map.channelPositions(:,2) ;
channelRecordings = channelData_DS.chanData(:, find(channelData_DS.time >= seizureFreeLeadTime & channelData_DS.time < seizureFreePostTime)) ;

for iChan = 1:size(channelRecordings,1)
    theChannelData.chanData.Recording{iChan} = channelRecordings(iChan,:) ;
end

theChannelData.time = channelData_DS.time(find(channelData_DS.time >= seizureFreeLeadTime & channelData_DS.time < seizureFreePostTime)) ;
theChannelData.sampFreq = channelSampFreq; 

%% save the data
chanFileName = sprintf('%schannelData_mouse%s__SWD%04d', dataBaseDump, experimentInfo.mouse.ID, iSWD) ;

if iStruc ==1
    save(chanFileName, 'theChannelData') ;
end

%% add fileName brain structure list to dataBase table
channelDataInfo.electrodeLocations = unique(theChannelData.chanData.BrainLocation) ;
channelDataInfo.fileLocation = chanFileName ;
dataBase.ChannelDataInfo{iJumper} = channelDataInfo ;
