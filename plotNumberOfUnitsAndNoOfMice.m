function plotNumberOfUnitsAndNoOfMice(SingleUnits,SingleUnits_Stg)

% parent function: GetCurrentNoOfUnitsAndSeizures.m 

% IMPORTANT VARIABLE
minNoMice = 1; % brain structures rec-ed in less than X mice WILL NOT be plotted 


%% Clean the tables and sort based on the number of units 
% G R I A 
    % Get rid of "Dont Analyze"
        % Find rows where the first column (whatStructures) is 'DontAnalyze'
        rowsToDelete = strcmp(SingleUnits.whatStructures, 'DontAnalyze'); 
        % Delete those rows
        SingleUnits(rowsToDelete, :) = [];
    % Sort the Gria4 table based on the second column (neuronsPerStructure) in descending order
        SingleUnits = sortrows(SingleUnits, 'neuronsPerStructure', 'descend');
    % Delete brain structures that have less than min number of mice 
        DeleteDueToFewMice = SingleUnits.NumMice < minNoMice; % Find rows where NumMice is less than 2
    % Delete those rows
        SingleUnits(DeleteDueToFewMice, :) = []; 

    % clean before analyzing different mouse 
        rowsToDelete = []; 
        DeleteDueToFewMice = []; 



% S T A R G A Z E R 
    % Do the same for stargazer 
    % Get rid of "Dont Analyze"
        % Find rows where the first column (whatStructures) is 'DontAnalyze'
        rowsToDelete = strcmp(SingleUnits_Stg.whatStructures, 'DontAnalyze'); 
        % Delete those rows
        SingleUnits_Stg(rowsToDelete, :) = [];
    % Sort 
         SingleUnits_Stg = sortrows(SingleUnits_Stg, 'neuronsPerStructure', 'descend');
    % Delete brain structures that have less than 2 mice 
        DeleteDueToFewMice = SingleUnits_Stg.NumMice < minNoMice; % Find rows where NumMice is less than 2
    % Delete those rows
        SingleUnits_Stg(DeleteDueToFewMice, :) = []; 

%% Plot a bar graph 
figure; 
subplot(1,2,1); 
    % Create a colormap (you can choose any colormap you prefer)
    colors = parula(length(SingleUnits.whatStructures)); % 'lines' creates a set of distinguishable colors
    
    hBar = barh(SingleUnits.neuronsPerStructure); % plot a horizontal graph 
    
    % Set the colors for each bar
    hBar.FaceColor = 'flat';  % Allow flat color (individual bars to have different colors)
    hBar.CData = colors;      % Apply the color data to the bars
    
    % Add labels to the y-axis
    yticks(1:length(SingleUnits.whatStructures));
    yticklabels(SingleUnits.whatStructures);

    % Disable interpreter for y-axis tick labels
    ax = gca;  % Get the current axes
    ax.YAxis.TickLabelInterpreter = 'none';
    
    %  Add annotations (number of mice) for each bar
    for i = 1:length(SingleUnits.whatStructures)
        text(SingleUnits.NumMice(i) + 1, i, sprintf('%d', SingleUnits.NumMice(i)), 'VerticalAlignment', 'middle', ...
            'HorizontalAlignment','left');
    end
    xlabel('Number of single units'); 
    title('C3H/HeJ mouse'); 

% prepare Stargazer table for plotting 
    [reorderedStg] = prepareSTGtableForPlotting(SingleUnits,SingleUnits_Stg); % match the order of gria4 structures
    
subplot(1,2,2); 
    
    hBar = barh(reorderedStg.neuronsPerStructure); % plot a horizontal graph 
    
    % Set the colors for each bar
    hBar.FaceColor = 'flat';  % Allow flat color (individual bars to have different colors)
    hBar.CData = colors;      % Apply the color data to the bars
    
    % Add labels to the y-axis % NO NEED BECAUSE THERE ARE LABELS ALREADY

    yticks(1:length(reorderedStg.whatStructures));
    yticklabels(reorderedStg.whatStructures);
    
    % Disable interpreter for y-axis tick labels
    ax = gca;  % Get the current axes
    ax.YAxis.TickLabelInterpreter = 'none';

    %  Add annotations (number of mice) for each bar
    for i = 1:length(reorderedStg.whatStructures)
        text(reorderedStg.NumMice(i) + 1, i, sprintf('%d', reorderedStg.NumMice(i)), 'VerticalAlignment', 'middle', ...
            'HorizontalAlignment','left');
    end
    xlim([0 200]); % set the x axis limits
    xlabel('Number of single units'); 
    title('Stargazer mouse'); 

    % save the figure 
    figurePath = ('/media/elaX/MyFigures/NumberOfUnits/'); % where to save 
    svgFileName = fullfile(figurePath, ['NumberOfUnitsPerMouseModel_minNoMiceIs120250519' '.svg']);
    saveas(gcf, svgFileName, 'svg'); % Save the figure in .svg format

        



end








