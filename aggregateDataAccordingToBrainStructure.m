function brainSpikes = aggregateDataAccordingToBrainStructure(brainSpikes, SWD, unitType) 
% parent function: groupClustersFromSameBrainStructures

% save('/home/mark/matlab_temp_variables/BS')
% ccc
% load('/home/mark/matlab_temp_variables/BS')

padStructureName = sprintf('%sWithPad', unitType) ;

%%
for iSWD = 1:size(SWD,1)
    currentSWD = SWD(iSWD, :) ;
    if ~isempty(currentSWD.(unitType){1})
    [g, brainStructures] = findgroups(currentSWD.(unitType){1}.Channel_Brain) ; clear g ;
    for iStructure = 1:length(brainStructures)
        brainStructIDXs = find(contains(currentSWD.(unitType){1}.Channel_Brain, brainStructures{iStructure}));
        for iIDX = 1:length(brainStructIDXs)
            clusterID(iIDX, 1) = currentSWD.(unitType){1}.ClusterID(brainStructIDXs(iIDX)) ;
            brainStructs{iIDX, 1} = currentSWD.(unitType){1}.Channel_Brain(brainStructIDXs(iIDX)) ;
            channelNumber(iIDX,1) = currentSWD.(unitType){1}.Channel_Number(brainStructIDXs(iIDX)) ;
            channelX(iIDX,1) = currentSWD.(unitType){1}.Channel_Xposition(brainStructIDXs(iIDX)) ;
            channelY(iIDX,1) = currentSWD.(unitType){1}.Channel_Yposition(brainStructIDXs(iIDX)) ;
            units(iIDX,1) = currentSWD.(unitType){1}.SWD_Spikes(brainStructIDXs(iIDX)) ;

            unitsPad(iIDX,1) = currentSWD.(padStructureName){1}.SWD_Spikes(brainStructIDXs(iIDX)) ;

        end

        % create a matlab-friendly fieldname from the current brain structure
        currentBrainStructure =  regexprep(brainStructures{iStructure}, '/', '_') ;
        currentBrainStructure = regexprep(currentBrainStructure, '-', '_') ;
        currentBrainStructure = regexprep(currentBrainStructure, ' ', '_') ;

        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType) = array2table(clusterID, 'VariableNames', {'ClusterID'}) ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType).ChannelNumber = channelNumber ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType).Channel_Xposition = channelX ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType).Channel_Yposition = channelY ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType).units = units ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.(unitType).unitsPad = unitsPad ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.theSeizure = array2table(currentSWD.SWD_timeCol, 'VariableNames', {'Time'}) ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.theSeizure.EEG = currentSWD.SWD_EEG ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.theSeizure.TroughTimes = currentSWD.SWD_troughTimes ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.theSeizure.TroughValues = currentSWD.SWD_troughVals ;
        brainSpikes.(currentBrainStructure).SWD{iSWD}.theSeizure.seizureStartTime = currentSWD.SWD_startTime ;

        clear clusterID channelNumber channelX channelY units unitsPad currentBrainStructure
    end
    clear currentSWD brainStructures
    end
end