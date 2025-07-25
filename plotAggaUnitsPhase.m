function allDataTable = plotAggaUnitsPhase(allDataTable, eventType)
% parent function: aggraPhase.m

% save('/home/mark/matlab_temp_variables/aggraPhase')
% ccc
% load('/home/mark/matlab_temp_variables/aggraPhase')

set(0,'DefaultFigureVisible', 'on')
clc
close all
keep allDataTable eventType


%% pare down table
data = allDataTable.(eventType) ;

%% create phase table
% phaseTable =  array2table(data.brainNames, 'VariableNames', {'brainNames'}) ;

%% march through table and make polar plots
% for iBrainPart = 1:size(data,1)
tic
for iBrainPart = 1:size(data,1)
    brainPart = data.brainNames{iBrainPart} ;
   
    SWDsCurrentBrainPart = data.theSWDs{iBrainPart}  ;
    phasesCurrentBrainPart = data.RawPhases{iBrainPart} ;
    psthCurrentBrainPart = data.PSTH{iBrainPart} ;
    instFFCurrentBrainPart = data.InstFF{iBrainPart} ;
    unitsCurrentBrainPart = data.SingleUnitsSWD{iBrainPart} ;
    experimentInfo = getUnitExperimentInfo(data{iBrainPart, 5:7}) ;

    % make polar plase plots wherein radius = number of spikes 
    makeUnitPopPlots(phasesCurrentBrainPart, experimentInfo, SWDsCurrentBrainPart, brainPart, 'polarSpikeCount') ;
    disp(sprintf('%s: Polar Plot (%i out of %i)', brainPart, iBrainPart,size(data,1))) 
    % make polar phase plots according to CircHist
%     makeUnitPopPlots(phasesCurrentBrainPart, experimentInfo, SWDsCurrentBrainPart, brainPart, 'polarCircHist') ; 

    % make raster plot
    makeUnitPopPlots(unitsCurrentBrainPart,  experimentInfo, SWDsCurrentBrainPart,  brainPart, 'rasters') ; 
    disp(sprintf('%s: Raster Plot (%i out of %i)', brainPart, iBrainPart,size(data,1))) 
end

toc
% why

