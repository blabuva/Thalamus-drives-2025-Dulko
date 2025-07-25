function [meanPhase, CIphase, meanEngagement, CIengagement]  = calculatePhaseStats(meanPhaseNeuronForOneSWD, meanEngagementforOneSWD) 
% parent function: summarizeThosePhasePlots.m
% based on: https://www.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval

% save('/home/mark/matlab_temp_variables/meanCI')
% ccc
% load('/home/mark/matlab_temp_variables/meanCI')

%% calculate means
meanPhase = mean(meanPhaseNeuronForOneSWD) ;
meanEngagement = mean(meanEngagementforOneSWD) ;

%% calculate SEM
SEMphase = std(meanPhaseNeuronForOneSWD)/sqrt(length(meanPhaseNeuronForOneSWD)) ;
SEMengagement = std(meanEngagementforOneSWD)/sqrt(length(meanEngagementforOneSWD)) ;

%% t score
tScore = tinv([0.025 0.975], length(meanPhaseNeuronForOneSWD)-1) ;

%% conf intervals
CIphase = meanPhase + tScore*SEMphase ;
CIengagement = meanEngagement + tScore*SEMengagement ;