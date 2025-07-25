function [perCycle, perSWD] = phaseNittyGritty(data, binSize) 
% parent function: phaseThatDatabase.m

save('/home/mark/matlabTemp/PNG')
% ccc
% load('/home/mark/matlabTemp/PNG')

%%
% binSize = 0.01 ;
binEdges = 0:binSize:1 ;

%%
for iCluster = 1:size(data,1)
    currentPhases = data.Phase{iCluster} ;
    % if iCluster == 39
    %     x = 1
    % end
    if ~isempty(currentPhases)
        uniqueCycles = unique(currentPhases.CycleNumber) ;
        for iCycle = 1:length(uniqueCycles)
            cyclePhases = currentPhases.Phase(find(currentPhases.CycleNumber == uniqueCycles(iCycle))) ;
            cyclePhaseHistCount(iCycle, :) = histcounts(cyclePhases, binEdges) ;
        end
        twoCycleCyclePhaseHistCount = [cyclePhaseHistCount, cyclePhaseHistCount] ;
        swdPhaseHistCount = sum(cyclePhaseHistCount,1) ;
        twoCycleSwdPhaseHistCount = [swdPhaseHistCount, swdPhaseHistCount] ;
        data.CyclePhaseHist{iCluster} = twoCycleCyclePhaseHistCount ;
        data.swdPhaseHist{iCluster} = twoCycleSwdPhaseHistCount ;
        clear currentPhases uniqueCycles cyclePhases cyclePhaseHistCount twoCycleCyclePhaseHistCount ...
            swdPhaseHistCount twoCycleSwdPhaseHistCount
    end
end

%%
% any("CyclePhaseHist" == string(data.Properties.VariableNames))%%


if any("CyclePhaseHist" == string(data.Properties.VariableNames))
    perCycle = cat(1,data.CyclePhaseHist{:,:}) ;
else
    perCycle = [] ;
end

if any("swdPhaseHist" == string(data.Properties.VariableNames))
    perSWD = cat(1,data.swdPhaseHist{:,:}) ;
else
    perSWD = [] ;
end

%% 
