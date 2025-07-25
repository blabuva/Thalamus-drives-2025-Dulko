function [neatDataWithPExc] = createNeatDataWithPExc(DataWithPExc,sortedNONSWDData,sortedData,rowOrder)
% parent function: orderAndPlotPhaseHeatmapsExc.m 

% next need to re-order DataWithP to make neatDataWithP where brain
% structures are ordered, non-normalized data is swaped for normalized etc. 

% INPUT: 
% sortedData - normalized phase for ordered brain structures - SWDs
% sortedNONSWDData - normalized phase for ordered brain structures - NON_SWDs 


% OUTPUT: 
% neatDataWithP - ordered, normalized, and no empty rows 

% order DataWithP(from the earliers to latest brain structure) 
neatDataWithPExc = DataWithPExc(rowOrder,:);

% substitute raw phases for normalized 
for iRow = 1:size(neatDataWithPExc,1)
    neatDataWithPExc{iRow,2} = sortedNONSWDData(iRow,:); % substitute NONSWD data
    neatDataWithPExc{iRow,3} = sortedData(iRow,:); % substitute SWDs data
end

end