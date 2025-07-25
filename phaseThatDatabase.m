function phase = phaseThatDatabase(data)
% parent function: unitPhaseFromDataBase.m

save('/home/mark/matlabTemp/phData')
% ccc
% load('/home/mark/matlabTemp/phData')

% keep data
% clc; close all;


binSize = 0.01 ;
%%
phaseFields = {'singleALL'; 'singleEX'; 'singleIN'; 'multi'} ;

for iSeizure = 1:size(data,1)
    % phaseFields = fieldnames(data.Phase{iSeizure}) ;
        if iSeizure ==1
            phase.singleALL.data = table ;
            phase.singleIN.data = table ;
            phase.singleEX.data = table ; 
            phase.multi.data = table ;
        end

    for iField = 1:length(phaseFields)
        phase.(phaseFields{iField}).data.Structure{iSeizure} = data.Structure{iSeizure} ;
        phase.(phaseFields{iField}).data.MouseID{iSeizure} = data.MouseID{iSeizure} ;
        phase.(phaseFields{iField}).data.SeizureNum(iSeizure) = data.SeizureNumber(iSeizure);

        if iSeizure == 106 && iField == 4
            x = 1;
        end

        if isfield(data.Phase{iSeizure}, phaseFields{iField})
            phase.(phaseFields{iField}).data.Phase{iSeizure,1} = data.Phase{iSeizure}.(phaseFields{iField}) ;
            [perCycle, perSWD] = phaseNittyGritty( phase.(phaseFields{iField}).data.Phase{iSeizure}, binSize) ; 
            phase.(phaseFields{iField}).perCycle.allSeizures{iSeizure,1} = perCycle ;
            phase.(phaseFields{iField}).perSWD.allSeizures{iSeizure,1} = perSWD ;
            clear perCycle perSWD
        else
            phase.(phaseFields{iField}).data.Phase{iSeizure,1} = [] ;
            phase.(phaseFields{iField}).perCycle.allSeizures{iSeizure,1} = [] ;
            phase.(phaseFields{iField}).perSWD.allSeizures{iSeizure,1} = [] ;
        end
    end
end

%% clean up table (i.e. remove blanks)
allPhaseFields = fieldnames(phase) ;
for iField = 1:length(allPhaseFields)
    currentData = phase.(allPhaseFields{iField}).data ;
    if isempty(currentData) == 0
        nonEmptyRows = find(cellfun('isempty', currentData{:, 'Structure'} ) ==0);
        phase.(allPhaseFields{iField}).data = currentData(nonEmptyRows,:) ;
    else
        phase.(allPhaseFields{iField}).data = [] ;
        phase.(allPhaseFields{iField}).perCycle.allSeizures = {[]} ;
        phase.(allPhaseFields{iField}).perSWD.allSeizures = {[]} ;
    end
end

%%
allPhaseFields = fieldnames(phase) ;
for iField = 1:length(phaseFields)
    matNoBlanksCell = phase.(allPhaseFields{iField}).perCycle.allSeizures(~cellfun('isempty',phase.(allPhaseFields{iField}).perCycle.allSeizures)) ;
    if ~isempty(matNoBlanksCell)
        phase.(allPhaseFields{iField}).perCycle.matNoBlanks = vertcat(matNoBlanksCell{:}) ;
    else
        phase.(allPhaseFields{iField}).perCycle.matNoBlanks = zeros(1, 200) ;
    end
    clear matNoBlanksCell

    matNoBlanksCell = phase.(allPhaseFields{iField}).perSWD.allSeizures(~cellfun('isempty',phase.(allPhaseFields{iField}).perSWD.allSeizures)) ;
    if ~isempty(matNoBlanksCell)
        phase.(allPhaseFields{iField}).perSWD.matNoBlanks = vertcat(matNoBlanksCell{:}) ;
    else
        phase.(allPhaseFields{iField}).perSWD.matNoBlanks = zeros(1,200);
    end

    %% account for matrices that are blank

    %% find peak/centroid of histogram
    histRows = phase.(allPhaseFields{iField}).perSWD.matNoBlanks(:, 50:150) ;
    histSum = sum(histRows, 1) ;
    for iRow = 1:size(histRows,1)
        currentRow = histRows(iRow, :) ;
        maxRowIDX(iRow) = mean(find(currentRow == max(currentRow))) ;
        clear currentRow
    end
    phase.(allPhaseFields{iField}).perSWD.meanPeakOfIndividualRows = mean(maxRowIDX) ;
    phase.(allPhaseFields{iField}).perSWD.peakOfSummedRows = mean(find(histSum == max(histSum))) ;

    bin_edges = 0:1:length(histSum);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
    center_of_mass = (sum(histSum .* bin_centers) / sum(histSum)) -50;

    phase.(allPhaseFields{iField}).perSWD.centerOfMass = center_of_mass ;

    clear matNoBlanksCell histRows histSum maxRowIDX bin_edges bin_centers center_of_mass
end

