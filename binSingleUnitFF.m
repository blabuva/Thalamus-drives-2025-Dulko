function spikeFreq = binSingleUnitFF(allUnits, swdBins) 

% save('/home/mark/matlab_temp_variables/FFunits') ;
% ccc
% load('/home/mark/matlab_temp_variables/FFunits') ;

for iBin = 1:length(swdBins)-1
    spikeIDXs = find(allUnits >= swdBins(iBin) & allUnits < swdBins(iBin+1)) ;
    spikeTimes = allUnits(spikeIDXs) ;
    spikeFreq(iBin) = mean(1./(diff(spikeTimes))) ;    
    clear spikeIDXs spikeTimes
end
