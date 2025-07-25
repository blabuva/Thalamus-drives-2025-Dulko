function unitClassification = grabInhAndExcInformation(strainOfInterest)
% parent function: MasterCodePhaseEla20250212.m

% this function goes through the databases and makes a structure that
% includes the IDs of inh and exc units for each experiment 

%% Load the most recent DataBase 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase/2025_01_25__06_31_47';
load('2025_01_25__06_31_47_allDataBases.mat'); % Load the database 
logicalIndexStrain = strcmp(allDataBases.Strain, strainOfInterest);% keep one mouse only 
allDataBases = allDataBases(logicalIndexStrain, :); % now allDataBases includes one mouse only

ExpIDs = unique(allDataBases.ExperimentNumber); % what experiments are here 
unitClassification = {};   

for iExp = 1:size(ExpIDs,1)
    % index to one experiment 
    display(iExp);
    ExpData = allDataBases(allDataBases.ExperimentNumber == ExpIDs(iExp),:); % keep one exp 
    
    % focus on seizure 1 only beacause exc/inh info is the same for all of
    % them 
    seizure1 = ExpData(ExpData.SeizureNumber == 1,:); % keep seizure 1
    
    % loop through brain structures in this exp 
    uniqueStructures = unique(seizure1.Structure); 
   
    for iStructure = 1:size(uniqueStructures,1)
        currentStructure = uniqueStructures{iStructure};

        indexToStr = strcmp(seizure1.Structure, currentStructure); % index to one structure 
        oneStructure = seizure1(indexToStr == 1, :); 
        % sometimes there is no single units 
        if size(oneStructure.SingleUnitsSWD{1,1}.all,1) == 0 
            inhClusters = [];
            excClusters = []; 
            else % sometimes there is no units of specific type 
                if isfield(oneStructure.SingleUnitsSWD{1,1}, 'inhibitory')  
                   inhClusters = oneStructure.SingleUnitsSWD{1,1}.inhibitory.ClusterID; % cluster ID for inhibitory units 
                   else
                   inhClusters = [];   
                end 

                if isfield(oneStructure.SingleUnitsSWD{1,1}, 'excitatory')
                    excClusters = oneStructure.SingleUnitsSWD{1,1}.excitatory.ClusterID; % cluster ID for excitatory units 
                    else 
                    excClusters = [];
                end
                 
        end
        % store either way 
        % Convert iExp to a string for dynamic field name creation
        currentMouse = ExpData.MouseID{1,1};  
        mouseID = str2num(currentMouse); 
        expField = sprintf('Mouse_%d',mouseID); 
        structField = sprintf('Structure_%d', iStructure);
        
        % Store the inhibitory and excitatory clusters
        unitClassification.(expField).(structField).Inhibitory = inhClusters;
        unitClassification.(expField).(structField).Excitatory = excClusters;

    end % end of istructure loop 
end % end of iExp loop 


end % function end 