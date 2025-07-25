function twoCycleMatrix = makeAllCyclePhaseMatrix(allExperiments) 
% parent function = monsterUnitPhase.m

% save('/home/mark/matlab_temp_variables/allCycleMatrix')
% ccc
% load('/home/mark/matlab_temp_variables/allCycleMatrix')

%% make a vector that defines the border between neurons 
borderWidth = 50 ;
neuronBorderVal = -1 ;
neuronBorder = ones(borderWidth, size(allExperiments{1}.EachCycle{1},2)) * neuronBorderVal ;

%% make a vector that defines the border between experiments 
exptBorderVal = -2 ;
exptBorder = ones(borderWidth, size(allExperiments{1}.EachCycle{1},2)) * exptBorderVal ;


%%
cycleMatrix = [] ;
for iExpt = 1:length(allExperiments)
    currentExpt = allExperiments{iExpt} ;
    for iNeuron = 1:size(currentExpt,1)
        cycleMatrix = [cycleMatrix; currentExpt.EachCycle{iNeuron}] ;
%         cycleMatrix = [cycleMatrix; neuronBorder] ;
    end
%     cycleMatrix = [cycleMatrix; exptBorder] ;
end

%% duplicate cycleMatrix 
twoCycleMatrix = [cycleMatrix, cycleMatrix] ;
% imagesc(twoCycleMatrix)
% 
% %% make colormap
% % colors = {'red'; 'Lime'; 'Black'; 'White'; 'Yellow'} ;
% colors = {'Black'; 'White'; 'Yellow'} ;
% for iColor =1:length(colors)
%     myCmap(iColor, :) = rgb(colors{iColor}) ;
% end
% colormap(myCmap)






