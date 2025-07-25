function calculateMeanCoherence(COHR,numStructures,numSeizures,f,uniqueNames,mouseFolderPath)

fig = figure; 
numRows = 2; 

% prepare colors for the line plot 
blueShades = [linspace(0.2,0,numSeizures)', linspace(0.6,0,numSeizures)',linspace(1,0.5,numSeizures)']; 

for iStructure = 1:numStructures 
    subplot(numRows,numStructures,iStructure);  
    
        % plot all coherences on the top of each other 
        allCoherences = []; % prepare for storing coherences for each seizure 
        for iSeizure = 1:numSeizures 
            extractedCoherence = COHR{iStructure,iSeizure};
            if isnan(extractedCoherence(1,1))
                continue
            end
            plot(f, extractedCoherence,'Color',blueShades(iSeizure,:),'LineWidth',1); 
            xlim([0 50]);
            hold on 
            allCoherences = [allCoherences, extractedCoherence]; 
        % Add legend for different seizures
         %legend(arrayfun(@(x) sprintf('Seizure %d', x), 1:numSeizures, 'UniformOutput', false), 'Location', 'best');
    
        end 
        if isempty(allCoherences)
            continue
        end
        hold off 
        title(uniqueNames{iStructure}, "Interpreter","none"); 
        xlabel('Frequency in Hz');
        ylabel('Coherence'); 
       
    subplot(numRows,numStructures,iStructure+numStructures); % mean coherence 
        mCoherence = nanmean(allCoherences,2);  % calculate 
        plot(f,mCoherence,'LineWidth',3,'Color',"black"); 
        xlim([0 50]); 
        ylabel('Mean Coherence')
        xlabel('Frequency in Hz')
end

% Save the figure (as fig, .png, and .svg)
    % File names
    %figFileName = fullfile(mouseFolderPath, ['CoherenceVariabilityAcrossSeizures_' num2str(iSeizure) '.fig']);
    svgFileName = fullfile(mouseFolderPath, ['CoherenceVariabilityAcrossSeizures_' num2str(iSeizure) '.svg']);
    pngFileName = fullfile(mouseFolderPath, ['CoherenceVariabilityAcrossSeizures_' num2str(iSeizure) '.png']);
    % 
    %savefig(figFileName); % Save the figure in .fig format
    saveas(fig, svgFileName, 'svg');% Save the figure in .svg format
    print(fig, pngFileName, '-dpng', '-r600'); % '-r600' sets the resolution to 600 dpi% Save the figure in .png format
    % 
    close(fig);
    % Check if fig is a valid handle before closing
    if ishandle(fig)
        close(fig); % Close the figure
     end



end




 