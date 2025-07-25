%%
load('S:\intanData\ela\markTemp\0043\detectedSeizures\0043_detectedSeizures002.mat','curated_seizures');
load('C:\Ela_ESA\0043\timevec.mat','timevec');
cch = 11;
ESAfp = sprintf('C:\\Ela_ESA\\0043\\ch%d.bin',cch);
fid = fopen(ESAfp);
ESA = fread(fid,'double');
% ESA=zscore(ESA);
% -- Remove 'type 3' seizures -- %
rmLog = strcmp({curated_seizures.type},'3');    % find type 3s
curated_seizures(rmLog) = [];                   % remove type 3s
sz = curated_seizures; % curated_seizures is too long a name


% %%
% fprintf('Channel %d processing...\n',cch);
% [szESA] = psr_ESAPhase(ESA,timevec,sz);

esaTF = cell2mat(szESA')';
szESAvec = esaTF(:);
nbins = size(szESA{1},2);
repz = size(esaTF,2);
phaseVec = linspace(-pi,pi,nbins)'; % make corresponding phase vector
phaseESA = repmat(phaseVec,[repz 1]);


%% == Compute MVL == %%
esaSTD = std(ESA);
complex_vector = szESAvec .* exp(1i * phaseESA); % Compute complex vector
mvl = abs(mean(complex_vector)); % take the absolute value of the mean to get MVL (mean vector length)

mean_vector = sum(complex_vector) / sum(szESAvec);  % normalized weighted mean
mvl_norm = abs(mean_vector);  % Normalized strength of phase locking  (0 - none, 1 - max)
preferred_phase = angle(mean_vector);  % in radians, from -π to π

%% == Compute MI == %%
edges = linspace(-pi, pi, nbins + 1);
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

amp_per_bin = sum(esaTF,2)';

% Normalize to get a probability distribution
P = amp_per_bin / sum(amp_per_bin);

% Avoid log(0)
P(P == 0) = eps;

% Compute Shannon entropy and modulation index
H = -sum(P .* log(P));
Hmax = log(nbins);
mi = (Hmax - H) / Hmax;

%%
figure;
pc = [bin_centers,bin_centers(1)];
pt = [P,P(1)];
polarplot(pc,pt,'k',"LineWidth",2);
rlim([0 0.025])
