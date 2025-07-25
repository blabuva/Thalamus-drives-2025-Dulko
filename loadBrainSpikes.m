%%
ccc

%% load spike data
load('/media/markX/ela0024_brainSpikes')

%% get user-defined pad
timePad = experimentInfo.spikeDetectionParams.seizurePad ;

%% get brain structures
brainFields = fieldnames(brainSpikes) ;

%% loop through brain structures
for iBrain = 1:size(brainFields,1)
    for iSWD = 1:size(brainSpikes.(brainFields{iBrain}).SWD,2)
        currentSWD = brainSpikes.(brainFields{iBrain}).SWD{iSWD} ;
        analyzedSpikes = analyzedBrainSpikes(currentSWD, timePad) ;
        clear currentSWD
    end

end

