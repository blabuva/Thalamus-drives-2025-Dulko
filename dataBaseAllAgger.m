%% 
% ccc
% 
% %% load data base 1
% dataBase_01 = load('/media/elaX/intanData/ela/individualExperimentDataBase/2024_01_03__12_18_55/2024_01_03__12_18_55_allDataBases.mat') ;
% 
% %% load data base 2
% dataBase_02 = load('/media/elaX/intanData/ela/individualExperimentDataBase/2024_01_05__15_57_59/2024_01_05__15_57_59_allDataBases.mat') ;

%%
close all; clc; 
keep dataBase_01 dataBase_02

%% concat
allDataBases = [dataBase_01.allDataBases; dataBase_02.allDataBases] ;

%% structures
structures = unique(allDataBases.Structure) ;

%% find LD
LDindex = find(strcmpi(allDataBases.Structure, structures{14}) == 1) ;

%% get all LD experiments
LDtableAll = allDataBases(LDindex, :) ;

%% get LD for experiment 0024
LDtable0024 = LDtableAll(1:18, :) ;

%% save tables
save('/media/shareX/johnm/mostlyCompleteDataBase', 'allDataBases') ;
save('/media/shareX/johnm/LDtable0024', 'LDtable0024') ;

