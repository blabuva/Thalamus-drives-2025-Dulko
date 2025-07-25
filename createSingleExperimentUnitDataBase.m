function dataBase = createSingleExperimentUnitDataBase(type1SWDs, mappedKSUnits, EEG, experimentInfo, map, theTimeStamp, ...
    rhdDataPath, dataPathCurated, detectedSeizuresPath, dumpFolder)
% parent function: analyzeElasExperiment.m

%%
% clc; close all
% keep channelData_DS mouseMovement
save('/home/mark/matlab_temp_variables/DATAbase')
ccc
load('/home/mark/matlab_temp_variables/DATAbase')

%%
warning('off', 'all')

%% create dataBase folder to dump files
dataBaseFolder = '/media/elaX/intanData/ela/channelDataBaseFiles' ;
dataBaseDump = sprintf('%s/%s/%s/', dataBaseFolder, experimentInfo.mouse.ID, theTimeStamp) ;
mkdir(dataBaseDump) ;

%% load in downsampled channel data
channelSampFreq = 1000 ;
[channelData_DS, mouseMovement] = loadIntanDataAndDownsample(rhdDataPath, channelSampFreq) ;

%% save movement for entire experiment
mouseMovementFile = sprintf('%sallMotion_mouse%s', dataBaseDump, experimentInfo.mouse.ID) ;
save(mouseMovementFile, 'mouseMovement') ;

%% collect inhibitory and excitatory unit spike times
[inhibitoryUnits, excitatoryUnits] = isTheUnitInhibitoryOrExcitatory(experimentInfo, mappedKSUnits);

%% find structures containing single and multi units
multiUnitStructures = unique(type1SWDs.SWD_MultiUnits{1}.Channel_Brain) ;
singleUnitStructures = unique(type1SWDs.SWD_SingleUnits{1}.Channel_Brain) ;
allUnitStructures = unique([multiUnitStructures; singleUnitStructures]) ;

%% create data base table
dataBase = array2table([1], 'VariableNames', {'ExperimentNumber'}) ;

