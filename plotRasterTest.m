function plotRasterTest(units, mColor, yLine)
% parent function: smallDataBaseTest.m

%%
% save('/home/mark/matlab_temp_variables/POLOTTES')
% ccc
% load('/home/mark/matlab_temp_variables/POLOTTES')

%%
for iUnit = 1:size(units,1)
    currentUnits = units{iUnit} ;
    plot(currentUnits, ones(length(currentUnits),1)*yLine(1), '|', 'MarkerFaceColor', rgb(mColor), 'MarkerEdgeColor', rgb(mColor))
    % for iCurrentUnit =1:length(currentUnits)
        % plot([currentUnits(iCurrentUnit), currentUnits(iCurrentUnit)], yLine, 'color', rgb(mColor), 'LineWidth', 0.1);
        hold on
    % end
    clear currentUnits
end