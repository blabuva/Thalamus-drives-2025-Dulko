%%
clear all
load('\\172.28.76.244\probeX\intanData\ela\markTemp\0042\analyzedData\SPIKYoutput.mat','allspk');
%%
br = 1; % brain region
szn = 1; % seizure number
figure;
szwv = allspk{br,2}{szn}; % seizure window
% timev = szwv.SPIKE.time;
% prof = szwv.SPIKE.profile;
timev = szwv.SPIKE_synchro.time;
prof = szwv.SPIKE_synchro.profile;
subplot(411);
hold on
for ni = 1:numel(szwv.spikes)
    nspk = numel(szwv.spikes{ni});
    yv = ones(nspk,1)*ni;
    scatter(szwv.spikes{ni},yv,'r|');
end
hold off
subplot(412);
plot(timev,prof,'r');
ylim([0 1]);

szwv = allspk{br,3}{szn};
subplot(413);
hold on
for ni = 1:numel(szwv.spikes)
    nspk = numel(szwv.spikes{ni});
    yv = ones(nspk,1)*ni;
    scatter(szwv.spikes{ni},yv,'k|');
end
hold off
subplot(414);
% -- non-seizure window -- %
% timev = szwv.SPIKE.time;
% prof = szwv.SPIKE.profile;
timev = szwv.SPIKE_synchro.time;
prof = szwv.SPIKE_synchro.profile;
plot(timev,prof,'k');
ylim([0 1]);

%%
for ni = 1:numel(szwv.spikes)
    nspk = numel(szwv.spikes{ni});
    yv = ones(nspk,1)*ni;
    scatter(szwv.spikes{ni},yv,'|');
end
