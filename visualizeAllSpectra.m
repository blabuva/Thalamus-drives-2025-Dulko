function visualizeAllSpectra(numSeizures,f,numStructures,scaledHeight,SXX,SXY,SYY,COHR,mouseFolderPath) 
% INPUTS: 
% SXX - lfp spectrum 
% SYY - spike spectrum 
% SXY - cross (spike-lfp) spectrum 
% COHR -calculated coherence for each structure and each seiziure 

for iSeizure = 1:numSeizures 
    fig = figure('Units', 'centimeters', 'Position', [0, 0, 21, scaledHeight],'Visible','on');
    %titleText = sprintf('Seizure %d', iSeizure);
    %sgtitle(titleText); % Set the title for the entire figure

    for iStructure = 1:numStructures 
        subplot(numStructures,4,(4*iStructure)-3); % LFP SPECTRUM 
            lfpSpectrum = SXX{1,iSeizure} ;        
            plot(f, lfpSpectrum,"red",'LineWidth',1.5) ;
            xlabel('Frequency (Hz)');
            ylabel('Power mV^2/Hz');
            xlim([0 50]);  % Limit frequency axis to 0-50 Hz
            title('LFP Spectrum');
            xline(5,"green")    
    

        subplot(numStructures,4,(4*iStructure)-2); % SPIKE SPECTRUM 
            SpikeSpectrum = SYY{iStructure,iSeizure} ;        
            plot(f, SpikeSpectrum, "blue", 'LineWidth',1.5) ;
            xlabel('Frequency (Hz)');
            ylabel('Power mV^2/Hz'); 
            xlim([0 50]);  % Limit frequency axis to 0-50 Hz
            title('Spike Spectrum');
            xline(5,"green")   



        subplot(numStructures,4,(4*iStructure)-1); % CROSS SPECTRUM 
            MeanCrossSpec = SXY{iStructure,iSeizure} ; 
            plot(f, abs(mean(MeanCrossSpec,1)),"magenta",'LineWidth',1.5) ;
            xlabel('Frequency (Hz)');
            ylabel('Power (mV^2/Hz)^2');
            xlim([0 50]);  % Limit frequency axis to 0-50 Hz
            title('Cross Spectrum');
            xline(5,"green")   


        subplot(numStructures,4,(4*iStructure)); % PLOT COHERENCE  
            coherence = COHR{iStructure,iSeizure}; 
            plot(f,coherence,"black", 'LineWidth',2); 
            xlim([0 50]);   
            title('Coherence'); 
    end 
    % Save the figure for each seizure (as fig, .png, and .svg)
    % File names
    %figFileName = fullfile(mouseFolderPath, ['Spectra_' num2str(iSeizure) '.fig']);
    %svgFileName = fullfile(mouseFolderPath, ['Spectra_' num2str(iSeizure) '.svg']);
    pngFileName = fullfile(mouseFolderPath, ['CoherenceElements_' num2str(iSeizure) '.png']);
    % 
    %savefig(figFileName); % Save the figure in .fig format
    %saveas(fig, svgFileName, 'svg');% Save the figure in .svg format
    print(fig, pngFileName, '-dpng', '-r600'); % '-r600' sets the resolution to 600 dpi% Save the figure in .png format
    % 
    close(fig);
    % Check if fig is a valid handle before closing
    if ishandle(fig)
        close(fig); % Close the figure
     end

end 


end

