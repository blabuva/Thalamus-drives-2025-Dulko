function plotAllFeatures(seizureData)

% parent function: SeizureFeaturesMaster_2024_08_29.m  

% Features to compare
features = {'avgNumberSeizures', 'avgDuration', 'avgCycleDuration', 'AvgNumCycles'};
titles = {'Number of Seizures / Min', 'Seizure Duration', 'Cycle Duration', 'Number of Cycles'};
mouseModels = {'Gria4', 'Stargazer'};

% Prepare the figure
figure;
set(gcf, 'Position', [100, 100, 1200, 300]); % Resize figure for better layout

for iFeature = 1:numel(features)
    % Extract data for both mouse models
    dataGria4 = seizureData.Gria4.(features{iFeature});
    dataStargazer = seizureData.Stargazer.(features{iFeature});
    
    % Calculate means
    meanGria4 = mean(dataGria4);
    meanStargazer = mean(dataStargazer);
    
    % Create subplot
    subplot(1, 4, iFeature);
    
    % Bar and scatter positions: 
    xGria4 = 1; 
    xSTG = 1.5; 
       
    % Plot individual data points
    %scatter(ones(size(dataGria4)), dataGria4, 50, 'b', 'filled', 'DisplayName', 'C3H/HeJ'); % Gria4: blue
    %scatter(2 * ones(size(dataStargazer)), dataStargazer, 50, 'r', 'filled', 'DisplayName', 'Stargazer'); % Stargazer: red
        
    % Plot bars for the means
    bar(xGria4, meanGria4, 0.4, 'FaceColor', [0.678, 0.847, 0.902], 'EdgeColor', 'b', 'LineWidth', 0.5);
    hold on 
    bar(xSTG, meanStargazer, 0.4, 'FaceColor', [1, 0.8, 0.8], 'EdgeColor', 'r', 'LineWidth', 0.5);
    
    hold on;

    % Plot individual values with jitter 
    % Amount of jitter to apply (adjust as needed)
    jitterAmount = 0.05;

    % Scatter plots with jitter ( 1 and 1.5 is X axis position where the
    % bar will be plotted) 
    scatter(xGria4 + jitterAmount * randn(size(dataGria4)), dataGria4, 50, ...
        'MarkerFaceColor', [0.678, 0.847, 0.902], ... % Light blue face color (RGB values for light blue)
        'MarkerEdgeColor', 'b');                     % Blue edge color
    
    scatter(xSTG + jitterAmount * randn(size(dataStargazer)), dataStargazer, 50, ...
        'MarkerFaceColor', [1, 0.8, 0.8], ...        % Light red/pink face color (customize as needed)
        'MarkerEdgeColor', 'r');                     % Red edge color


    % Customize plot
    xlim([0.5, 2.5]);
    xticks([xGria4, xSTG]);
    xticklabels({'C3H/HeJ', 'STG'});
    ylabel(features{iFeature});
    title(titles{iFeature});
    %legend('Location', 'best');
    %grid on;
    hold off;
end

% Add an overall title
%sgtitle('Comparison of Seizure Features Between Gria4 and Stargazer');
end