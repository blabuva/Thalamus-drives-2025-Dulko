function [pValues] = checkStatisticsSeizureFeature(seizureData)

% Parent function: SeizureFeaturesMaster_2024_08_29.m 

% Perform statistical tests and compare features
features = {'avgNumberSeizures', 'avgDuration', 'avgCycleDuration', 'AvgNumCycles'};
pValues = struct(); % To store p-values for each feature

for iFeature = 1:length(features)
    featureName = features{iFeature};
    
    % Extract data for Gria4 and Stargazer
    dataGria4 = seizureData.Gria4.(featureName);
    dataStargazer = seizureData.Stargazer.(featureName);
    
    % Perform unpaired t-test
    [h, p] = ttest2(dataGria4, dataStargazer); % h = 0 means no significant difference, h = 1 means significant
    
    % Store the p-value
    pValues.(featureName) = p;
    
    % Display the result
    fprintf('Feature: %s, p-value: %.6f\n', featureName, p);
    
    if h == 1
        fprintf('The difference in %s between Gria4 and Stargazer is statistically significant (p < 0.05).\n', featureName);
    else
        fprintf('The difference in %s between Gria4 and Stargazer is not statistically significant (p >= 0.05).\n', featureName);
    end
end

end 