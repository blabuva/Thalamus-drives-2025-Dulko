%% Sample script to detect/curate seizures and output the times of the 1st trough of each seizure (an estimate of the seizure start time)
ccc ;

%% define general path to all of Ela's data
%uberDir = '/media/elaX/intanData/ela/markTemp/' ;

uberDir = '/media/probe2X/intanData/' ;
%uberDir = '/media/ela2X/ETX';
%% get first rhd file:
theDir = uigetdir(uberDir, ['Select Experiment Directory to Analyze']) ;
rhdDir = sprintf('%s/rawData', theDir) ;
rhdFiles = dir(sprintf('%s/*.rhd', rhdDir)) ;
filename = fullfile(rhdDir, rhdFiles(1).name) ;

%% query for some params
prompt = {'Enter EEG Channel Number:','Enter Target Sampling Freq (Hz):','Enter Max Duration Between 2 Seizures (s)'};
dlgtitle = 'Gimme Some Info';
dims = [1 35];
definput = {'1','1000','1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

ec = str2num(answer{1});                                             % EEG channel (usually channel 1, but that could change)
tfs = str2num(answer{2});                                          % target sampling frequency (100Hz should be sufficient)
pzit = str2num(answer{3}) ;                                           % gap length under which to merge (seconds)

%% automatic seizure detection (first pass)
%seizures = findSeizuresScott_mark('filename',filename,...
%     'eegChannel',ec,'targetFS',tfs,'pzit',pzit); % automatically detects seizures based primarily on LFP power in certain freq band (default 4-8Hz)
ttv = 2.5;
seizures = findSeizuresScott_mark('filename',filename,...
   'eegChannel',ec,'targetFS',tfs,'pzit',pzit,'ttv',ttv);                % automatically detects seizures based primarily on LFP power in certain freq band (default 4-8Hz)

%% get rid of no-trough seizures
seizures = getRidOfNoTroughSeizures(seizures) ;

%% try to reduce duplicated troughs
seizures = noTroughDupes(seizures) ;
 
%% Manual curation step
curated_seizures = curateSeizures_mark(seizures);        % manually curate seizures
save('/home/Matlab/elas_Functions/matlab_temp_variables/curateSeizures')

%% Each element of firstTroughTimes is the time of the first trough of a detect seizure
%  The units of firstTroughTimes are in seconds from the very beginning of the recording
firstTroughTimes = [];
for si = 1:numel(curated_seizures)
    if isempty(curated_seizures(si).trTimeInds)
        continue
    else
        ftt = curated_seizures(si).time(curated_seizures(si).trTimeInds(1));
        firstTroughTimes = [firstTroughTimes;ftt];
    end
end

%% find real start times (first big inflection point where EEG starts dive to trough)
curated_seizures = findRealSeizureStartFromScott(curated_seizures) ;

%% save curated seizures
saveDir = sprintf('%s/detectedSeizures/', theDir) ;
mkdir(saveDir) ;
[xx, exptName] = fileparts(theDir) ;
saveFileName = sprintf('%s%s_detectedSeizures_S1_002', saveDir, exptName) ;
%saveFileName = sprintf('%s%s_detectedSeizures002', saveDir, exptName) ;
save(saveFileName, 'curated_seizures') ;

