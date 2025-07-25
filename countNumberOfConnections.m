function [nodeColors,colorMap15] = countNumberOfConnections(brainStructures,edgeNamesFiltered)

% Count number of connections per brain structure
nodeConnections = zeros(length(brainStructures), 1);
for i = 1:size(edgeNamesFiltered,1)
    node1 = edgeNamesFiltered{i,1};
    node2 = edgeNamesFiltered{i,2};

    idx1 = find(strcmp(brainStructures, node1));
    idx2 = find(strcmp(brainStructures, node2));

    if ~isempty(idx1)
        nodeConnections(idx1) = nodeConnections(idx1) + 1;
    end
    if ~isempty(idx2)
        nodeConnections(idx2) = nodeConnections(idx2) + 1;
    end
end

% Normalize node connections for coloring
%minConnections = min(nodeConnections);
%maxConnections = max(nodeConnections);
minConnections = 0; 
maxConnections = 15; 
% if maxConnections > minConnections
%     normConnections = (nodeConnections - minConnections) / (maxConnections - minConnections);
% else
%     normConnections = zeros(size(nodeConnections)); % Prevent divide by zero
% end


%% Colormap 
% Generate the turbo colormap
fullColormap = turbo(256); % Turbo has 256 colors

% Select 16 equally spaced indices (0 to 15)
numColors = maxConnections+1; % 0 to 15, so we need 16 colors
colorIndices = round(linspace(1, 256, numColors)); % Get indices
colorMap15 = fullColormap(colorIndices, :); % Extract 16 colors

% Example: Get the color for a given value (must be between 0 and 15)
value = 1; % Example value
colorForValue = colorMap15(value + 1, :); % +1 since MATLAB indexing starts at 1

disp(colorForValue); % Displays the RGB triplet for value 7

nodeColors = []; 

for iNode = 1:size(nodeConnections,1)
    value = nodeConnections(iNode); 
    givenColor = colorMap15(value+1,:); 
    nodeColors = [nodeColors;givenColor]; 
end 


end % function end 