function allCentersTable = calcMatrixCentroids(theMonsters) 


for iRow = 1:size(theMonsters.monsterSWD.Matrix,1)
    histogram_data = theMonsters.monsterSWD.Matrix(iRow,50:150) ;
    bin_edges = 0:1:length(histogram_data);
    % Calculate the center of mass
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
    center_of_mass = (sum(histogram_data .* bin_centers) / sum(histogram_data)) -50;
    allCenters(iRow,:) = [iRow, center_of_mass, sum(histogram_data)] ;
    clear bin_centers bin_edges center_of_mass histogram_data
end

%% plot
allCentersFlip = flipud(allCenters) ;
allCentersTable = array2table(allCentersFlip, 'VariableNames', {'RowNum', 'Centroid', 'NumSpikes'}) ;
allCentersTable.SmoothCentroid = allCentersTable.Centroid ;
% allCentersTable.SmoothCentroid = smooth(allCentersTable.Centroid, 20) ;

%% temp plot
Quants = quantile(allCentersFlip(:,3), 3)  ;
allCentersTable = colorThoseQuants(allCentersTable, Quants) ;

smoothAllcenters = allCenters(:,2);
% smoothAllcenters = smooth(allCenters(:,2), 1) ;