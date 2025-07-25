function neuronData = calculatePhaseFromDataBase(currentSWD) 
% parent function: unitPhaseFromDataBase.m

% save('/home/mark/matlabTemp/phases')
% ccc
% load('/home/mark/matlabTemp/phases')

%%
unitTypes = fieldnames(currentSWD.singles.SingleUnitsSWD{1}) ;

%% extract times of SWD spikes (i.e. the troughs)
troughTimes = currentSWD.swdProps.SWD_Props{1}.SWD_troughTimes{1} ;

%% extract spike times of all identified single units
 if isfield(currentSWD.singles.SingleUnitsSWD{1}, 'all') == 1
    neuronData.singleALL = array2table(currentSWD.singles.SingleUnitsSWD{1}.all.ClusterID, 'VariableNames', {'ClusterID'}) ;
    neuronData.singleALL.SpikeTimes = currentSWD.singles.SingleUnitsSWD{1}.all.SWD_Spikes ;
 end
%% extract spike times of all identfied EXCITATORY single units
if isfield(currentSWD.singles.SingleUnitsSWD{1}, 'excitatory') == 1
    neuronData.singleEX = array2table(currentSWD.singles.SingleUnitsSWD{1}.excitatory.ClusterID, 'VariableNames', {'ClusterID'}) ;
    neuronData.singleEX.SpikeTimes = currentSWD.singles.SingleUnitsSWD{1}.excitatory.SWD_Spikes ;
end

%% extract spike times of all identfied INHIBITORY single units
if isfield(currentSWD.singles.SingleUnitsSWD{1}, 'inhibitory') == 1
    neuronData.singleIN = array2table(currentSWD.singles.SingleUnitsSWD{1}.inhibitory.ClusterID, 'VariableNames', {'ClusterID'}) ;
    neuronData.singleIN.SpikeTimes = currentSWD.singles.SingleUnitsSWD{1}.inhibitory.SWD_Spikes ;
end

 %% extract spike times of multis
 if isfield(currentSWD.multis.MultiUnitsSWD{1}, 'all') == 1
    neuronData.multi = array2table(currentSWD.multis.MultiUnitsSWD{1}.all.ClusterID, 'VariableNames', {'ClusterID'}) ;
    neuronData.multi.SpikeTimes = currentSWD.multis.MultiUnitsSWD{1}.all.SWD_Spikes ;
end

%% define what classes of neurons to evalulate
neuronClasses = fieldnames(neuronData) ;

%% go through SWD trough times and find neuron spikes that occur within each cycle
for iClass = 1:length(neuronClasses) 
    currentClass = neuronData.(neuronClasses{iClass}) ;
    if ~isempty(currentClass)
        for iNeuron = 1:size(currentClass,1)
            % if iNeuron == 39
            %     x=1 ;
            % end
            currentNeuron = currentClass(iNeuron,:) ;
            currentClass.Phase{iNeuron} = cycleSpikes(currentNeuron, troughTimes) ;
            clear currentNeuron
        end
        neuronData.(neuronClasses{iClass}).Phase = currentClass.Phase ;
    else
        neuronData.(neuronClasses{iClass}).Phase = zeros(0) ;
    end
    clear currentClass
end

