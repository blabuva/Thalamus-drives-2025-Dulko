function markChannelsOnTheProbe(numStructures,oneMouse)
% plot the probe 
run probe_256ANS_bottom.m 

hold on 
colors = lines(numStructures); 
for iStructure = 1:numStructures 
            
    % Skip certain structures (hardcoded for now) 
    if ismember(iStructure, [2, 4, 5])
        continue;
    end

    % focus on one structure
    targetStructure = whatStructures{iStructure}; 
    [StructureDatabase] = indexToOneBrainStructure(oneMouse,targetStructure);
    
    % Mark channels for this structure on the probe map using info from the database 
    % Channel_Xposition is X coordinate, 
    %trialData = oneMouse.SingleUnitsAll{3,1}.all.CurrentSWD; 
    
    StrData = StructureDatabase.SingleUnitsAll{1,1}.all.CurrentSWD;   
    numSUs = size(StrData,1); 
    
    for iSU  = 1:numSUs
        Xcoord = StrData.Channel_Xposition(iSU);
        Ycoord = StrData.Channel_Yposition(iSU);
        % Use a unique color for each structure
        markerColor = colors(iStructure, :); % Get color for this structure
        plot(Xcoord, Ycoord, 's', 'MarkerSize', 12, 'MarkerFaceColor', markerColor, 'MarkerEdgeColor', markerColor); % Black edges
 
    end 

end 
hold off

% save the raster
figurePath = ('/media/elaX/Publications/Figures/Figure1_approach/'); 
svgFileName = fullfile(figurePath, ['ProbeMap_' '.svg']);      
saveas(gcf, svgFileName, 'svg');% Save the figure in .svg format

end 