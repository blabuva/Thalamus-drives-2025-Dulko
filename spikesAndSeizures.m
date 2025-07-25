function [type1SWDs, nonSWDs, EEG] = spikesAndSeizures(mappedKSUnits, detectedSeizuresPath, seizurePad, rhdDataPath, fidTracker)
% parent function: analyzeElasExperiment.m

warning('off', 'all')
% save('/home/mark/matlab_temp_variables/spikeSeizure')
% ccc
% load('/home/mark/matlab_temp_variables/spikeSeizure')

%% append current function info to function tracker
funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;

%% load seizures
load(detectedSeizuresPath) ;

%% get rid of unused variables
keep curated_seizures mappedKSUnits seizurePad rhdDataPath ;

%% collect only bona fide, obvious seizures (i.e., Type 1 from Scott's seizure detection script)
type1SWDs = [] ;
iJumper =1 ;
for iSeizure = 1:size(curated_seizures, 2)
    seizureType = str2double(curated_seizures(iSeizure).type) ;
    if seizureType == 1
        seizureTimeColumn{iJumper,1} = curated_seizures(iSeizure).time ;
        seizureEEG{iJumper, 1} = curated_seizures(iSeizure).EEG ;
        SWDtroughTimes{iJumper, 1} = curated_seizures(iSeizure).time(curated_seizures(iSeizure).trTimeInds) ;
        SWDtroughVals{iJumper,1} = curated_seizures(iSeizure).trVals ;
        SWDstartTime(iJumper,1) = curated_seizures(iSeizure).seizureStartTime ;
        iJumper = iJumper +1 ;
    end
end

%% create table out of Type 1s
% NOTE: SWD Time IDXs of original correspond to the IDX of the extracted
% SWD, not the entire recording. I converted them to recording time in preceding loop
type1SWDs = array2table(seizureTimeColumn, 'VariableNames', {'SWD_timeCol'}) ;
type1SWDs.SWD_EEG = seizureEEG ;
type1SWDs.SWD_troughTimes = SWDtroughTimes ;
type1SWDs.SWD_troughVals = SWDtroughVals ;
type1SWDs.SWD_startTime = SWDstartTime ;

%% find sampling frequency from a seizure ;
sampPeriod = type1SWDs.SWD_timeCol{1}(2) - type1SWDs.SWD_timeCol{1}(1) ;
sampFreq = 1/sampPeriod ;

%% load in Intan EEG data
EEG = loadIntanEEGdata(rhdDataPath, sampFreq)


%% create table of non-seizure, control epochs
nonSWDs  = makeNonSeizureControlData(type1SWDs, EEG) ;

%% grab spikes that surround Type 1 SWDs
for iSWD = 1:size(type1SWDs, 1)
    SWDstart = type1SWDs.SWD_startTime(iSWD)  ;
    SWDend = type1SWDs.SWD_troughTimes{iSWD}(end) ;
    SWDstartWithPad = SWDstart - seizurePad ;
    SWDendWithPad = SWDend + seizurePad ;

     % go through single units WITHOUT pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstart, SWDend, mappedKSUnits, 'singleUnits') ;
    type1SWDs.SWD_SingleUnits{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through multi units WITHOUT pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstart, SWDend, mappedKSUnits, 'multiUnits') ;
    type1SWDs.SWD_MultiUnits{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through single units WITH pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstartWithPad, SWDendWithPad, mappedKSUnits, 'singleUnits') ;
    type1SWDs.SWD_SingleUnitsWithPad{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through multi units WITH pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstartWithPad, SWDendWithPad, mappedKSUnits, 'multiUnits') ;
    type1SWDs.SWD_MultiUnitsWithPad{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % clear loop variables just to be safe
    clear SWDstart SWDstartWithPad SWDend SWDendWithPad 
end



%% grab spikes that surround non-SWDs
for iSWD = 1:size(nonSWDs, 1)
    SWDstart = nonSWDs.SWD_startTime(iSWD)  ;
    SWDend = nonSWDs.SWD_troughTimes{iSWD}(end) ;
    SWDstartWithPad = SWDstart - seizurePad ;
    SWDendWithPad = SWDend + seizurePad ;

     % go through single units WITHOUT pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstart, SWDend, mappedKSUnits, 'singleUnits') ;
    nonSWDs.SWD_SingleUnits{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through multi units WITHOUT pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstart, SWDend, mappedKSUnits, 'multiUnits') ;
    nonSWDs.SWD_MultiUnits{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through single units WITH pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstartWithPad, SWDendWithPad, mappedKSUnits, 'singleUnits') ;
    nonSWDs.SWD_SingleUnitsWithPad{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % go through multi units WITH pad
    SWDspikeTable = findSWDassociatedSpikes(SWDstartWithPad, SWDendWithPad, mappedKSUnits, 'multiUnits') ;
    nonSWDs.SWD_MultiUnitsWithPad{iSWD} = SWDspikeTable ; clear SWDspikeTable ;

    % clear loop variables just to be safe
    clear SWDstart SWDstartWithPad SWDend SWDendWithPad 
end

