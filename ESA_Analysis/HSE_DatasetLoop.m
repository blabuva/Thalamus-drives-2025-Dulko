%%
clear all; close all; clc
BigHSE = {};
mid = [22, 23, 24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,50,51,52,65,66,68];

%%
for di = 1:numel(mid)
    keep mid di BigHSE
    pathToData = sprintf('\\\\172.28.76.244\\probeX\\intanData\\ela\\markTemp\\00%d\\',mid(di));
    fprintf('Running dataset: %s\n',pathToData);
    try
        popSynchAnalysis;
        mouseCell = repmat({mid(di)},size(HSE,2),1);
        BigHSE = [BigHSE; mouseCell, [{HSE.name}', {HSE.ic}',{HSE.ni}', {HSE.nc}', {HSE.bhat_dist}']];
    catch
        warning('Skipping MOUSE %d',mid(di));
    end
end