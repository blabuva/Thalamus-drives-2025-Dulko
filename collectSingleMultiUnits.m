function units = collectSingleMultiUnits(curatedSpikes)
% parent function: curateKiloSort.m

%% NOTE:
%    --> curated spike cluster IDs refers to clusters that have been manually curated in KiloSort - all except the noisy ones)
%    --> during curation, units were assigned a unit type (1: multi-unit;  2: single unit; 3: unsorted). 
%    --> also noise (i.e. = 0), but these are omitted from both the curatedClusterIDs and the curatedUnitType (omitted by KiloSort)

%% get indices of single units (assinged as '2' in KiloSort curation process)
singleUnitIDX = find(curatedSpikes.UnitType == 2);

%% get indices of multi units (assinged as '1' in KiloSort curation process)
multiUnitIDX = find(curatedSpikes.UnitType == 1);

%% get indices of unsorted (assinged as '3' in KiloSort curation process)
unsortedUnitIDX = find(curatedSpikes.UnitType == 3) ;

%% make table of only single units
units.singleUnits = array2table([curatedSpikes.ClusterID(singleUnitIDX), ...
                                                    curatedSpikes.UnitType(singleUnitIDX)], ...
                                                    'VariableNames', {'ClusterID', 'UnitType'}) ; 
units.singleUnits.SpikeTimesSec = curatedSpikes.SpikeTimesSec(singleUnitIDX) ;
units.singleUnits.IDXofUncuratedSpikeVector = curatedSpikes.IDXofUncuratedSpikeVector(singleUnitIDX) ;

%% make table of only multi units
units.multiUnits = array2table([curatedSpikes.ClusterID(multiUnitIDX), ...
                                                    curatedSpikes.UnitType(multiUnitIDX)], ...
                                                    'VariableNames', {'ClusterID', 'UnitType'}) ; 
units.multiUnits.SpikeTimesSec = curatedSpikes.SpikeTimesSec(multiUnitIDX) ;
units.multiUnits.IDXofUncuratedSpikeVector = curatedSpikes.IDXofUncuratedSpikeVector(multiUnitIDX) ;

%% make table of only unsorted units
units.unsortedUnits = array2table([curatedSpikes.ClusterID(unsortedUnitIDX), ...
                                                    curatedSpikes.UnitType(unsortedUnitIDX)], ...
                                                    'VariableNames', {'ClusterID', 'UnitType'}) ; 
units.unsortedUnits.SpikeTimesSec = curatedSpikes.SpikeTimesSec(unsortedUnitIDX) ;
units.unsortedUnits.IDXofUncuratedSpikeVector = curatedSpikes.IDXofUncuratedSpikeVector(unsortedUnitIDX) ;
                                            

