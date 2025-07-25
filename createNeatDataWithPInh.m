function [neatDataWithPInh] = createNeatDataWithPInh(DataWithPInh,sortedNONSWDData,sortedData,rowOrder)
% parent function: orderAndPlotPhaseHeatmapsInh.m 

% next need to re-order DataWithP to make neatDataWithP where brain
% structures are ordered, non-normalized data is swaped for normalized etc. 

% INPUT: 
% sortedData - normalized phase for ordered brain structures - SWDs
% sortedNONSWDData - normalized phase for ordered brain structures - NON_SWDs 


% OUTPUT: 
% neatDataWithP - ordered, normalized, and no empty rows 

% order DataWithP(from the earliers to latest brain structure) 
neatDataWithPInh = DataWithPInh(rowOrder,:);

% substitute raw phases for normalized 
for iRow = 1:size(neatDataWithPInh,1)
    neatDataWithPInh{iRow,2} = sortedNONSWDData(iRow,:); % substitute NONSWD data
    neatDataWithPInh{iRow,3} = sortedData(iRow,:); % substitute SWDs data
end

end