%% loop through each structure, with a nested loop for the number of seizures
iJumper = 1 ;
for iStruc = 1:length(allUnitStructures)
    currentStruc = allUnitStructures{iStruc} ;
    for iSWD = 1:size(type1SWDs, 1)
        dataBase = addMouseSpecsToDataBase(dataBase, experimentInfo, iJumper) ;
        [SWDstartTime, SWDendTime, SWDduration] = extractSWDtimesForDataBase(type1SWDs, iSWD) ;
        dataBase.Structure{iJumper} = currentStruc ;
        dataBase.SeizureNumber(iJumper) = iSWD ;
        dataBase.SeizureDuration(iJumper) = SWDduration ;

        if iSWD ==1
            seizureFreeLeadTime = channelData_DS.time(1) ;
            dataBase.PreSeizureDuration(iJumper) = SWDstartTime - seizureFreeLeadTime ;
        else
            seizureFreeLeadTime = type1SWDs.SWD_troughTimes{iSWD-1}(end) ;
            dataBase.PreSeizureDuration(iJumper) = SWDstartTime - seizureFreeLeadTime ;
        end

        if iSWD == size(type1SWDs, 1)
            seizureFreePostTime = channelData_DS.time(end) ;
            dataBase.PostSeizureDuration(iJumper) = seizureFreePostTime - SWDendTime ;
        else
            seizureFreePostTime = type1SWDs.SWD_troughTimes{iSWD+1}(1) ;
            dataBase.PostSeizureDuration(iJumper) = seizureFreePostTime - SWDendTime ;
        end

        dataBase.SWD_Props{iJumper} = type1SWDs(iSWD, 1:5) ;

        %% collect single and multi units for the current SWD
        dataBase.SingleUnitsAll{iJumper} = collectAllUnitsForDataBase(mappedKSUnits, inhibitoryUnits, excitatoryUnits, seizureFreeLeadTime, seizureFreePostTime, 'singleUnits', currentStruc) ;
        dataBase.MultiUnitsAll{iJumper} = collectAllUnitsForDataBase(mappedKSUnits, inhibitoryUnits, excitatoryUnits, seizureFreeLeadTime, seizureFreePostTime, 'multiUnits', currentStruc) ;
        dataBase.SingleUnitsSWD{iJumper} = collectSWDUnitsForDataBase(type1SWDs.SWD_SingleUnits{iSWD}, inhibitoryUnits, excitatoryUnits, currentStruc) ;
        dataBase.MultiUnitsSWD{iJumper} = collectSWDUnitsForDataBase(type1SWDs.SWD_MultiUnits{iSWD}, inhibitoryUnits, excitatoryUnits,currentStruc) ;
       
        %% collect EEG for current SWD: time in 1st column, EEG in 2nd column
        SWDeeg(:,1) = EEG.time(find(EEG.time >= seizureFreeLeadTime & EEG.time < seizureFreePostTime)) ;
        SWDeeg(:,2) = EEG.data(find(EEG.time >= seizureFreeLeadTime & EEG.time < seizureFreePostTime)) ;
        dataBase.EEGwithTime{iJumper} = SWDeeg;
        clear SWDeeg

        %% collect channel data for current SWD
        dataBase  = addChanDataToDataBase(dataBase, map, channelData_DS, channelSampFreq, ...
            seizureFreeLeadTime, seizureFreePostTime, dataBaseDump, iJumper, experimentInfo, iStruc, iSWD) ;

        %% add motion data
        if ~isempty(mouseMovement.raw)
                motion.RawStartIDX = find(mouseMovement.raw.time >=  seizureFreeLeadTime,1 ) ;
                motion.RawEndIDX = find(mouseMovement.raw.time >=  seizureFreePostTime,1 ) ;
                motion.SmoothStartIDX = find(mouseMovement.smooth.chan01(:,1) >=  seizureFreeLeadTime,1 ) ;
                motion.SmoothEndIDX = find(mouseMovement.smooth.chan01(:,1) >=  seizureFreePostTime,1 ) ;
                
                moveThisSeizure.thisSeizure.raw.movement = mouseMovement.raw.movement(motion.RawStartIDX:motion.RawEndIDX)' ;
                moveThisSeizure.thisSeizure.raw.time = mouseMovement.raw.time(motion.RawStartIDX:motion.RawEndIDX) ;
                moveThisSeizure.thisSeizure.smooth.chan01.movement = mouseMovement.smooth.chan01(motion.SmoothStartIDX:motion.SmoothEndIDX, 1);
                moveThisSeizure.thisSeizure.smooth.chan01.time = mouseMovement.smooth.chan01(motion.SmoothStartIDX:motion.SmoothEndIDX, 2);
                moveThisSeizure.thisSeizure.smooth.chan02.movement = mouseMovement.smooth.chan02(motion.SmoothStartIDX:motion.SmoothEndIDX, 1);
                moveThisSeizure.thisSeizure.smooth.chan02.time = mouseMovement.smooth.chan02(motion.SmoothStartIDX:motion.SmoothEndIDX, 2);
                moveThisSeizure.entireExperiment = mouseMovementFile ;
                dataBase.Motion{iJumper} = moveThisSeizure ;
                clear motion moveThisSeizure
        else
            dataBase.Motion{iJumper} = [] ; 
        end

        %% this is just to double check the start/end times to collect spikes for each seizure
        dataBase.DataCollectionStart(iJumper) = seizureFreeLeadTime ;
        dataBase.SeizureStartTime(iJumper) = type1SWDs.SWD_troughTimes{iSWD}(1) ;
        dataBase.SeizureEndTime(iJumper) = type1SWDs.SWD_troughTimes{iSWD}(end) ;
        dataBase.DataCollectionEnd(iJumper) =seizureFreePostTime ;

    

        iJumper = iJumper +1 ;
    end

end




