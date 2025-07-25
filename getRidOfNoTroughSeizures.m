function cleanSeizures = getRidOfNoTroughSeizures(seizures)

% save('/media/shareX/tempMat')
% ccc
% load('/media/shareX/tempMat')

%% extract troughs
for iSeizure = 1:size(seizures,2)
    troughs = seizures(iSeizure).trVals ;
    if ~isempty(troughs)
        allTroughs(iSeizure,1) = size(troughs,1);
    else
        allTroughs(iSeizure,1) = 0 ;
    end
end

%% find non-zeros
realSeizureIDX = find(allTroughs >0) ;

%% get rid of non-trough seizures
cleanSeizures = seizures(realSeizureIDX) ;
