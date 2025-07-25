%%
tm = allspk{1,2}{1}.SPIKE.time;
prf = allspk{1,2}{1}.SPIKE.profile;
spks = allspk{1,2}{1}.spikes;

%%
figure;
sax(1) = subplot(211);
hold on
for ni = 1:numel(spks)
    yvals = ni*ones(1,numel(spks{ni}));
    scatter(spks{ni},yvals,"|k")
end
hold off
sax(2) = subplot(212);
plot(tm,prf,'k');
linkaxes(sax,'x');

