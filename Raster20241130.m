%% Load the database 
addpath '/media/elaX/intanData/ela/individualExperimentDataBase'/2024_11_17__09_48_08/
load('2024_11_17__09_48_08_allDataBases.mat') % Load the database
strainName = 'Gria4'; % choose the mouse 
logicalIndexStrain = strcmp(allDataBases.Strain, strainName);% keep one strain only 
[originalDB] = BigLag_241118(logicalIndexStrain,allDataBases); % ver updated 2024-07-29 
allDataBases=originalDB; % change the name for simplicity   

%% Choose a mouse 
mouseId = '0030'; 
% Limit database to one mouse 
MouseIndex = strcmp(allDataBases.MouseID, mouseId);% keep one strain only
oneMouse = allDataBases(MouseIndex,:); 

%% What brain structures are in it??
        LumpedStructure = oneMouse.LumpedStructure;
        
        % Initialize an empty cell array to store unique structure names
        uniqueNames = {};
        
        % Loop through each cell in LumpedStructure
        for i = 1:numel(LumpedStructure)
            % Get the inner cell containing the structure name
            innerCell = LumpedStructure{i};
            % Check if the inner cell is not empty and contains a single element
            if ~isempty(innerCell) && numel(innerCell) == 1
                % Get the structure name from the inner cell and add it to uniqueNames
                structureName = innerCell{1};
                uniqueNames{1+end} = structureName;
            end
        end
        
        whatStructures = unique(uniqueNames)';
numStructures = size(whatStructures,1); 

%% Make a raster with unit activity 
% plot seizure of choice including all brain structures in this recording 

iSeizure = 6;  
figure; 
for iStructure = 1:numStructures 
    
    subplot(numStructures,1,iStructure)
    
    % % Skip certain structures (hardcoded for now) 
    % if ismember(iStructure, [2, 4, 5])
    %     continue;
    % end

    % focus on one structure
    targetStructure = whatStructures{iStructure}; 
    [StructureDatabase] = indexToOneBrainStructure(oneMouse,targetStructure);  
  

    allSpikes = StructureDatabase.SingleUnitsAll{iSeizure,1}.all.CurrentSWD;
    seizureStart = oneMouse.SeizureStartTime(iSeizure); 
    seizureEnd =  oneMouse.SeizureEndTime(iSeizure);
    leftLimit = seizureStart-10;
    rightLimit = seizureEnd+10;
    % Extract the SpikeTimeSec column
    spikeTimes = allSpikes.SpikeTimesSec;

    % Initialize filtered spike times cell array
    filteredSpikeTimesCell = cell(size(spikeTimes));

    % Loop through each cell and filter spike times
    for i = 1:numel(spikeTimes)
        spike_times = spikeTimes{i};
        filteredSpikeTimesCell{i} = spike_times(spike_times >= leftLimit & spike_times <= rightLimit);
    end

    % Create the raster plot
    hold on;
    for i = 1:numel(filteredSpikeTimesCell)
        cellSpikes = filteredSpikeTimesCell{i};
        y = i * ones(size(cellSpikes)); % Y-coordinate for the cell
        plot(cellSpikes, y, '|', 'MarkerSize', 2,'Color','[0, 0, 0]'); % Plot spikes as lines
    end
    %hold on;
    
    % If you wish plot the boundaries of the seizure 
        %yRange = [0.5, numel(filteredSpikeTimesCell) + 0.5];
        %plot([seizureStart, seizureStart], yRange, 'k--','lineWidth',1.5); % Vertical line for seizure start
        %plot([seizureEnd, seizureEnd], yRange, 'r--','lineWidth',1.5); % Vertical line for seizure end
        hold off;
    
    %xlabel('Time (sec)');
    ylabel('Single unit');
    title(targetStructure);
    ylim([0.5, numel(filteredSpikeTimesCell) + 0.5]); % Set y-axis limits
    %xlim([210 240]); 
    xlim([445 490]);
end

% save the raster
figurePath = ('/media/elaX/Publications/Figures/Figure1_approach/newRasters'); 
svgFileName = fullfile(figurePath, ['Seizure_' num2str(iSeizure) '.svg']);      
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format



%% Plot EEG and speed as a separate figure 
figure; 
    subplot(2,1,1); % plot EEG trace
        EEG = oneMouse.EEGwithTime{iSeizure,1}(:,2) ; % extract eeg for seizure and a little on the sides 
        timeForEEG = oneMouse.EEGwithTime{iSeizure,1}(:,1); % extract time for this seizure and a bit on the sides  
        plot(timeForEEG,smooth(EEG,40),'Color','k'); % SMOOTHED TO AVOID saturated amplifier 
        xlim([210 240]); 

subplot(2,1,2); % Plot the speed
    moveData = StructureDatabase.Motion{iSeizure,1}.thisSeizure.raw.movement; 
    timeData = StructureDatabase.Motion{iSeizure,1}.thisSeizure.raw.time; 
    [timeCenters,speed] = calcualateSpeed_ela_241130(moveData,timeData); % calculate speed 
   
    plot(timeCenters, smooth(speed,30), 'LineWidth', 2); % plot smoothed movement 
    xlabel('Time (s)');
    xlim([210 240]); 
    ylabel('Speed (cm/s)'); 
    ylim([0 200]); 
    %title('Speed in Intervals');
    grid off;

% save the figure 
svgFileName = fullfile(figurePath, ['EEG_and_motion_2' num2str(iSeizure) '.svg']);      
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format






 

%% Make a histogram 
% allSpikeTimes = [];
% for i = 1:numel(filteredSpikeTimesCell)
%     allSpikeTimes = [allSpikeTimes; filteredSpikeTimesCell{i}(:)];
% end
% 
% % Create histogram with bin size 0.01
% binSize = 0.01;
% %binSize = 0.1;
% edges = leftLimit:binSize:rightLimit;
% counts = histcounts(allSpikeTimes, edges);
% 
% % Plot the histogram
% figure;
% bar(edges(1:end-1), counts, 'histc');
% xlabel('Time (sec)');
% ylabel('Spike Count');
% %title('Histogram of Spike Counts Across All Neurons');
