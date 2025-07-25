function  [eeg,time,seizureStart,seizureEnd]= extractEEGandTimeForRow(StructureDatabase,iRow)

seizureStart = StructureDatabase.SeizureStartTime(iRow); 
seizureEnd = seizureStart+StructureDatabase.SeizureDuration(iRow); 

eeg = StructureDatabase.SWD_Props{iRow,1}.SWD_EEG{1,1}; 
time = StructureDatabase.SWD_Props{iRow,1}.SWD_timeCol{1,1}; 


end % function end 
