%%
basePath = 'S:\intanData\ela\markTemp\';

for di = 1:numel(dList)
    pathToData = sprintf('%s%s',basePath,dList{di});
    outdir = sprintf('C:\\Ela_ESA\\%s',dList{di});
    mkdir(outdir);
    % try
        computeESA(pathToData,outdir);
    % catch
        fprintf('%s failed\n',dList{di});
    % end
end

%%
basePath = 'S:\intanData\ela\markTemp\';
mouseList = [65,66,68];
for mi = 1:numel(mouseList)
    mouseID = mouseList(mi);
    oi = {}; % intialize oscillation index output
    fprintf('Processing mouse00%d...\n',mouseID)
    % try
    [AC, OI, swdpeth, trpeth] = ESA_PETHandXCorr(mouseID);
    % === Making big figures === %
    % --- Load in electrode locations --- %
    try
        elPath = sprintf('%s00%d\\anatomyData\\electrodeLocations.mat',basePath,mouseID);
        load(elPath,'electrodeLocations');
    catch
        elPath = sprintf('%s00%d\\anatomyData\\forCode\\electrodeLocations.mat',basePath,mouseID);
        load(elPath,'electrodeLocations');
    end


    % --- Set figure size and position --- %
    x0 = 400;
    y0 = 75;
    width = 1200;
    height = 900;
    pdfName = sprintf('C:\\Ela_ESA\\00%d_summary.pdf',mouseID);
    if isfile(pdfName)
        delete(pdfName);
    end
    % --- Ca,lculate means across SWDs and troughs --- %
    mswdp.starts = squeeze(mean(swdpeth.starts,2));
    mswdp.ends = squeeze(mean(swdpeth.ends,2));
    mtrpeth = squeeze(mean(trpeth.data,2));

    [G, NAME] = findgroups(electrodeLocations(:,2)); % find groups
    gids = unique(G);
    Gout = {}; % intialize output array
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
        plot(swdpeth.time,meanEnds,'k','LineWidth',2);
        drawnow;
        yl = get(gca,'YLim');
        hold on
        plot([0 0],yl,'r--');
        hold off
        xlabel('Time from SWD end (sec)')
        title('SWD Ends');

        % --- Add to output array --- %
        Gout{gi,1} = cName;

        set(gcf().Children,'FontSize',18)
        exportgraphics(cf, pdfName, 'Append', true)
        close all;
        oi{gi,1} = NAME{gi};
        oi{gi,2} = mean(OI.ic(clog)-OI.nonic(clog));
        oi{gi,3} = std(OI.ic(clog)-OI.nonic(clog));
        oi{gi,4} = NE;


    end % group loop

    cellName = sprintf('C:\\Ela_ESA\\00%d_oi.mat',mouseID);
    if isfile(cellName)
        delete(cellName);
    end    
    save(cellName,'oi','-v7.3');

    % catch
    % fprintf('Mouse00%d failed\n',mouseID);
    % end % whole loop try/catch
end % mouse loop





