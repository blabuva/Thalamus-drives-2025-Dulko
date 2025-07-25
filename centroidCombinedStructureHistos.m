function whittleDataTable = centroidCombinedStructureHistos(whittleDataTable, dataType)

% save('C:\Users\markb\Desktop\Matlab\tempVars\sumComboedHistos')
% clear all; close all; clc ;
% load('C:\Users\markb\Desktop\Matlab\tempVars\sumComboedHistos')
% keep whittleDataTable dataType; clc; close all ;

%%
for iStruct = 1:size(whittleDataTable.(dataType),1)
    if ~isempty(whittleDataTable.(dataType).PhaseCombinedStructures{iStruct} )
        histogramDataAll = whittleDataTable.(dataType).PhaseCombinedStructures{iStruct} ;
        histogramDataSpikeCentered = histogramDataAll(50:150) ;
        bin_edges = 0:1:length(histogramDataSpikeCentered);
        bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
        center_of_mass = (sum(histogramDataSpikeCentered .* bin_centers) / sum(histogramDataSpikeCentered)) -50;
    else
        center_of_mass = 0 ;
    end
    whittleDataTable.(dataType).PhaseCentroid{iStruct} = center_of_mass;
end


    % calculate centroid of vector
    % Calculate the center of mass
    
    % allCenters(iRow,:) = [iRow, center_of_mass, sum(histogram_data)] ;