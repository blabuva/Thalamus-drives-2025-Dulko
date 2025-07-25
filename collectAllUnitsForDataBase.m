function  units = collectAllUnitsForDataBase(mappedKSUnits, inhibitoryUnits, excitatoryUnits, seizureFreeLeadTime, seizureFreePostTime, unitType, currentStruc)
% parent function: createSingleExperimentUnitDataBase.m

% save('/home/mark/matlab_temp_variables/unitCoo')
% ccc
% load('/home/mark/matlab_temp_variables/unitCoo')

%% find units that exist in current structure
unitsCurrentStruc_IDX = find(contains(mappedKSUnits.(unitType).Channel_Brain, currentStruc) ==1) ;
units.all.CurrentSWD = mappedKSUnits.(unitType)(unitsCurrentStruc_IDX, :) ;

%%
for iSingle = 1:size(units.all.CurrentSWD,1)
    allSpikeTimes = units.all.CurrentSWD.SpikeTimesSec{iSingle} ;
    allIDX = units.all.CurrentSWD.IDXofUncuratedSpikeVector{iSingle} ;
    singlesSWD_IDX = find(allSpikeTimes>= seizureFreeLeadTime & allSpikeTimes < seizureFreePostTime) ;
    units.all.CurrentSWD.SpikeTimesSec{iSingle} = [] ;
    units.all.CurrentSWD.IDXofUncuratedSpikeVector{iSingle} = [] ;
    units.all.CurrentSWD.SpikeTimesSec{iSingle} = allSpikeTimes(singlesSWD_IDX) ;
    units.all.CurrentSWD.IDXofUncuratedSpikeVector{iSingle} = allIDX(singlesSWD_IDX) ;
    clear allSpikeTimes allIDX singlesSWD_IDX
end

%% get any inhibitory units
inhibJumper = 1 ;
for iInhib = 1:size(inhibitoryUnits, 1)
    currentCluster = inhibitoryUnits.ClusterID(iInhib) ;
    clusterIDX = find(units.all.CurrentSWD.ClusterID == currentCluster) ;
    if ~isempty(clusterIDX)
        currentUnit= units.all.CurrentSWD(clusterIDX, :) ;
        if inhibJumper == 1
            units.inhibitory = currentUnit ;
        else
            units.inhibitory = [units.inhibitory; currentUnit] ;
        end
        inhibJumper = inhibJumper + 1 ;
        clear currentUnit 
    end
end

%% get any excitatory units
excitJumper = 1 ;
for iExcit = 1:size(excitatoryUnits, 1)
    currentCluster = excitatoryUnits.ClusterID(iExcit) ;
    clusterIDX = find(units.all.CurrentSWD.ClusterID == currentCluster) ;
    if ~isempty(clusterIDX)
        currentUnit= units.all.CurrentSWD(clusterIDX, :) ;
        if excitJumper == 1
            units.excitatory = currentUnit ;
        else
            units.excitatory = [units.excitatory; currentUnit] ;
        end
        excitJumper = excitJumper + 1 ;
        clear currentUnit 
    end
end




