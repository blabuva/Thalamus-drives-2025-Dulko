function [unitsToPlot, Fs] = gatherUnitsToPLot(oneSWD, channels0024)
% parent function: singleUnitsMovie.m

% save('/home/mark/matlab_temp_variables/unitGathering')
% ccc
% load('/home/mark/matlab_temp_variables/unitGathering')

%% create notch (60Hz) filter
Fs = 1/(channels0024.timeC(2) - channels0024.timeC(1)) ;
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);

hiPass = 200 ;

%% get structure field names
brainParts = fieldnames(oneSWD) ;

%% get dentate units
unitsToPlot.(brainParts{1}){1}.units =   oneSWD.(brainParts{1}).SWD_SingleUnits(1,:) ;
unitsToPlot.(brainParts{1}){1}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{1}){1}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{1}){2}.units =   oneSWD.(brainParts{1}).SWD_SingleUnits(10,:) ;
unitsToPlot.(brainParts{1}){2}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{1}){2}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{1}){3}.units =   oneSWD.(brainParts{1}).SWD_SingleUnits(12,:) ;
unitsToPlot.(brainParts{1}){3}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{1}){3}.units.ChannelNumber,:), hiPass, Fs) ;

%% get CA1 units
unitsToPlot.(brainParts{2}){1}.units =   oneSWD.(brainParts{2}).SWD_SingleUnits(1,:) ;
unitsToPlot.(brainParts{2}){1}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{2}){1}.units.ChannelNumber,:), hiPass, Fs) ;

%% get CA3 units
unitsToPlot.(brainParts{4}){1}.units =   oneSWD.(brainParts{4}).SWD_SingleUnits(1,:) ;
unitsToPlot.(brainParts{4}){1}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{4}){1}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{4}){2}.units =   oneSWD.(brainParts{4}).SWD_SingleUnits(11,:) ;
unitsToPlot.(brainParts{4}){2}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{4}){2}.units.ChannelNumber,:), hiPass, Fs) ;

%% get LD thalamus units
unitsToPlot.(brainParts{5}){1}.units =   oneSWD.(brainParts{5}).SWD_SingleUnits(1,:) ;
unitsToPlot.(brainParts{5}){1}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{5}){1}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{5}){2}.units =   oneSWD.(brainParts{5}).SWD_SingleUnits(7,:) ;
unitsToPlot.(brainParts{5}){2}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{5}){2}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{5}){3}.units =   oneSWD.(brainParts{5}).SWD_SingleUnits(13,:) ;
unitsToPlot.(brainParts{5}){3}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{5}){3}.units.ChannelNumber,:), hiPass, Fs) ;

unitsToPlot.(brainParts{5}){4}.units =   oneSWD.(brainParts{5}).SWD_SingleUnits(26,:) ;
unitsToPlot.(brainParts{5}){4}.channel = highpass(channels0024.allChannels(unitsToPlot.(brainParts{5}){4}.units.ChannelNumber,:), hiPass, Fs) ;




