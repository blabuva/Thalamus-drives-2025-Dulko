function [seizureOrdered,zScoresSeizure,percentValid] = calcZscores_12_02(allNeuronsOneStructureNonS,allCountsSeizure,sumNeurons,sumSeizures,folderName,whatStructures,iStructure)
% parent function: MasterFunctionZscore.m 
% Function below will separate trials based on the z-scores during
% seizrues. If they are significant they will be classified as such. 
  % IMPORTANT values (z score range) 
    lowerZscore = -2; 
    higherZscore = 2; 


% Step 1: concatenate data 
    numNeurons = size(allNeuronsOneStructureNonS,1); 
    baseline = [];
    for iRow = 1:numNeurons
        oneRow = allNeuronsOneStructureNonS{iRow,:};
        baseline = [baseline; oneRow]; % concatenate to make plotting easier
    end
    
    seizure = [];
    for iRow = 1:numNeurons
        oneRow = allCountsSeizure{iRow,:};
        seizure = [seizure; oneRow]; % concatenate to make plotting easier
    end

% Step 2: calculate z-scores 
    meanBaseline = mean(baseline,2); % Mean firing rate for each neuron (row) 
    stdBaseline = std(baseline, 0, 2); % Standard deviation for each neuron (row)

    % Compute z-scores for seizure
    zScoresSeizure = (seizure - meanBaseline) ./ stdBaseline; 
    % NOTE: If a neuron doesnt' fire during baseline, so mean = 0. the z
    % score will be NaN 

% Step 3: check which trials are valid (have Z score > 2 or <-2) 
  
    % Check which neurons are seizure modulated (have a significant z score) 
    % focus on the seizure bins only, for now hardcoded (bins 20-24) 

    numTrials = size(zScoresSeizure,1); 

    trialLog = zeros(numTrials,1);  % make empty log
        for iTrial = 1:numTrials 
            oneTrial = zScoresSeizure(iTrial,:); 
            seizureBin1 = 20; % when does the seizure start
            seizureBinLast = 24; % when does the seizure end 
            extractedZscores = oneTrial(seizureBin1:seizureBinLast); 
                % Check if any Z-scores are greater than 2 or smaller than
                % -2
                if any(extractedZscores > higherZscore | extractedZscores < lowerZscore)
                    trialLog(iTrial,1) = 1;
                else
                    trialLog(iTrial,1) = 0;
                end
        
        end 

    trialLog = logical(trialLog);

% Step 4: store valid trials separately from the non valid ones 
seizureValid = zScoresSeizure(trialLog,:); % store valid trials 
seizureNotValid = zScoresSeizure(~trialLog,:); % store non-valid trials, ~ makes the function keep the "false" values
    
% Step 5: calculate how many trials were valid 
    numValid = size(seizureValid,1); % how many valid 
    numNotValid = size(seizureNotValid,1); % how many NOT valid 
    total = numValid + numNotValid; 
    percentValid = numValid/total*100; % calculate percentage of valid trials 

% Step 6: Plot seizureValid and NotValid separately: 
fig = figure; 
% Set the figure properties
set(gcf, 'PaperUnits', 'centimeters');       % Use centimeters for paper size
set(gcf, 'PaperSize', [29.7, 21.0]);        % A4 paper size in cm (landscape: width x height)
set(gcf, 'PaperPosition', [0, 0, 29.7, 21.0]); % Fill the whole A4 page

    subplot(1,2,1); % Not modulated by the seizure (plot order as it is) 
        imagesc(seizureNotValid); 
        cb = colorbar; 
        ylabel(cb,'Firing rate (z-score)','FontSize',16,'Rotation',270)
        caxis([-2 2]);
        xline(19.5,'w','LineWidth',2); % mark the beggining of the non-seizure
        title('Trials NOT modulated by the seizure');

    subplot(1,2,2); % Modulated by the seizure (order by the peak) 
        % Identify the column index of the peak firing for each row
        [~, peakCol] = max(seizureValid, [], 2); % Get the column index of the maximum value for each row
        % Sort the rows based on the column index of the peak firing
        [~, sortOrder] = sort(peakCol); % Determine the order to sort rows
        % Reorder the seizure and baseline variables
        seizureOrdered = seizureValid(sortOrder, :);
        imagesc(seizureOrdered); 
        cb = colorbar; 
        ylabel(cb,'Firing rate (z-score)','FontSize',12,'Rotation',270)
        caxis([-2 2]);
        title('Trials modulated by the seizure');
        xline(19.5,'w','LineWidth',2); % mark the beggining of the seizure 

% Add text to the bottom-left corner (number of neurons (total) and
% seizures (total) to get a sense of how much info goes into the figure
annotationText = sprintf('N: %d, S: %d', sumNeurons, sumSeizures); % Create the text string
annotation('textbox', [0.01, 0.01, 0.3, 0.05], ... % Position [x y width height]
           'String', annotationText, ...          % Text content
           'EdgeColor', 'none', ...               % No border
           'HorizontalAlignment', 'left', ...     % Align text to the left
           'FontSize', 10);                       % Adjust font size

%% save the figure 
titleText = sprintf(whatStructures{iStructure}); 
% Save figures in the newly created folder
     
    % File names
    figFileName = fullfile(folderName, ['Z-score' titleText '.fig']);
    svgFileName = fullfile(folderName, ['AES_' '.svg']);
    pngFileName = fullfile(folderName, ['Z-score' titleText '.png']);

    savefig(figFileName); % Save the figure in .fig format
    saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format
    print(gcf, pngFileName, '-dpng', '-r600'); % '-r600' sets the resolution to 600 dpi% Save the figure in .png format

    % Check if fig is a valid handle before closing
        if ishandle(fig)
            close(fig); % Close the figure
        end


end