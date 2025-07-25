function plotUnitSampleSize(allDataTable, brainNames)
% parent function: aggraPhase.m

set(groot,'defaultAxesTickLabelInterpreter','none');   
subplot(2,1,1)
    bar(cell2mat(allDataTable.SWDs.NumberOfMice), 'k')
    xticks([1:length(brainNames)])
    xticklabels(brainNames)
    xtickangle(45)
    title('Number of Mice', 'fontsize', 18)

subplot(2,1,2)    
    neuronVals = cell2mat(allDataTable.SWDs.NumberOfNeurons) ;
    bar(neuronVals, 'k')
    ylim([0 max(neuronVals)*1.2])
    text(0.75:numel(neuronVals),neuronVals+5,num2cell(neuronVals))
    xticks([1:length(brainNames)])
    xticklabels(brainNames)
    xtickangle(45)
    title('Number of Neurons', 'fontsize', 18)

%%
set(gcf, 'units', 'normalized', 'position', [0.01 0.01 0.6 0.8])