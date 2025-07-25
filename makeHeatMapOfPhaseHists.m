function normHistsRotateCentered = makeHeatMapOfPhaseHists(reOrderedHistTable) 
%parent function: extracAndPlotPhaseFromDataBase.m

% %%
% save('/home/mark/matlab_temp_variables/phaseHEETER')
% ccc
% load('/home/mark/matlab_temp_variables/phaseHEETER')

%%
for iHist = 1:size(reOrderedHistTable,1)
    if isempty(reOrderedHistTable.Histogram{iHist}) == 0
        allHists(:,iHist) = reOrderedHistTable.LumpedHistogram{iHist} ;
        normHists(:, iHist) = smooth(allHists(:, iHist)/ max(allHists(:, iHist)), 5) ;
    else
        allHists(:, iHist) = zeros(1,200) ;
        normHists(:, iHist) = zeros(1,200) ;
    end
end

%% rotate and flip the normalized histogram
normHistsRotate = flipud(rot90(normHists)) ;

%% take just the center portion of normHistsRotate
normHistsRotateCentered = normHistsRotate(:, 51:150) ;
