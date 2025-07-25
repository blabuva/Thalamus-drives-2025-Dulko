function [averageLFP]  = calcAverageLFPcycle(LFPblue,LFPred)
% parent function: phaseExample.m 

%  need to match the lengths via interpolation 
commonLength = max(length(LFPblue), length(LFPred)); 
tBlue = linspace(0,1,length(LFPblue));
tRed = linspace(0,1,length(LFPred));
tCommon = linspace(0,1,commonLength); 

LFPblue_resampled = interp1(tBlue,LFPblue,tCommon,"linear"); 
LFPred_resampled = interp1(tRed,LFPred,tCommon,"linear");


% calc average LFP 
averageLFP = (LFPblue_resampled + LFPred_resampled) / 2; 



end 