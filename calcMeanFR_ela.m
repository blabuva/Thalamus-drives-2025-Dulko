function calcMeanFR_ela(firingDuringSeizures,firingDuringNonSeizures,whatStructures)
% parent function: MasterFunctionZscore.m (run first to get 

% this function goes through brain structures to calculate mean firing rate
% during the first 4 seconds of the seizure for each neuron to plot results
% as a dot plot 

numStructures = size(firingDuringSeizures,1); % how many brain structures? 
MeanValuesForDotPlot = []; 

for iStructure = 1:numStructures
    
    oneStructure = firingDuringSeizures{iStructure,1}; 
    if isempty(oneStructure) 
        continue 
    end

    means = []; 
    for iTrial = 1:size(oneStructure,1) 
        oneTrial = oneStructure{iTrial,1}; % one event for each neuron 
        meanFourSec = mean(oneTrial(1,20:24)); 
        means = [means,meanFourSec]; 

    end

    MeanValuesForDotPlot{iStructure,1} = means; % store means for each brain structure 
end 

%%  Do the same for baseline  
numStructures = size(firingDuringNonSeizures,1); % how many brain structures? 
MeanValuesForDotPlot_NonS = []; 

for iStructure = 1:numStructures
    
    oneStructure = firingDuringNonSeizures{iStructure,1}; 
    if isempty(oneStructure) 
        continue 
    end

    means = []; 
    for iTrial = 1:size(oneStructure,1) 
        oneTrial = oneStructure{iTrial,1}; % one event for each neuron 
        meanFourSec = mean(oneTrial(1,1:24)); 
        means = [means,meanFourSec]; 

    end

    MeanValuesForDotPlot_NonS{iStructure,1} = means; % store means for each brain structure 
end 


%% Reorganize seizure data 
meanFiringRates = [];  % Store mean firing rates
dataCounts = [];  % Store counts of data points
stDev = []; % store st dev for seizures 
validLabels = {};  % Store valid structure names

labelIndex = 0;

for i = 1:length(MeanValuesForDotPlot)
    data = MeanValuesForDotPlot{i};

    if isempty(data)
        continue;
    end

    % Calculate mean firing rate for this structure
    meanFiring = mean(data);
    stDevData = std(data); 
    numDataPoints = length(data);  % Count data points

    % Store results
    labelIndex = labelIndex + 1;
    meanFiringRates = [meanFiringRates; meanFiring];
    dataCounts = [dataCounts; numDataPoints];
    stDev = [stDev; stDevData]; 
    
    % Store label for this structure
    thisLabel = whatStructures{i};
    if ischar(thisLabel) || isstring(thisLabel)
        validLabels{labelIndex} = char(thisLabel);  % Make sure it’s a char vector
    else
        validLabels{labelIndex} = sprintf('Structure %d', i);  % Fallback label
    end
end

% Convert to categorical for y-axis labels
groupCats = categorical(validLabels);
%% Reorganize Non-Seizure data 
meanFiringRates_NonS = [];  % Store mean firing rates
stDev_NonS = []; % store st dev 
dataCounts = [];  % Store counts of data points
validLabels = {};  % Store valid structure names

labelIndex = 0;

for i = 1:length(MeanValuesForDotPlot_NonS)
    data = MeanValuesForDotPlot_NonS{i};

    if isempty(data)
        continue;
    end

    % Calculate mean firing rate for this structure
    meanFiring = mean(data);
    stDevData = std(data); 
    numDataPoints = length(data);  % Count data points

    % Store results
    labelIndex = labelIndex + 1;
    meanFiringRates_NonS = [meanFiringRates_NonS; meanFiring];
    dataCounts = [dataCounts; numDataPoints];
    stDev_NonS = [stDev_NonS; stDevData]; 
    
    % Store label for this structure
    thisLabel = whatStructures{i};
    if ischar(thisLabel) || isstring(thisLabel)
        validLabels{labelIndex} = char(thisLabel);  % Make sure it’s a char vector
    else
        validLabels{labelIndex} = sprintf('Structure %d', i);  % Fallback label
    end
end

% Convert to categorical for y-axis labels
groupCats = categorical(validLabels);



%% Plot both in one figure 
figure; hold on;
% Plot using scatter FOR SEIZURES 
scatter(meanFiringRates, groupCats, stDev*10, 'filled');  % Scale dot size by st dev 
% Plot using scatter FOR NON-SEIZURES 
scatter(meanFiringRates_NonS, groupCats, stDev_NonS*10,[0.5 0.5 0.5], 'filled');  % Scale dot size by st dev
xline(5,'--k'); 

xlabel('Firing Rate');
ylabel('Brain Structure');
title('Firing Rates For seizures and non-seizures (Dot Size = st dev)');

forDataPath = ('/media/elaX/Publications/Figures/Figure2_FiringRate/');
svgFileName = fullfile(forDataPath, ['FiringChange04232025','.svg']);
        
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

%% Plot sorted based on the difference (baseline-seizure)
plotSortedFRSWD_vsNonSWD(meanFiringRates,meanFiringRates_NonS,stdDev,stdDev_NonS); 



end % function end 
