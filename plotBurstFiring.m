function plotBurstFiring(SummaryBurst)  
% parent function: masterCodeTonicAndBurst.m 

% Extract data from cell array
structureNames = SummaryBurst(:, 1);
nonSeizureValues = cell2mat(SummaryBurst(:, 2));
seizureValues = cell2mat(SummaryBurst(:, 3));

% Number of structures
nStructures = length(structureNames);

% Set up figure
figure;
hold on;

% Plot each structure as two dots with a connecting line
for i = 1:nStructures
    if i == 5 % don't plot 'Don't analyze' 
        continue 
    end 
    % X positions: 1 = non-seizure, 2 = seizure
    x = [1, 2];
    y = [nonSeizureValues(i), seizureValues(i)];

    % Connecting line
    plot(x, y, 'k-', 'LineWidth', 1);

    % Dots
    plot(1, nonSeizureValues(i), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
    plot(2, seizureValues(i), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
end

% Formatting
xlim([0.5, 2.5]);
ylim([0, 30]); 
xticks([1 2]);
xticklabels({'Non-Seizure', 'Seizure'});
ylabel('Burst Firing (%)');
title('Burst Firing Percentage: Non-Seizure vs Seizure');


% Optional: increase font size for publication
set(gca, 'FontSize', 12);


%% Add means to the plot 
% Extract the numeric values from SummaryBurst
nonSeizureValues = cell2mat(SummaryBurst(:, 2));
seizureValues = cell2mat(SummaryBurst(:, 3));

% Remove don't analyze 
nonSeizureValues(5) = []; 
seizureValues(5) = []; 

meanNS = mean(nonSeizureValues); 
meanS = mean(seizureValues); 

plot([1 - 0.5, 1 + 0.5], [meanNS, meanNS], ...
     'k-', 'LineWidth', 3); 

plot([2 - 0.5, 2 + 0.5], [meanS, meanS], ...
     'r-', 'LineWidth', 3);


%% Statistics 
% Run paired t-test
[~, pValue, ~, stats] = ttest(nonSeizureValues, seizureValues);

% Display results
fprintf('Paired t-test:\n');
fprintf('t(%d) = %.3f, p = %.4f\n', stats.df, stats.tstat, pValue);

end 