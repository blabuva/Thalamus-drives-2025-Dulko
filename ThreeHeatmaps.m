function VisualizeAllCorrelationsAsHeatmap(CorrelationsDuringSWSs,combinations)  
numColumns = 120; 
CorrelationsCombinedBig = []; 
CorrelationsCombined = zeros(1,numColumns); % random numbers just for now 
LabelsBigHeatmap = [];

count = 0; % start counting the iterations for 
%%
% loop through all rows (all combinations) 
for iCombination = 1:size(CorrelationsDuringSWSs,1)
    CombinationRow = []; 
    % check if there is a situation where all fields are empty, if yes skip
    AllEmpty = all(cellfun(@isempty, CorrelationsDuringSWSs(iCombination,:)));  % Check if all cells are empty 
        
    if AllEmpty ==1 
       continue 
    end

    isempty(CorrelationsDuringSWSs(iCombination,:))
    for iAnimal = 1:size(CorrelationsDuringSWSs,2)
        AnimalField = CorrelationsDuringSWSs{iCombination,iAnimal}; 
        if isempty(AnimalField) % if it's empty, skip this field and dont worry about it 
            continue
        end
        % if not empty: 
        CombinationRow = [CombinationRow,AnimalField]; % store data
    end
    % but also store the brain structure names 
            count = count + 1; 
            % what is the combination for this data?? 
            structure1 = combinations{iCombination,1}; % structure 1
            structure2 = combinations{iCombination,2}; % structure 2 
            
            LabelsBigHeatmap{count,1} =  structure1; 
            LabelsBigHeatmap{count,2} = structure2; 


    % append the CombinationRow to CorrelationsCombined (need to match the
    % size first)
    ResizedCombinationRow = zeros(1,numColumns); 
    ResizedCombinationRow(1:size(CombinationRow,2)) = CombinationRow;
    CorrelationsCombined(1,:) = ResizedCombinationRow; 

    % append to CorrelationCombinedBig 
    CorrelationsCombinedBig = [CorrelationsCombinedBig; CorrelationsCombined]; 



end
%%     
    % Plot unsorted heatmap - uncomment if you want this 
        % figure; heatmap(CorrelationsCombinedBig); colormap(hot);
        % title('All interactions - unsorted')
        % % Add labels 
        % % Prepare Y axis labels for the heatmap: 
        YLabels = strcat(LabelsBigHeatmap(:, 1), ' - ', LabelsBigHeatmap(:, 2));
        % ax = gca; % Get current axes
        % ax.YDisplayLabels = YLabels; % Assign Y-axis labels

        % Sort 
        [CorrelationsCombinedBigSorted,YLabelsSorted] = sortBasedOnHighestMean(CorrelationsCombinedBig,YLabels); 

            % rowMeans = nanmean(CorrelationsCombinedBig, 2); % Calculate the mean of each row
            % [~, sortIdx] = sort(rowMeans, 'descend'); % Sort the rows by their mean values in descending order
            % 
            % % Rearrange the data and labels based on the sorted indices
            % CorrelationsCombinedBigSorted = CorrelationsCombinedBig(sortIdx, :);
            % YLabelsSorted = YLabels(sortIdx);
    
        % Plot sorted heatmap
        figure; 
        title('All interactions - sorted based on the mean corr')
        h = heatmap(CorrelationsCombinedBigSorted); 
        h.Colormap = hot;
        h.ColorLimits = [0 1]; % Set the color limits to the range [0, 1]
        xlabel(h, 'Seizure event'); % Use the xlabel function for the heatmap 
        
        % Add the sorted Y-axis labels 
       h.YDisplayLabels = YLabelsSorted; % Assign sorted Y-axis labels

   % Plot only interaction that have a high mean     
        % % Filter rows with mean >= 0.2
        % validIdx = rowMeans >= 0.02; % Logical index of rows that meet the condition
        % CorrelationsCombinedBigFiltered = CorrelationsCombinedBig(validIdx, :);
        % YLabelsFiltered = YLabels(validIdx);
        % 
        % % Sort the remaining rows by their mean values in descending order
        % [~, sortIdx] = sort(rowMeans(validIdx), 'descend');
        % CorrelationsCombinedBigSorted = CorrelationsCombinedBigFiltered(sortIdx, :);
        % YLabelsSorted = YLabelsFiltered(sortIdx);
        % 
        % % Plot sorted and filtered heatmap
        % figure; 
        % title('Interactions with mean corr higher than 0.02')
        % h = heatmap(CorrelationsCombinedBigSorted);
        % colormap(jet); % Get the default jet colormap
        % 
        % % Add sorted Y-axis labels
        % ax = gca; % Get current axes
        % ax.YDisplayLabels = YLabelsSorted; % Assign sorted Y-axis labels


end 


