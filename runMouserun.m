function mouseMovement = runMouserun(rawMoveData, binSize, smoothWin, rawSampRate)
% parent function: loadIntanDataAndDownsample.m

%% select channel to compute movement with
moveChan1 = rawMoveData(:,1)  ;
moveChan2 = rawMoveData(:,2) ;

%% feed into Scott's motion function
[smoothChan1Time, smoothChan1] = calcSpeed_mark(moveChan1, binSize, smoothWin) ;
[smoothChan2Time, smoothChan2] = calcSpeed_mark(moveChan2, binSize, smoothWin) ;

%% create movement variable
mouseMovement.smooth.chan01(:, 1) = smoothChan1Time ;
mouseMovement.smooth.chan01(:, 2) = smoothChan1 ;
mouseMovement.smooth.chan02(:, 1) = smoothChan2Time ;
mouseMovement.smooth.chan02(:, 2) = smoothChan2 ;


%% plot
%     plot(mouseTime, moveChan1, 'color', rgb('deeppink'));
%     hold on
%     plot(mouseTime, moveChan2, 'color', rgb('deepskyblue'));
%     plot(smoothChan1Time, smoothChan1,'r');
%     plot(smoothChan2Time, smoothChan2,'b');
% 
%     
%     title('Speed');
%     ylabel('cm/sec');
%     xlabel('Time (sec)')
%     axis([480, 600, 0, inf])
%     label('Time (sec)')

%% set figure position
% set(gcf, 'units', 'normalized', 'position', [0.05, 0.05, 0.6, 0.8])