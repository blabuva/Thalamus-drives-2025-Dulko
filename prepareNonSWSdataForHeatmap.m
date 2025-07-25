function [CorrelationsCombinedBig_NonSWSs,LabelsBigHeatmap_NonSWSs] = prepareNonSWSdataForHeatmap(CorrelationsDuringNonSWSs,combinations,numColumns)
% parent function: VisualizeAllCorrelationsAsHeatmap.m 

CorrelationsCombinedBig_NonSWSs = []; 
CorrelationsCombined_NonSWSs = zeros(1,numColumns); % random numbers just for now 
LabelsBigHeatmap_NonSWSs = [];

count = 0; % start counting the iterations for 
% loop through all rows (all combinations) 
for iCombination = 1:size(CorrelationsDuringNonSWSs,1)
    CombinationRow = []; 
    % check if there is a situation where all fields are empty, if yes skip
    AllEmpty = all(cellfun(@isempty, CorrelationsDuringNonSWSs(iCombination,:)));  % Check if all cells are empty 
        
    if AllEmpty ==1 
       continue 
    end

    isempty(CorrelationsDuringNonSWSs(iCombination,:))
    for iAnimal = 1:size(CorrelationsDuringNonSWSs,2)
        AnimalField = CorrelationsDuringNonSWSs{iCombination,iAnimal}; 
        if isempty(AnimalField) % if it's empty, skip this field and dont worry about it 
            continue;
        end
        % if not empty: 
        CombinationRow = [CombinationRow,AnimalField]; % store data
    end
    % but also store the brain structure names 
            count = count + 1; 
            % what is the combination for this data?? 
            structure1 = combinations{iCombination,1}; % structure 1
            structure2 = combinations{iCombination,2}; % structure 2 
            
            LabelsBigHeatmap_NonSWSs{count,1} =  structure1; 
            LabelsBigHeatmap_NonSWSs{count,2} = structure2; 


    % append the CombinationRow to CorrelationsCombined (need to match the
    % size first)
    ResizedCombinationRow = zeros(1,numColumns); 
    ResizedCombinationRow(1:size(CombinationRow,2)) = CombinationRow;
    CorrelationsCombined_NonSWSs(1,:) = ResizedCombinationRow; 

    % append to CorrelationCombinedBig 
    CorrelationsCombinedBig_NonSWSs = [CorrelationsCombinedBig_NonSWSs; CorrelationsCombined_NonSWSs]; 


end

