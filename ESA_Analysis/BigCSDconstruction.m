%%
bigCSD = [];
for ci = 1:numel(CSD)
    bigCSD = cat(3,bigCSD,CSD(ci).mat);
end

%%
figure;
imagesc(mean(bigCSD,3));