function elasPeakToValleyRatios = sortP2Vtable(elasPeakToValleyRatios, mouseStrain, unitType, cycleType, highRatioThreshold, lowRatioThreshold)
% parent function: collectAllPeakToVallyRatios.m

%%
% highRatioThreshold refers to histograms wherein the Peak-To-Valley
% difference is great. lowRatioThreshold is the opposite. Mark included the
% low ratio (Caudate) so that figure includes a low ratio structure

%%
elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType) = sortrows(elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType), 'PeakBin', 'ascend') ;
nonZeroRatios = find(elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType).LumpedP2Vratio > 0) ;

elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Lumped = elasPeakToValleyRatios.(mouseStrain).P2V.(unitType).(cycleType)(nonZeroRatios, :) ;

%% get structures with high P2 ratios (greater than highRatioThreshold)
highRatios = find(elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Lumped.LumpedP2Vratio>highRatioThreshold) ;

%% get structures with low P2 ratios (lower than lowRatioThreshold)
lowRatios = find(elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Lumped.LumpedP2Vratio<lowRatioThreshold) ;

allRatioKeepers = [highRatios; lowRatios] ;
elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Filtered = elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Lumped(allRatioKeepers, :) ;
dontInclude1 = find(strcmpi([elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Filtered.ElasStructureName{:}], 'Paracentral_nucleus') ==1) ;
dontInclude2 = find(strcmpi([elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Filtered.ElasStructureName{:}], 'Hippocampal_formation') ==1) ;
elasPeakToValleyRatios.(mouseStrain).(unitType).(cycleType).Filtered([dontInclude1, dontInclude2], :) = [] ;
% elasPeakToValleyRatios.gria.Lumped = lumpedTemp ;