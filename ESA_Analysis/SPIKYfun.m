function SPIKYfun(topDir)

% --- SPIKY Loop --- %
scriptClock = tic;
% Script to loop through Ela's data and run SPIKY and store outputs

%% -- Load in all the relevant data -- %
% --- Loading spike times, neuron locations, seizure times --- %
% topDir = '\\172.28.76.244\probeX\intanData\ela\markTemp\0022';
[ssArray, neuronChans] = psr_makeSpikeArray([topDir '\analyzedData']);
load([topDir '\anatomyData\electrodeLocations.mat'],'electrodeLocations'); % load the 'electrodeLocations' list
nbr = electrodeLocations(neuronChans+1,2); % neuron brain region(+1 to account for 0-indexing of probes)
dd = dir([topDir '\detectedSeizures']); % detected seizures directory
szFileInd = find(contains({dd.name},'detectedSeizures'),1,'first'); % find the first detectedSeizures.mat file
szFile = fullfile(dd(szFileInd).folder, dd(szFileInd).name);
load(szFile,'curated_seizures');

%%
% --- Remove WHICH TYPES of seizures??? types 1 2 3??? --- %
preSZwin = 5; % HOW BIG SHOULD THIS PRE-SEIZURE WINDOW BEEEE??
rmLog = strcmp({curated_seizures.type},'3');
curated_seizures(rmLog) = []; % remove type 3s
% --- tlimList:
% D1 - number of seizures
% D2 - start and end
% D3 - 1 is actual seizure. 2 is pre-seizure
% ------- %

tlimList = nan(numel(curated_seizures),2,2); % initialize time limit matrix
for szi = 1:numel(curated_seizures)
    szStart = curated_seizures(szi).time(curated_seizures(szi).trTimeInds(1)); % seizure start time
    szEnd = curated_seizures(szi).time(curated_seizures(szi).trTimeInds(end)); % seizure end time
    tlimList(szi,1,1) = szStart;
    tlimList(szi,2,1) = szEnd;
    tlimList(szi,1,2) = szStart - preSZwin; % this will produce error later if it ends up being < 0
    tlimList(szi,2,2) = szEnd - preSZwin; % this will produce error later if it ends up being < 0
end
%%
% -- Remove neurons from brain regions with < N neurons -- %
N = 2; % minimum number of neurons needed for SPIKY analysis below
cats = categorical(nbr); % assign brain region to each neuron
brNames = categories(cats); % get names of all the unique brain regions
tlrLog = countcats(cats)<N; % find if any region has <N neurons
tlrNames = brNames(tlrLog); % get the names of those too-low-count regions
brNames(tlrLog) = []; % remove those brain regions from the list
tlnLog = ismember(cats,tlrNames); % find the neurons that below to those regions
ssArray(tlnLog) = []; % remove corresponding neurons from the Spike Array
nbr(tlnLog) = []; % remove the neuron brain region name

%%
allspk = {}; % initialize dataset structure

% -- Assign neurons to brain region -- %
% Make brain region/structure list

% -- Get seizure and non-seizure starts/ends -- %
% Put them in 'tlimList' which is n x 2 matrix with start and end times of epochs
% HOW DO I DO THIS? %

% -- Loop through SPIKY function -- %
totLoops = numel(brNames) * size(tlimList,1);
nL = 0; % loop number
for sti = 1:numel(brNames)   % loop through brain structures
    spk = {}; % initialize structure to store data
    psuedo_spk = {};
    cLog = strcmp(nbr,brNames(sti)); % indices to neurons in current brain structure/region
    for ti = 1:size(tlimList,1) % loop through the time epochs
        nL = nL + 1;
        spikeArray = ssArray(cLog);
        tlim = tlimList(ti,:,1);
        prelim = tlimList(ti,:,2);
        spk{ti}= elaSpiky(spikeArray, tlim); % run SPIKY on current data
        psuedo_spk{ti} = elaSpiky(spikeArray, prelim); % run SPIKY on pre-seizure data
        fprintf('%.2f%% complete\n',nL/totLoops*100)
    end
    allspk{sti,1} = brNames(sti);
    allspk{sti,2} = spk;
    allspk{sti,3} = psuedo_spk;
end

saveName = sprintf('%s\\analyzedData\\SPIKYoutput.mat',topDir);
save(saveName,'allspk','-v7.3');
fprintf('SPIKYfun took %.2f minutes to run\n',toc(scriptClock)/60);

% allspk Col1 is structure name
% Col2 is the actually SPIKY output
% Col3 is SPIKY output taken from the control (pre-seizure) period

end