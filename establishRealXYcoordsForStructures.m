function [x,y,brainStructures] = establishRealXYcoordsForStructures

% Define brain structure names
brainStructures = {'Primary_somatosensory_cortex', 'Hippocampus_CA1', 'Hippocampus_CA2', 'Hippocampus_CA3', 'Dentate_Gyrus',...
 'Lateral_posterior_nucleus_of_the_thalamus', 'Medial_habenula', 'Lateral_dorsal_nucleus_of_thalamus',...
 'Ethmoid_nucleus_of_the_thalamus', 'Reticular_nucleus_of_the_thalamus', ...
 'Lateral_habenula', 'Posterior_complex_of_the_thalamus', 'Mediodorsal_nucleus_of_thalamus',...
 'Central_lateral_nucleus_of_the_thalamus', 'VB_VPM', 'VB_VPL', 'Paraventricular_nucleus_of_the_thalamus', ...,
 'Intermediodorsal_nucleus_of_the_thalamus','Paracentral_nucleus', 'Hippocampal_formation', ... ,
  'Subthalamic_nucleus', 'Hypothalamus', 'Caudoputamen','Ventral_part_of_the_lateral_geniculate_complex'};

% Define X and Y coordinates
x = [0.0, 0.5, 0.0, -0.8, 0.2, 0.0, 0.6, -0.4, -0.4, -0.8, ...
     0.4, 0.0, 0.5, 0.2, -0.2, -0.5, 0.6, 0.6, 0.5, 0.25, 0.1, 0.0, -0.7, -0.9];

y = [1.9, 1.6, 1.5, 1.2, 1.2, 0.5, 0.4, 0.5, 0.2, -0.4, ...
     0.4, 0.0, -0.4, -0.3, -0.6, -0.6, 0.25, 0.0 , -0.8, 1.4, -0.8, -0.9, 1.8, -0.25];

% Create figure
figure; hold on;

% Plot points
scatter(x, y, 100, 'filled', 'b'); % Blue dots

% Add labels to the points
for i = 1:length(brainStructures)
    text(x(i), y(i), brainStructures{i}, 'FontSize', 10, 'HorizontalAlignment', 'right');
end

% Formatting
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('Brain Structure Coordinates');
axis equal; % Keep proportions correct
xlim([-1 1]); 
ylim([-1 2]); 
grid on;
hold off;

end 