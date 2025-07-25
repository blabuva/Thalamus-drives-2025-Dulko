function [Tr,sortedDataTable] = establishTheThreshold(labelsBigTable,RATIOS,Valleys,Peaks)
% parent function: Phase_ela.m

% important: 
% establish the threshold (grab only 60% of top ratios) 
perc = 0.6; % eg 60% 
PeakCutOff = 5; % if there is less than 5 spikes (peak) it will be classified as NotLocked regardgless of the ratio 

%% Sort ratios from highest to lowest, then sort peaks, valleys, names
% accordingly 
[sortedRatios, sortIdx] = sort(RATIOS, 'descend'); % sort descending 

% find the threshold that will separate 60% (high) vs 40% (low) 
% perc = 0.6 means top 60 % of values 
Tr = sortedRatios(round(perc * length(sortedRatios))); 

sortedLabelsBigTable = labelsBigTable(sortIdx); % sort names as well 
sortedPeaks = Peaks(sortIdx); % sort Peaks 
sortedValleys = Valleys(sortIdx); % sort valleys 

% Clasiffy structure as "Locked" or "NonLocked" depending on the ratio 
LockStatus = repmat("NotLocked", length(sortedRatios), 1);  % default
LockStatus(sortedRatios >= Tr) = "Locked"; % Create the table

% take into account the peak value as well (PeakCutOff)
for iRow = 1:size(LockStatus,1)
    if sortedPeaks(iRow) <= PeakCutOff  
        LockStatus(iRow) = "NotLocked"; 
    else
        continue 
    end
end 

% error for Stg so I transposed these 
%sortedRatios = sortedRatios'; 
%LockStatus = LockStatus'; 
%sortedLabelsBigTable = sortedLabelsBigTable';
sortedPeaks = sortedPeaks'; 
sortedValleys = sortedValleys'; 

sortedDataTable = table( ...
    sortedLabelsBigTable, ...
    sortedPeaks, ...
    sortedValleys, ...
    sortedRatios, ...
    LockStatus, ...
    'VariableNames', {'Label', 'Peak', 'Valley', 'Ratio', 'LockStatus'});

%% Visualize as a dot plot 
figure; 
for iRow = 1:size(sortedDataTable,1)
    x = sortedDataTable(iRow,"Valley").(1); 
    y = sortedDataTable(iRow,"Peak").(1); 
    name = sortedDataTable(iRow,"Label").(1); 
    status = sortedDataTable(iRow,"LockStatus"); 
    if strcmp(status.(1), "Locked") == 1

        color = 'r'; % red for locked 
    else
        color = 'k'; % black for non locked 
    end

    scatter(x,y,'filled','MarkerFaceColor',color); 
    text(x-0.1,y+0.1,name{1,1}); 
    hold on 

end 

hold off
xlabel('Valley'); 
ylabel('Peak'); 


end % function end 



