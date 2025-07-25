function [allFields, heatmapLabels] = HeatmapCoherence(CoherenceMatrix, f, labelsBigTable, whatMice)
% parent function: StartHere.m

numRows = size(CoherenceMatrix,1); 
numColumns = size(CoherenceMatrix,2); 

allFields = []; 
heatmapLabels = []; 
for iRow =  1: numRows 
    for iColumn = 1:numColumns
        extractedField = CoherenceMatrix{iRow,iColumn};
        % if there is no data in this field skip to the next one 
        if isempty(extractedField)
            continue
        end 
       Name_1 = labelsBigTable{iRow}; % Get structure name (e.g., 'Basal_ganglia'
       Name_2 = whatMice{iColumn}; % Get mouse name (e.g., '0029') 
        
       % Combine the two names into one label
       NewLabel = [Name_1, ' - ', Name_2]; % Example: 'Basal_ganglia - 0029'
        
        % Add the new label to heatmap labels
        heatmapLabels = [heatmapLabels; {NewLabel}]; % Store as a cell array of strings
     
        allFields = [allFields, extractedField] ; 
    end
end 

figure; 
imagesc(allFields'); 
colormap("hot"); 
caxis([0 0.5]); 
colorbar; 
xlim([0 53]); 
xticks(1:53); 
xticklabels(f(1:53)); 
% Y axis labels 
yticks(1:length(heatmapLabels));  % Set the y-tick positions
set(gca, 'YTickLabel', heatmapLabels, 'TickLabelInterpreter', 'none');
%yticklabels(heatmapLabels);  % Apply the combined labels as y-axis labels
xlabel('Frequency in Hz'); 

end 