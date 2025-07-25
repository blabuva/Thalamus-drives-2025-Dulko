%%
clear all; close all; clc
topDir = 'S:\intanData\ela\markTemp\';
% mouseList = [22,23,24,25,26,27,29,30,...
%     31,32,33,34,35,36,37,38,39,40,41,42,...
%     43,46,50,51,52,66,68];
mouseList = [28,50,51,52];
pdfBase = 'C:\Users\Scott\Documents\ElaAnalysis\Figures\ESA_AutoCorr+PETH\';

for mi = 1:numel(mouseList)
    mouseID = mouseList(mi);
    mouseStatus(mi,1) = false;
    try 
        ela_ESAX(mouseID,topDir,pdfBase);
    catch
        continue
    end
    mouseStatus(mi,1) = true;
end
