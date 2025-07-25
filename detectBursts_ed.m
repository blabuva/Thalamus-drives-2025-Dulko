function detectBursts_ed(StructureDatabase, targetStructure, folderName)
% parent function: masterCodeInterBurstInterval.m 

% Important parameters
burstISIthreshold = 0.007; % 7 ms 
minSpikesInBurst = 3;

allIBIs = []; % IBIs for all neurons, all seizures in this brain structure 


for iRow = 1:size(StructureDatabase,1)

    singleUnits = StructureDatabase(iRow,"SingleUnitsSWD");
    singleUnits = singleUnits.SingleUnitsSWD{1,1}.all;

    if isempty(singleUnits) == 1 % if there is no SU, go to the next row (seizure)
        continue
    end

    % grab EEG for this seizure 
    [eeg,time,seizureStart,seizureEnd]= extractEEGandTimeForRow(StructureDatabase,iRow);
   
    %[IBIs] = calculateIBI(singleUnits,minSpikesInBurst,burstISIthreshold,iRow,folderName,targetStructure,eeg,time,seizureStart,seizureEnd); % detect bursts, calculate inter-burst interval 
    [IBIs] = calculateIBI_2(singleUnits, minSpikesInBurst, burstISIthreshold, iRow, folderName, targetStructure, eeg, time, seizureStart, seizureEnd);

    allIBIs{iRow,1} = IBIs; % store 

end 

%% Plot a histogram (not normalized) 
figure; 
% concatenate all values for easier plotting 
AbsolutelyAllIBIs = []; 
for iCell = 1:size(allIBIs,1)
    if isempty(allIBIs{iCell,1}) == 1
        continue % skip empty rows 
    end 
    values = allIBIs{iCell,1}; % extract values from this row 
    AbsolutelyAllIBIs = [AbsolutelyAllIBIs; values]; 
end 
edges = 0:0.02:max(AbsolutelyAllIBIs);   % Adjust bin size (e.g., 0.1s)
histogram(AbsolutelyAllIBIs, edges); 
xlabel('Interburst Interval (s)');
ylabel('Count');
title('Distribution of Interburst Intervals',targetStructure); 
%xlim([0,5]); 
close 

%% Plot a histogram (normalized) 
[counts, binEdges] = histcounts(AbsolutelyAllIBIs, edges); % Compute histogram
normalizedCounts = counts / max(counts); % Normalize so that max = 1
binCenters = binEdges(1:end-1) + diff(binEdges)/2; % Compute bin centers for plotting

% Plot
bar(binCenters, normalizedCounts, 'FaceColor', [0.4 0.4 0.8], 'EdgeColor', 'k');
xlabel('Inter-Burst Interval (s)');
ylabel('Normalized Count');
title('Normalized Histogram of Inter-Burst Intervals');
%xlim([0 max(AbsolutelyAllIBIs)]);
xlim([0,4]); % cut off at 4s 

% Build the filename
svgFileName = fullfile(folderName, ['%s_.svg', targetStructure '.svg']);
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

close % closes the figure after plotting

end % function end 

