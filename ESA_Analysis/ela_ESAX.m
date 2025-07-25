function ela_ESAX(mouseID,topDir,pdfBase)
    spikeDir = sprintf('%s00%d\\analyzedData',topDir,mouseID);
    [~,chans] = psr_makeSpikeArray(spikeDir);
    chans = chans + 1; % making it 1-indexed
    chanList = unique(chans);

    % --- Retrieve electrode locations and remove the ones with no well isolated neurons --- %
    try % skip if electrodeLocations.mat can't be found
        try
            elPath = sprintf('%s00%d\\anatomyData\\electrodeLocations.mat',topDir,mouseID);
            load(elPath,'electrodeLocations');
        catch
            elPath = sprintf('%s00%d\\anatomyData\\forCode\\electrodeLocations.mat',topDir,mouseID);
            load(elPath,'electrodeLocations');
        end
    catch
        return
    end
    electrodeLocations = electrodeLocations(chanList,2); % only keep electrodes that had at least 1 well isolated unit
    % -------------------------------------------------------------------------------------- %


    % --- Convert Allen Atlas structure names to our own specific list of structure names --- %
    load('StructureCoder.mat','sc'); % load up the "structureCoder" cell array
    for ei = 1:numel(electrodeLocations)
        matches(ei) = false;
        for sci = 1:size(sc,1)
            if contains(electrodeLocations(ei), sc(sci,2),'IgnoreCase',true)
                electrodeLocations{ei} = sc{sci,1}; % change to our naming scheme
                matches(ei) = true;
                break
            end
        end
    end
    electrodeLocations(~matches) = []; % remove channels in non-ROI regions
    chanList(~matches) = []; % remove channels in non-ROI regions
    % --------------------------------------------------------------------------------------- %


    % ----- Perform the actual PETH, Autocorr, and phase analysis ----- %
    [AC, OI, swdpeth, trpeth, PA] = ESA_PETHandXCorr(mouseID,chanList);
    % ----------------------------------------------------------------- %


    % --- Set figure size and position --- %
    x0 = 400;
    y0 = 75;
    width = 1200;
    height = 900;
    pdfName = sprintf('%s00%d_summary.pdf',pdfBase,mouseID);
    if isfile(pdfName)
        delete(pdfName);
    end
    % ------------------------------------ %

    
    % --- Calculate means across SWDs and troughs --- %
    mswdp.starts = squeeze(mean(swdpeth.starts,2));
    mswdp.ends = squeeze(mean(swdpeth.ends,2));
    mtrpeth = squeeze(mean(trpeth.data,2));
    % ----------------------------------------------- %


    [G, NAME] = findgroups(electrodeLocations); % find groups
    gids = unique(G);
    Gout = {}; % intialize output array
    oi = {}; % intialize oscillation index array
    for gi = 1:numel(gids)
        clog = G == gi; % get indices to current group
        cName = NAME{gi};
        hd = sprintf('Mouse00%d - %s \n',mouseID,cName);
        NE = sum(clog); % number of electrodes
        cf = figure;
        set(gcf,'position',[x0,y0,width,height])

        % --- Autocorrelations and OI --- %
        sax(1) = subplot(2,2,1);
        meanAC = mean(AC.ic(clog,:),1);
        psr_plotMeanSTE(sax(1),AC.lags,AC.ic(clog,:),'ste');
        % plot(AC.lags,meanAC,'k','LineWidth',2);
        xlabel('Time (seconds)');
        title(sprintf('%sIctal Autocorrelation',hd));

        % --- SWD start --- %
        meanStarts = mean(mswdp.starts(clog,:),1);
        Gout{gi,2} = meanStarts;
        sax(2) = subplot(2,2,2);
        psr_plotMeanSTE(sax(2),swdpeth.time,mswdp.starts(clog,:),'ste');
        % plot(swdpeth.time,meanStarts,'k','LineWidth',2);
        drawnow;
        yl = get(gca,'YLim');
        hold on
        plot([0 0],yl,'r--');
        hold off
        title(sprintf('%d electrodes\nSWD Start',NE));
        xlabel('Time from SWD start (sec)')

        % --- Peri-trough ESA --- %
        ctPETH = mean(mtrpeth(clog,:),1);
        Gout{gi,4} = ctPETH;
        sax(3) = subplot(2,2,3);
        psr_plotMeanSTE(sax(3),trpeth.time,mtrpeth(clog,:),'ste');
        % plot(trpeth.time,ctPETH,'k','LineWidth',2);
        drawnow;
        yl = get(gca,'YLim');
        hold on
        plot([0 0],yl,'r--');
        hold off
        xlabel('Time from EEG Trough (seconds)')
        title('Peri-trough ESA');

        % --- SWD end --- %
        meanEnds = mean(mswdp.ends(clog,:),1);
        Gout{gi,3} = meanEnds;
        sax(4) = subplot(2,2,4);
        psr_plotMeanSTE(sax(4),swdpeth.time,mswdp.ends(clog,:),'ste');
        % plot(swdpeth.time,meanEnds,'k','LineWidth',2);
        drawnow;
        yl = get(gca,'YLim');
        hold on
        plot([0 0],yl,'r--');
        hold off
        xlabel('Time from SWD end (sec)')
        title('SWD Ends');

        % --- Add to output array --- %
        Gout{gi,1} = cName;
        pt.swd = swdpeth.time; % PETH time vectors for SWDs
        pt.tr = trpeth.time; % PETH time vectors for troughs (negative peaks)

        set(gcf().Children,'FontSize',18)
        exportgraphics(cf, pdfName, 'Append', true)
        close all;
        oi{gi,1} = NAME{gi};
        oi{gi,2} = mean(OI.ic(clog));
        oi{gi,3} = mean(OI.nonic(clog));
        % oi{gi,3} = std(OI.ic(clog)-OI.nonic(clog));
        oi{gi,4} = NE;
        oi{gi,5} = mean(mswdp.starts(clog,:),1);
        oi{gi,6} = mean(mswdp.ends(clog,:),1);
        oi{gi,7} = swdpeth.time;
        oi{gi,8} = mean(mtrpeth(clog,:),1);
        oi{gi,9} = trpeth.time;

        pa(gi).mvl_norm = mean([PA(clog).mvl_norm]);
        pa(gi).mi = mean([PA(clog).mi]);
        cP = reshape([PA(clog).P],size(PA(1).P,2),NE)';
        pa(gi).P = mean(cP,1);
        pa(gi).NE = NE;
        pa(gi).name = NAME{gi};
        
        phaseP  = mean([PA(clog).bin_centers]);                 % get phases
        complex_vector = pa(gi).P .* exp(1i * phaseP);          % compute complex vector (mean probability distrubtion x phase)
        pa(gi).preferred_phase = angle(sum(complex_vector));    % get the phase angle of the summed complex vector (i.e. which angle is the vector pointing to?)
    
    end

    % --- Save the oscillation index and phase analysis output --- %
    oiName = sprintf('%s00%d_oi.mat',pdfBase,mouseID);
    if isfile(oiName)
        delete(oiName);
    end
    save(oiName,'oi','pa','Gout','pt','-v7.3');

end % function end