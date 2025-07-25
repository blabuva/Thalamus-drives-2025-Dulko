function [scaledHeight] = makeA4figure(numStructures)

A4_width = 21;
A4_height = 29.7;
referenceStructures = 5; % Reference number of structures for full A4 height
% Calculate the scaled height based on the number of structures
scaledHeight = (numStructures / referenceStructures) * A4_height;

% Ensure the height is at least a certain minimum value
minHeight = 10;  % Define a minimum height if needed
if scaledHeight < minHeight
    scaledHeight = minHeight;
end

end 