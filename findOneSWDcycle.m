function oneCycleSWD = findOneSWDcycle(EEG) 
% parent function: parseThePhase.m

seizureTime = EEG.EEG.Time{1} ;
theSeizure =EEG.EEG.EEG{1} ;
firstTwoTroughTimes = EEG.EEG.TroughTimes{1}(2:3) ;
troughIDX(1) = find(seizureTime >= firstTwoTroughTimes(1), 1) ;
troughIDX(2) = find(seizureTime >= firstTwoTroughTimes(2), 1) ;
oneCycleSWD = theSeizure(troughIDX(1):troughIDX(2)) ;
% xq1 = [0:1:359] ;
% xq2 = xq1 ;
% vq1 = interp1([1:15], oneCycleSWD, xq) ;
% vq1 = vq1+100 ;
% polarplot(deg2rad(xq2), vq1)