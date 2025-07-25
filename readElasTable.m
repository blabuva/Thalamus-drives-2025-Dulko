function [experimentInfo, s1DetectedSeizurePath] = readElasTable(currentLine) 
% Parent Function: analyzeElasMasterProbeFile

%% load info from excel sheet
experimentInfo.mouse.ID = cell2textForExcel(currentLine.MouseID) ;
experimentInfo.mouse.strain = cell2textForExcel(currentLine.MouseStrain) ;
experimentInfo.mouse.age = currentLine.MouseAge_days_ ;
experimentInfo.mouse.sex = cell2textForExcel(currentLine.MouseSex) ;
experimentInfo.mouse.implantDate = currentLine.ImplantDate ;
experimentInfo.recording.recordingDate = currentLine.RecordingDate ;
experimentInfo.recording.startTime = cell2textForExcel(currentLine.RecordingStartTime_firstFile_) ;
experimentInfo.recording.number = currentLine.Recording_ ;
experimentInfo.recording.masterFileLineNumber = currentLine.Experiment ;
experimentInfo.dataPaths.file = cell2textForExcel(currentLine.MouseID) ;
experimentInfo.dataPaths.path = cell2textForExcel(currentLine.PathToDataFolder) ;
experimentInfo.dataPaths.unitClassificationPath = sprintf('%s/%s/analyzedData/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, ...
    cell2textForExcel(currentLine.UnitClassificationMatFile)) ;

% experimentInfo.dataPaths.pathToSeizures = cell2textForExcel(currentLine.DetectedSeizuresMatFile) ;
% detectedSeizurePath = sprintf('%s/%s/detectedSeizures/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, cell2textForExcel(currentLine.DetectedSeizuresMatFile)) ;
seizureDetectedMats = cell2textForExcel(currentLine.DetectedSeizuresMatFile) ;

gotS1 = ~isempty(strfind(seizureDetectedMats, 'S1')) ;
if gotS1 == 0
    detectedSeizurePath = sprintf('%s/%s/detectedSeizures/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, seizureDetectedMats) ;
    s1DetectedSeizurePath = [] ;
else
    comma = strfind(seizureDetectedMats, ',') ;
    motorPath = seizureDetectedMats(1:comma-1) ;
    detectedSeizurePath = sprintf('%s/%s/detectedSeizures/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, motorPath) ;
    s1pathTemp = seizureDetectedMats(comma+1:end) ;
    s1path = strrep(s1pathTemp, ' ', '') ;
    s1DetectedSeizurePath = sprintf('%s/%s/detectedSeizures/%s', experimentInfo.dataPaths.path, experimentInfo.dataPaths.file, s1path) ;
end
    
experimentInfo.dataPaths.pathToSeizures = detectedSeizurePath ;

experimentInfo.spikeDetectionParams.threshold = currentLine.SpikeThreshold_xRMS_ ;
experimentInfo.spikeDetectionParams.hiPassFilt = currentLine.HighPassFilterForSpikeDetection_Hz_ ; 
experimentInfo.spikeDetectionParams.runManThreshold = cell2textForExcel(currentLine.IncludeBasicThresholdedSpikes) ;
experimentInfo.spikeDetectionParams.seizurePad = currentLine.SeizureTimePad_s_ ;
experimentInfo.analysisParams.PSTHbinSize = currentLine.PSTHBinSize_ms_ ;

experimentInfo.plotData = cell2textForExcel(currentLine.MakePlots_Y_N_) ;

