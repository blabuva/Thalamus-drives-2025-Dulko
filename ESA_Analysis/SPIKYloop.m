%% 
for szi = 1:numel(allspk{1,2})
    SPIKE_ovall_seiz(szi) = allspk{1,2}{szi}.SPIKE.overall;
    SPIKE_ovall_nonseiz(szi) = allspk{1,3}{szi}.SPIKE.overall;
    SYNCH_ovall_seiz(szi) = allspk{1,2}{szi}.SPIKE_synchro.overall;
    SYNCH_ovall_nonseiz(szi) = allspk{1,3}{szi}.SPIKE_synchro.overall;
end

%%
for szi = 1:numel(allspk{1,2})
figure;
subplot(211);
cspk = allspk{1,2}{szi}.SPIKE_synchro;
plot(cspk.time, cspk.profile);
title(sprintf('Seizure %d',szi));
ylim([0 .8])
subplot(212);
cspk = allspk{1,3}{szi}.SPIKE_synchro;
plot(cspk.time, cspk.profile);
title(sprintf('Non-seizure %d',szi));
ylim([0 .8])

end