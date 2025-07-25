function investigateCorrBetweenFiringAndLFP(xCorrFiringAndLFP)
% parent function: Phase_ela.m 

% filter brain structures to only include the ones I want to analyze
% here is a list of structures that showed synchrony before the seizure was
% detected in the cortex 
structuresOfInterest = {'VB_VPM', 'Lateral_dorsal_nucleus_of_thalamus', 'Hippocampus_CA3',...
    'Primary_somatosensory_cortex','Posterior_complex_of_the_thalamus','Dentate_Gyrus',...
    'VB_VPL', 'Central_lateral_nucleus_of_the_thalamus','Mediodorsal_nucleus_of_thalamus'}; 


% loop through brain structures of interest 
for iStructure = 1:size(structuresOfInterest,2)

    currentStructure = structuresOfInterest{iStructure}; 

    Dotsss = {}; 
    % loop through rows and only collect only rows that match curr str name 
    for iRow = 1:size(xCorrFiringAndLFP,1)
        strcmp(xCorrFiringAndLFP{iRow,2},currentStructure)
        if ans == 0 
            continue
        else 
            Dotsss = [Dotsss; xCorrFiringAndLFP(iRow,:)]; 
        end

    end
    
    % once data is collected across all rec-s, analyze 
    plotScatterPerStructure(Dotsss,currentStructure); 
    

end