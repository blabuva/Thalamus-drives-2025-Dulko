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

end

swds = cell2mat(OI(:,5)); % SWD starts
swde = cell2mat(OI(:,6)); % SWD ends
pnp = cell2mat(OI(:,8));  % peri-negative peaks 

%% == Reorder the matrix rows by custom order below == %
customOrder = ["VPM", "LD", "CA3","Primary somatosensory cortex","PO","Dentate gyrus","VPL","CL","MD",...
    "LP","Subthalamic nucleus","Paraventricular nucleus","Medial Habenula","Basal ganglia",...
    "Lateral Habenula", "CA2","CA1","Primary motor cortex","Paracentral nucleus","HF","Reticular Thalamus",...
    "Ethmoid nucleus","Hypothalamus","LGN","Caudoputamen"]';
[~, groupIdx] = ismember(PAnames, customOrder);
% [~, groupIdx] = ismember(PAnames, names); % Get indices for sorting based on custom order
[~, sortIdx] = sort(groupIdx);% Combine with row index to preserve relative order within groups (if desired, e.g., stable sort)
PAnames_sorted = PAnames(sortIdx);
% [G, nameOrder] = findgroups(PAnames);
groupMean = @(rows) mean(rows, 1);     % Mean along rows, keep as row vector
% Apply mean to each group
% [G, NAME] = findgroups(PAnames_sorted); % find groups
[~, G] = ismember(PAnames_sorted, customOrder);

%%
swds_sorted = swds(sortIdx, :);
meanVectors = splitapply(groupMean, swds_sorted, G);
adjVectors = meanVectors-min(meanVectors(:));% swde_sorted = swde(sortIdx,:);
% meanVectors = splitapply(groupMean, swde_sorted, G);

% pnp_sorted = pnp(sortIdx,:);
% meanVectors = splitapply(groupMean, pnp_sorted, G);

%
smoothwin = 300;
cdata = meanVectors;
smData = smoothdata(cdata,2,"movmean",smoothwin);
figure;
imagesc(pt.swd,1:size(cdata,1),smData);

% clim([-.5 .55])
xlim([-10 2])

% imagesc(A);              % A is your color matrix
yticks(1:size(cdata,1));     % Set a tick for every row
yticklabels(customOrder)

%%
for nr = 1:size(adjVectors,1)
figure;
plot()
end