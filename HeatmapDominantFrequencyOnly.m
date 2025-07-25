function [allFields, heatmapLabels] = HeatmapDominantFrequencyOnly(DominantFrequency, f, labelsBigTable, whatMice)

% parent function: StartHere.m 

numRows = size(DominantFrequency,1); 
numColumns = size(DominantFrequency,2); 

allFields = []; 
heatmapLabels = []; 
for iRow =  1: numRows 
    for iColumn = 1:numColumns
        extractedField = DominantFrequency(iRow,iColumn);
        % if there is no data in this field skip to the next one 
        if extractedField == 0
            continue
        end 
        
        [rowIdx,~] = find(f == extractedField); % find the frequency row that matches the dominant frequency 
        emptyVector = zeros(1,53); % make en empty vector 
        emptyVector(1,rowIdx) = 1; % mark the dominant frequency as "1", the rest will be zero 


       Name_1 = labelsBigTable{iRow}; % Get structure name (e.g., 'Basal_ganglia'
       Name_2 = whatMice{iColumn}; % Get mouse name (e.g., '0029') 
        
       % Combine the two names into one label
       NewLabel = [Name_1, ' - ', Name_2]; % Example: 'Basal_ganglia - 0029'
        
        % Add the new label to heatmap labels
        heatmapLabels = [heatmapLabels; {NewLabel}]; % Store as a cell array of strings
     
        allFields = [allFields; emptyVector] ; 
    end
end 

figure; 
imagesc(allFields); 
% colormap("hot"); 
% caxis([0 1]); 
% colorbar; 
xlim([0 32]); 
% xticks(1:53); 
% xticklabels(f(1:53)); 
% Y axis labels 
yticks(1:length(heatmapLabels));  % Set the y-tick positions
set(gca, 'YTickLabel', heatmapLabels, 'TickLabelInterpreter', 'none');
%yticklabels(heatmapLabels);  % Apply the combined labels as y-axis labels
xlabel('Frequency in Hz'); 

newXTickValues = 0:2.5:30; % 0 to 50 with 2.5 Hz step 
xticks(linspace(1, 32, length(newXTickValues))); % Set tick positions evenly
xticklabels(newXTickValues); % Label the ticks with 0, 2.5, 5, 7.5, ..., 50 Hz


% save the figure 
Path = '/media/elaX/Publications/Figures/Figure3_SpikeFieldCoherence'; 
svgFileName = fullfile(Path, ['DominantFrequencyOnly' '.svg']);        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format



end 