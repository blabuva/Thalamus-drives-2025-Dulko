%% clear all
ccc

tic

%% path to excel
xlPN = '/media/shareX/intanData/intanExperimentList' ;


%% load excel
xlData = readtable(xlPN) ;

%% run through analysis loop
for iXL = 1:size(xlData,1)
    currentRow = xlData(iXL, :);
    if strcmp(currentRow.Analyze_, 'Y')
        intanAlyzer_mpb_2022_04_03(currentRow)
    end
end

