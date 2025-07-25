%% clear all
ccc ;

%% create file to keep track of functions
[fidTracker, fileName] = createFileTrackerName() ;
%fidTracker = fopen('/media/probeX/intanData/ela/elasMasterProbeSheet_2.xlsx','w')
%% Load in Ela's master excel sheet
pathToExcel = '/media/elaX/intanData/elasMasterProbeSheet_2.xlsx' ;
% pathToExcel = '/media/elaX/intanData/ela/elasMasterProbeSheet_ETX.xlsx' ;
%% or

%% Load in Magda's master excel sheet
% pathToExcel = '/media/elaX/LunardiLab/magdasMasterProbeSheet.xlsx' ;

excelTable = readtable(pathToExcel) ;

%% create table for database file names
test = {'blank'};
dataBaseFileTable = array2table(test, 'VariableNames', {'MouseID'}) ;

%% create time stamp for database file dump
timeNow = clock ;
dataBaseTimeStamp = sprintf('%i_%02i_%02i__%02i_%02i_%02i', timeNow(1), timeNow(2), timeNow(3), timeNow(4), timeNow(5), round(timeNow(6))) ;
dataBaseFolderDump = sprintf('%s/%s', '/media/elaX/intanData/ela/individualExperimentDataBase', dataBaseTimeStamp) ;
mkdir(dataBaseFolderDump) ;

%% create experiment line jumper for data base file table
experimentJumper = 1 ;
%% Loop through excelTable and analyze experimentsl
for iExperiment = 1:size(excelTable,1)
    currentLine = excelTable(iExperiment, :) ;
    if strcmp(currentLine.Analyze_Y_N_, 'Y')
        [experimentInfo, s1DetectedSeizurePath] = readElasTable(currentLine) ;
        experimentInfo.EEGreference = 'Motor' ;
    % write info to function tracker file
        % fprintf(fidTracker, 'Mouse ID: %s\n', experimentInfo.mouse.ID) ;
        % funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
        % fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;
        % Write info to function tracker file
        fprintf(fidTracker, 'Mouse ID: %s\n', experimentInfo.mouse.ID);
        funCallStack = dbstack;
        %%%% modified by Ela because there were erros 
        % Check if funCallStack is empty
        if ~isempty(funCallStack)
            methodName = funCallStack(1).name;
        else
            methodName = 'Base workspace';
        end
        
        theTime = makeNowTimeString();
        fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName);
     % jump into function
        numSeizureDetectionMats = 1  ;

        dataBaseFileName = analyzeElasExperiment(experimentInfo, fidTracker, numSeizureDetectionMats, ...
            dataBaseFolderDump, dataBaseTimeStamp) ; 

        dataBaseFileTable.MouseID{experimentJumper} = experimentInfo.mouse.ID ;
        dataBaseFileTable.FileName{experimentJumper} = dataBaseFileName ;

        experimentJumper = experimentJumper + 1;
        fprintf(fidTracker, 'Success\n\n') ;
        

        %% analyze if experiment has an additional S1 EEG recording
        if ~isempty(s1DetectedSeizurePath)
            experimentInfo.dataPaths.pathToSeizures = [] ;
            experimentInfo.dataPaths.pathToSeizures = s1DetectedSeizurePath ;
            experimentInfo.EEGreference = [] ;
            experimentInfo.EEGreference = 'S1' ;
            fprintf(fidTracker, 'Mouse ID: %s\n', experimentInfo.mouse.ID) ;
            funCallStack = dbstack ; methodName = funCallStack(1).name; theTime = makeNowTimeString() ;
            % Check if funCallStack is empty
            if ~isempty(funCallStack)
                methodName = funCallStack(1).name;
            else
                methodName = 'Base workspace';
            end
            
            
            
            fprintf(fidTracker, '\t%s -- %s\n', theTime, methodName) ;
         % jump into function
            numSeizureDetectionMats = 2 ;

            dataBaseFileName = analyzeElasExperiment(experimentInfo, fidTracker, numSeizureDetectionMats, ...
                dataBaseFolderDump, dataBaseTimeStamp) ;       

            fprintf(fidTracker, 'Success\n\n') ;
        end

%         emailMarkUpdate(fileName) ;

    end
end

%% close file
fclose(fidTracker) ;








