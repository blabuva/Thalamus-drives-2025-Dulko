%%
% dd = dir('C:\Ela_ESA');
dd = dir('C:\Users\Scott\Documents\ElaAnalysis\Figures\ESA_AutoCorr+PETH');
keepLog = contains({dd.name},'.mat');
dd(~keepLog) = [];
OI = {};
PAnames = {};
MVL = [];
MI = [];
PA = [];
pp = [];
for ii = 1:size(dd,1)
    load(fullfile(dd(ii).folder,dd(ii).name),'oi','pa','pt');
    % toi = cell2mat(oi(:,[2,3]));
    % diffOI = toi(:,1)-toi(:,2);
    % diffOI = num2cell(diffOI);
    % coi = [oi(:,1), diffOI, oi(:,4)];
    OI = [OI;oi];
    MVL = [MVL;[pa.mvl_norm]'];
    MI = [MI;[pa.mi]'];
    PAnames = [PAnames;{pa.name}'];
    for pai = 1:numel(pa)
        pp = [pp; pa(pai).P];
    end
end

swds = cell2mat(OI(:,5)); % SWD starts
swde = cell2mat(OI(:,6)); % SWD ends
pnp = cell2mat(OI(:,8));  % peri-negative peaks

nbins = numel(pa(1).P);
shiftN = nbins/2;
edges = linspace(-pi, pi, nbins + 1);               % edges of phase bins
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;  % centers of phase bins
bin_centers = circshift(bin_centers,shiftN);        % shifting the bin_centers appropriately
%% === Find preferred phase for every row === %%
for pii = 1:size(pp,1)
    complex_vector = pp(pii,:) .* exp(1i * bin_centers);          % compute complex vector (mean probability distrubtion x phase)
    prefPhase(pii) = angle(sum(complex_vector));
    % newVec = [complex_vector, complex_vector(1)];
    % figure; polarplot(newVec);
end

%%
for pii = 1:size(meanVectors,1)
    complex_vector = meanVectors(pii,:) .* exp(1i * bin_centers);          % compute complex vector (mean probability distrubtion x phase)
    mva_pp(pii) = angle(sum(complex_vector));
        avgMVL(pii) = abs(sum(complex_vector));
end

%% == Reorder the matrix rows by custom order below == %
customOrder = ["VPM", "LD", "CA3","Primary somatosensory cortex","PO","Dentate gyrus","VPL","CL","MD",...
    "LP","Subthalamic nucleus","Paraventricular nucleus","Medial Habenula","Basal ganglia",...
    "Lateral Habenula", "CA2","CA1","Primary motor cortex","Paracentral nucleus","HF","Reticular Thalamus",...
    "Ethmoid nucleus","Hypothalamus","LGN","Caudoputamen"]';
[~, groupIdx] = ismember(PAnames, customOrder);
% [~, groupIdx] = ismem(PAnames, names); % Get indices for sorting based on custom order
[~, sortIdx] = sort(groupIdx);% Combine with row index to preserve relative order within groups (if desired, e.g., stable sort)
PAnames_sorted = PAnames(sortIdx);
% [G, nameOrder] = findgroups(PAnames);
groupMean = @(rows) mean(rows, 1);     % Mean along rows, keep as row vector
% Apply mean to each group
% [G, NAME] = findgroups(PAnames_sorted); % find groups
[~, G] = ismember(PAnames_sorted, customOrder);

%% == Pick starts, negative peaks, or ends
% dSorted = swde(sortIdx,:); % SWD Ends 
% dSorted = pnp(sortIdx,:); % peri-negative peaks
dSorted = pp(sortIdx,:);
% --- SWD Starts --- %
% swds_sorted = swds(sortIdx, :);
% meanVectors = splitapply(groupMean, dSorted, G);



% --- Peri-negative peaks --- %

meanVectors = splitapply(groupMean, dSorted, G);
% adjVectors = meanVectors-min(meanVectors(:));% swde_sorted = swde(sortIdx,:);

% pnp_sorted = pnp(sortIdx,:);
% meanVectors = splitapply(groupMean, pnp_sorted, G);

%
% smoothwin = 3000;
smoothwin = 1;
cdata = meanVectors;
smData = smoothdata(cdata,2,"movmean",smoothwin);
figure;
% imagesc(pt.swd,1:size(cdata,1),smData);
imagesc(pt.tr,1:size(cdata,1),smData);
% clim([-.5 .55])
xlim([-0.25 0.25])

% imagesc(A);              % A is your color matrix
yticks(1:size(cdata,1));     % Set a tick for every row
yticklabels(customOrder)

%% SAVE AS SEPARATE SVGs in directory, THEN IMPORT ONE AT A TIME %%
cf = figure;
set(cf,'renderer','painters');
numrows = size(adjVectors,1);
    % saveName = 'Z:\Figures\Ela_ESA_preSWDareas\preSWD.pdf'
basePath = 'Z:\Figures\Ela_ESA_preSWDareas\';
for nr = 1:numrows
    subplot(numrows,1,nr);
    % cf = figure;
    % set(cf,'renderer','painters');

    area(pt.tr,adjVectors(nr,:));
    % xlim([-1 0.3]);
    xlim([-0.09 0.09])
    ylim([0 2])
    ylabel(customOrder(nr));
    drawnow
    % pause(0.5)
    % saveName = sprintf('%s%d.pdf',basePath,nr);
    % set the figure's Renderer property to 'painters' before saving as EPS/SVG:
    % saveas(cf,saveName,'svg');
    % print(cf, saveName, '-vector');
    % exportgraphics(cf, saveName, 'ContentType', 'vector');
    % print(cf, '-dpdf', saveName);  % Save as PDF (vector)
    % close(cf);
end