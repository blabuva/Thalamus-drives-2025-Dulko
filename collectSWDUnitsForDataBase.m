function  units = collectSWDUnitsForDataBase(allUnits, inhibitoryUnits, excitatoryUnits, currentStruc)
% parent function: createSingleExperimentUnitDataBase.m

% save('/home/mark/matlab_temp_variables/ccoo')
% ccc
% load('/home/mark/matlab_temp_variables/ccoo')

%%
unitsCurrentStruc_IDX = find(contains(allUnits.Channel_Brain, currentStruc) ==1) ;
units.all = allUnits(unitsCurrentStruc_IDX, :) ;

%% get any inhibitory units
inhibJumper = 1 ;
for iInhib = 1:size(inhibitoryUnits, 1)
    currentCluster = inhibitoryUnits.ClusterID(iInhib) ;
    clusterIDX = find(units.all.ClusterID == currentCluster) ;
    if ~isempty(clusterIDX)
        currentUnit= units.all(clusterIDX, :) ;
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
    clusterIDX = find(units.all.ClusterID == currentCluster) ;
    if ~isempty(clusterIDX)
        currentUnit= units.all(clusterIDX, :) ;
        if excitJumper == 1
            units.excitatory = currentUnit ;
        else
            units.excitatory = [units.excitatory; currentUnit] ;
        end
        excitJumper = excitJumper + 1 ;
        clear currentUnit 
    end
end

