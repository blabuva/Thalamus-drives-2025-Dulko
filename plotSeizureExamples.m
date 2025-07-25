function plotSeizureExamples(mouseData)

% parent function: calcSeizureFrequency.m 

Seizures = unique(mouseData.SeizureNumber);
numSeizures = length(Seizures); 

uniqueData = mouseData(1:numSeizures,:);

for iSeizure  = 1:size(uniqueData,1)
       
    % 12/18 for Gria 4 
        time = uniqueData.EEGwithTime{1,1}(300001:320001,1); 
        eeg = uniqueData.EEGwithTime{1,1}(300001:320001,2);  

    % 12/18 for Stargazer 
        time = uniqueData.EEGwithTime{1,1}(22760:44484,1); 
        eeg = uniqueData.EEGwithTime{1,1}(22760:44484,2);

    % time = uniqueData.EEGwithTime{iSeizure,1}(:,1); 
    % eeg = uniqueData.EEGwithTime{iSeizure,1}(:,2); 
    figure; % Plot raw  
        %plot(time,eeg, 'LineWidth',2,'Color',[0.5, 0, 0.5]); % for purple
        plot(time,eeg, 'LineWidth', 2,'Color','k'); % for black 
        %xlim([26 38]); 
    
    figure; 
    % plot smoothed
    plot(time,smooth(eeg,40), 'LineWidth', 2,'Color','k'); % for black 
    xlim([300 320]); 
    ylim([-10 10])
    figurePath = ('/media/elaX/Publications/Figures/Figure1_approach/newSeizureEx/');
    svgFileName = fullfile(figurePath, ['STGsm40_Seizure_' num2str(iSeizure) '.svg']); 
    saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

end 

end