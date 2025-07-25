function [pkVals, pkIDX, ptVals] = findHSE(pp, ptile)
%% findHSE Finds highly synchronous events (HSE)
% HSE are events wherein a large proportion of neurons fire within a brief time window
%
% INPUTS:
%   pp - proportion of population array. Either vector or matrix. Dim2 is always time.
%        If matrix, every row is different structure/nucleus.
%   ptile - scalar. Percentile threshold value, over which, events are flagged as potential HSE (default = 99)
%
% OUTPUTS:
%   pkVals - cell array. peak values in each cell
%   pkIDX - cell array. peak indices in each cell
%   ptVals - vector. actual value used for percentile-based thresholding
%
% Written by Scott Kilianski
% Updated on 2024-10-31
% ------------------------------------------------------------ %
%% ---- Function Body Here ---- %%%
% -- Handle Inputs -- %
if ~exist('ptile', 'var')
    ptile = 99;
end
fprintf('Using %.2f%% as percentile threshold for HSE\n',ptile);
MPD = 50; % minimum peak distance in # samples

%% --- Find Highly Synchronous Events (HSEs) -- %%
pkVals = cell(1,size(pp,1));
pkIDX = cell(1,size(pp,1));
for ppi = 1:size(pp,1)
    inpVec = pp(ppi,:);
    ptv = prctile(inpVec,ptile);
    ptVals(ppi) = ptv;
    [pkVals{ppi}, pkIDX{ppi}] =  findpeaks(inpVec,...
        'MinPeakHeight',ptv,...
        'MinPeakDistance',MPD);
end

end % function end


