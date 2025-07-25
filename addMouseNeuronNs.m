function allDataTable = addMouseNeuronNs(allDataTable, brainNames) 
% parent function: aggraPhase.m


for iBrainPart = 1:length(brainNames)
    allDataTable.SWDs.NumberOfMice{iBrainPart} = length(allDataTable.SWDs.RawPhases{iBrainPart}) ;
    currentPart = allDataTable.SWDs.RawPhases{iBrainPart} ;
    numberOfNeurons = 0 ;
    numberOfSeizures = 0 ;
    for iMouse = 1:length(currentPart)
        numberOfNeurons = numberOfNeurons + size(currentPart{iMouse}{1},1) ;
        numberOfSeizures = numberOfSeizures + length(currentPart{iMouse}) ;
    end
    allDataTable.SWDs.NumberOfNeurons{iBrainPart} = numberOfNeurons ;
    allDataTable.SWDs.NumberOfSeizures{iBrainPart} = numberOfSeizures ;
end