function [DataWithPInh] = rankSumPhaseInh(organizedDataInh,uniqueStructures)
% parent function: masterInhPlotter.m 

DataWithPInh = organizedDataInh; 

% do one brain structure for now 
for iUniqBrain = 1:size(uniqueStructures,1)


    x = organizedDataInh{iUniqBrain,2}; % non SWDs 
    if isempty(x) 
        DataWithPInh{iUniqBrain,4} = 1; % set a fake p value just so there is a value 
        DataWithPInh{iUniqBrain,5} = 'CantCalculate';
    else
        y = organizedDataInh{iUniqBrain,3}; % SWDs 
        [p,h] =  ranksum(x,y); 
        DataWithPInh{iUniqBrain,4} = p; 
            if p<0.05
               DataWithPInh{iUniqBrain,5} = 'Yes';  
            else 
                DataWithPInh{iUniqBrain,5} = 'No'; 
            end
    
    % Interpretation: 
    %If p < 0.05: The distributions of x and y are significantly different.
    %If p > 0.05: There is no strong evidence to conclude a difference between the distributions.
    
    
    end 
end

% visualize one brain structure to check the code 
% figure; 
% subplot(1,2,1); ylim([0 800]);
% bar(x); 
% subplot(1,2,2); bar(y); 
% 
% 
% figure; 
% subplot(1,2,1); heatmap(x); colormap('parula');
% subplot(1,2,2); heatmap(y); colormap('parula'); clim([0 900]); 

end % function end 