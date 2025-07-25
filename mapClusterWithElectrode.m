function mappedUnits = mapClusterWithElectrode(unMappedUnits, map) 
% parent function: curateKiloSort.m

%save('/home/mark/matlab_temp_variables/mapDem')
%ccc
%load('/home/mark/matlab_temp_variables/mapDem')

%% reassign channel numbers in antomy (channels start at number 0, not 1)
numChans = size(map.channelBrainLocations,1) ;
for iChan = 1:numChans 
    map.channelBrainLocations{iChan,1} = iChan ;
end

%%  map units
% single units: 
mappedUnits.singleUnits = mapMyUnits(unMappedUnits.singleUnits, map) ;

% multi units
mappedUnits.multiUnits = mapMyUnits(unMappedUnits.multiUnits, map) ;

% unsorted units:
mappedUnits.unsortedUnits = mapMyUnits(unMappedUnits.unsortedUnits, map) ;
