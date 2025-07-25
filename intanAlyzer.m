function intanAlyzer (exptParams)

save('/home/mark/matlab_temp_variables/INT')
ccc
load('/home/mark/matlab_temp_variables/INT')




%% path to Intan data
animalLabel = sprintf('%s__%s', exptParams.MouseID{1}, exptParams.Date{1})
intanDataPath = sprintf('%s%s/rawData/%s/%s/', exptParams.DataFolderPath{1}, exptParams.Experimenter{1}, exptParams.MouseID{1}, exptParams.Date{1}) ;

%% get intan files (i.e. rhd files)
intanFiles = dir(sprintf('%s*.rhd', intanDataPath)) ;

for iFile = 1:size(intanFiles)

    intanFileName= sprintf('%s%s', intanDataPath, intanFiles(iFile).name);
    
    sampleRes = num2str(exptParams.DownSampleTo) ;
    
    %% path to output 
    mountainSortPath = sprintf('%s%s/analyzedData/%s/%s/', exptParams.DataFolderPath{1}, exptParams.Experimenter{1}, exptParams.MouseID{1}, exptParams.Date{1}) ;
    mkdir(mountainSortPath);
    mkdir(sprintf('%schannelFiles/probe/sampleRate_%s/', mountainSortPath, sampleRes)) ;
    % MountainSortPath = '/media/markX2/data/outputFiles/revolution2/' ;
    
    %% create output file name based on animal label and file name
    dataFileName = sprintf('%s__%s', animalLabel, intanFiles(iFile).name(1:end-4)) ;
    
    %% read Intan data
    info = readIntanInfoFile( intanFileName );
    
    %% generate time data: Read Time Data ('time.dat')('int32')
    FileNameWithPath    = sprintf('%s%s_time.mat', mountainSortPath, dataFileName);
%     if exist( FileNameWithPath, 'file' )
%         fprintf( 'Time      file already exists. This step is skipped!\n' );
%         load( FileNameWithPath, 'time' );
%     else
        time            = readIntanDataFile( intanFileName, info, 'time', 0);
        time            = single(time);
    
        save( FileNameWithPath, 'time' );
%     end
    clear FileNameWithPath;
    
     %% save parameters into info
    info.nSamples       = length(time);
    info.path           = intanDataPath;
    info.nChannels      = length(info.amplifier_channels);
    info.dataPathName   = mountainSortPath;
    info.dataFileName   = dataFileName;
    clear t dataPathName
%     clear t dataPathName dataFileName
    
    %% Save Info file
    FileNameWithPath    = sprintf('%s%s_info.mat', mountainSortPath, dataFileName);
    if ~exist( FileNameWithPath, 'file' )
        save( FileNameWithPath, 'info' );
    end
    
    
    %% Get Amplifier channel names and sorterd with channel map
    FileNameWithPath    = sprintf('%s%s_raw.mda', mountainSortPath, dataFileName);
%     if exist( FileNameWithPath, 'file' )
%         fprintf( 'Raw Data  file already exists. This step is skipped!\n' );    
%     else    
        % Read Inta Amplifier Data to int16 Binary format file ( all channel in one file )            
        data    = readIntanDataFile( intanFileName, info, 'amplifier', 0);
        data    = int16(data);
        f       = waitbar(0.5, 'Writing Amplifier Data ...');        
        writeMda(data, FileNameWithPath, 'int16' );
    %     clear data 
        
        waitbar(1, f, 'Writing Amplifier Data ...');
        pause(0.1);
        close(f)   
%     end

%% write channels to pClampable text file
numPClampFiles = size(data,1)/16 ;
dataDouble = downsample([double(data)]', round((exptParams.OriginalSamplingRate/exptParams.DownSampleTo)));
if rem(numPClampFiles,1)==0
    channs = [1:16] ;
   parfor iPClampFile = 0:numPClampFiles-1
        channsWrite = channs + (iPClampFile*16) ;

%         dlmwrite('/media/markX/Chans_test', dataDouble(1:600001,1:16)) ;
        dlmwrite(sprintf('%schannelFiles/probe/sampleRate_%s/%s__Chans_%03ito%03i_sample%s', mountainSortPath, sampleRes, dataFileName, channsWrite(1), channsWrite(end), sampleRes), dataDouble(:, channsWrite)) ;
    end
else
    numPClampFiles = floor(size(data,1)/16) ;
    channs = [1:16] ;
    parfor iPClampFile = 0:numPClampFiles-1
        channsWrite = channs + (iPClampFile*16) ;
        dlmwrite(sprintf('%schannelFiles/probe/sampleRate_%s/%s__Chans_%03ito%03i_sample%s', mountainSortPath, sampleRes, dataFileName, channsWrite(1), channsWrite(end), sampleRes), dataDouble(:, channsWrite)) ;
    end
    clear channsWrite 
    channsWrite = [(numPClampFiles*16)+1:size(dataDouble,2)] ;
    dlmwrite(sprintf('%schannelFiles/probe/sampleRate_%s/%s__Chans_%03ito%03i_sample%s', mountainSortPath, sampleRes, dataFileName, channsWrite(1), channsWrite(end), sampleRes), dataDouble(:, channsWrite)) ;
end



    %% Get EEG channels (analog inputs on Intan...here called 'board_adc')
    eegChannels = readIntanDataFile(intanFileName, info, 'board_adc', 0);
    resizeEEG = eegChannels' ;
    reducedEEG(:,1) = decimate(resizeEEG(:,1), 50) ;
    reducedEEG(:,2) = decimate(resizeEEG(:,2), 50) ;
    dlmwrite(sprintf('%schannelFiles/%s_EEG', mountainSortPath, dataFileName), reducedEEG)
    
    %% Get EEG channels (analog inputs on Intan...here called 'board_dig_in')
    skip = 1
    if skip == 0
        moveChannels = readIntanDataFile(intanFileName, info, 'board_dig_in', 0);
        resizeMove = moveChannels' ;
        dlmwrite(sprintf('%schannelFiles/%s_Motion', mountainSortPath, dataFileName), resizeMove)
        
        %% combine units and EEG, then save as mat file
        allChannels = [data; eegChannels] ;
        save(sprintf('%schannelFiles/%s_unitsANDeeg', mountainSortPath, dataFileName), "allChannels")
    end
    
    %%
%     dataChannels = readRawDataMda(FileNameWithPath, length(time)) ;



    % command = 'pwd';
    
    % clear command1 command2
    
    % command1 = 'conda activate myenv1'
    % [status,cmdout] = unix(command1)
    
    %% what is this?
%     unixCommand = sprintf('bash /media/markX/Intan/sort_64H_mpb.sh "%s" "%s"', mountainSortPath, dataFileName) ;
%     [status,cmdout] = unix(unixCommand)
    
    
toc
    %%

    % 
    % %%
    % Animal.Name = animalLabel ;
    % Animal.DataPath = IntanDataPath ;
    % Animal.ProcessedPath = MountainSortPath ;
    % 
    % AnalysisSpikeSorting(Animal)
    % 
    % for i = 1:64
    %     plot(data(i,:))
    %     hold on
    % end
    keep exptParams animalLabel intanDataPath intanFiles
    


end