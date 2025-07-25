%%
mouseID = 36;
topDir = 'S:\intanData\ela\markTemp\';
load(sprintf('C:\\Ela_ESA\\00%d\\timevec.mat',mouseID),'timevec');

%%
rmLog = strcmp({curated_seizures.type},'3');    % find type 3s
curated_seizures(rmLog) = [];   
seizures = curated_seizures;
%%
for chi = 1:256
    ch_oneInd = chi;
    ESAfp = sprintf('C:\\Ela_ESA\\00%d\\ch%d.bin',mouseID,ch_oneInd);

    fid = fopen(ESAfp);
    ESA = fread(fid,'double');
    szESA{chi} = psr_ESAPhase(ESA,timevec,seizures);
end