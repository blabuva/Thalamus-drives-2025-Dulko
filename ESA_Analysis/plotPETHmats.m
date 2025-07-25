%% Plot Loop
figure;
kp = 0;
ssi = 1;
tri = 0;
maxssi = numel(ptCell);
maxtri = size(ptCell{ssi},3);
colormap(flipud(gray));
while ~kp && ssi <= maxssi
    kp = waitforbuttonpress;
    if kp
    tri = tri+1;
    zMat = zscore(ptCell{ssi}(:,:,tri),0,2);
    imagesc(tv,1:256,zMat);
    clim([-4 4]);
    title(sprintf('Seizure %d - Trough %d',ssi,tri));
    kp = 0;
    if tri == maxtri
        ssi = ssi + 1;
        tri = 0;
        maxtri = size(ptCell{ssi},3);
    end
    end
end