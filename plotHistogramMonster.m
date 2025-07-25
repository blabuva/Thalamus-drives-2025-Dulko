function [RATIOS,Valleys,Peaks] = plotHistogramMonster(numStr,MeansAllMice,labelsBigTable)
% parent function: Phase_ela.m 

% VERY IMPORTANT LINES OF CODE: 15 and 16 

RATIOS = [];
Valleys = []; 
Peaks = []; 

fig = figure('Units', 'centimeters', 'Position', [0,0,21,29.7]);
for iStructure=1:numStr
    currentRow = MeansAllMice(iStructure,:); 
    subplot(numStr,1,iStructure); 
    bar(currentRow);
    hold on; 
    % smooth data and plot smoothed as red line on the top of the histogram
    winSize = 6;
    smoothed = smoothdata(currentRow,'gaussian',winSize); 
    % P E A K 
        % FOR SEIZURE START 
        %Peak = max(smoothed(1,150:260)); % find the highest value of smoothed
        Peak = max(smoothed(1,1:100)); 
        Peaks(iStructure) = Peak; % store 
    % V A L L E Y
        % FOR SEIZURE START 
        %Valley = min(smoothed(1,150:260)); % find the lowest value of smoothed 
        Valley = min(smoothed(1,1:100)); 


        % is valley zero???? 
        if Valley == 0
            Valley = 1; % Adjust Valley to avoid division by zero
        end
        Valleys(iStructure) = Valley; 

    Ratio = Peak/Valley; % calculate the ratio
    RATIOS(iStructure,1) = Ratio; % store 
    plot(smoothed,'r','LineWidth',2);
    % display the ratio 
    title(['Peak to valley ratio: ', num2str(Ratio)]);  
    xlabel('Bins)');
    ylabel('Mean Spike Count');
    % set the title for each brain structure 
    extractedTitle = labelsBigTable(iStructure); 
    titleText = [num2str(extractedTitle{1,1})]; % set the title of the raster as name of brain structure  
    xLimits = xlim; 
    yLimits = ylim; 
    text(xLimits(2) + 1, mean(yLimits), titleText, 'Rotation', 0, 'HorizontalAlignment', 'left');
end 
end