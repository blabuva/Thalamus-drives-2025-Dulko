%%
clear all; close all; clc
mouseList = [38 39 40 41 42 43 44 45 46 50 51 52 65 66 68];
for mi = mouseList
    topDir = sprintf('\\\\172.28.76.244\\probex\\intanData\\ela\\markTemp\\00%d',mi);
    fprintf('Running SPIKY loop on %s\n',topDir)
    try 
        SPIKYfun(topDir);
        fprintf('Mouse 00%d complete\n',mi)
    catch
        fprintf('Mouse 00%d failed, moving to next dataset\n',mi)
    end
end