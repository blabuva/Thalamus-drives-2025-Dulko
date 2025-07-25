%%
topDir = 'S:\intanData\ela\markTemp\00';
MID = [28; 50; 51; 52];
for mi = 1:numel(MID)
    mouseID = MID(mi);
    pathToData = sprintf('%s%d\\rawData',topDir, mouseID);
    psr_convertRHDtoBIN(pathToData);
end
%%
topDir = 'S:\intanData\ela\markTemp\00';
% datFile = '\rawData\combined.bin';
MID = [28; 50; 51; 52];
nc = [256,128,128,64];
for mi = 1:numel(MID)
    mouseID = MID(mi);
    numChans = nc(mi);
    pathToData = sprintf('%s%d',topDir, mouseID);
    outpath = sprintf('C:\\Ela_ESA\\00%d',mouseID);
    computeESA(pathToData,outpath,numChans);
end