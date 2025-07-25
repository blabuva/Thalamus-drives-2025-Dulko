function   comboed = comboTheWhittledTable(whittled) 
% % parent function = combineStructuresForUnits.m
% 
% save('C:\Users\markb\Desktop\Matlab\Combowhittler')
% clear all; close all; clc ;
% load('C:\Users\markb\Desktop\Matlab\Combowhittler')

%% create table place holder for comboed table
comboed = whittled(1,:)  ;

%% get table header names
headers = whittled.Properties.VariableNames ;

for iHeader = 1:length(headers)
    headerData = whittled.(headers{iHeader}) ;
    % dataClass = class(headerData{1})
    sumVal = 0 ;
    cattedCells = {} ;
    cattedMatrix = [] ;
    for iData = 1:length(headerData)
       if ~isempty(headerData{iData})
            dataClass = class(headerData{iData})  ;
            if strcmp(dataClass, 'char')
                theString = headerData{iData} ; 
            elseif strcmp(dataClass, 'cell') 
                cattedCells = [cattedCells, headerData{iData}] ;
            elseif strcmp(dataClass, 'double') 
                if size(headerData{iData},2) == 1 
                    sumVal = sumVal + headerData{iData} ;
                else
                    cattedMatrix = [cattedMatrix; headerData{iData}] ;
                end
            end
        end
    end
    if exist('theString')
        comboed.(headers{iHeader}) = convertCharsToStrings(theString) ;
    elseif sumVal > 0 %|| length(sumVal) > 1
        comboed.(headers{iHeader}) = sumVal ;
    elseif ~isempty(cattedMatrix)
        comboed.(headers{iHeader}){1} = cattedMatrix ;
    elseif ~isempty(cattedCells)
        comboed.(headers{iHeader}){1} = cattedCells ;
    end
    clear theString
end




