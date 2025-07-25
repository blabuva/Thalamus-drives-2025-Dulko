function [xMin, xMax] = findMinMaxSpikeTimes(singles, multis) 
% parent function: singleMultiSeizurePlot

% save('/home/mark/matlab_temp_variables/fmms')
% ccc
% load('/home/mark/matlab_temp_variables/fmms')

%% singles
jumper =1 ;
for iSingle = 1:size(singles,1)
    if ~isempty(singles.unitsPad{iSingle})
        theMinsSingles(jumper,1) = min(singles.unitsPad{iSingle}) ;
        theMaxsSingles(jumper,1) = max(singles.unitsPad{iSingle}) ;
        jumper = jumper + 1;
    end
end

%% multis
jumper = 1 ;
for iMulti = 1:size(multis,1)
    if ~isempty(multis.unitsPad{iMulti})
        theMinsMultis(jumper,1) = min(multis.unitsPad{iMulti}) ;
        theMaxsMultis(jumper,1) = max(multis.unitsPad{iMulti}) ;
        jumper = jumper +1 ;
    end
end

%%
if exist('theMinsSingles') == 0
    theMinsSingles = 0 ;
end

if exist('theMinsMultis') == 0
    theMinsMultis = 0 ;
end

if exist('theMaxsSingles') == 0
    theMaxsSingles = 0 ;
end

if exist('theMaxsMultis') == 0
    theMaxsMultis = 0 ;
end


%%
xMin = min([theMinsSingles; theMinsMultis]) ;
xMax = max([theMaxsSingles; theMaxsMultis]) ;






