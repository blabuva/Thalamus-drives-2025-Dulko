function  [SWDstartTime, SWDendTime, SWDduration] = extractSWDtimesForDataBase(type1SWDs, iSWD) 

        SWDstartTime = type1SWDs.SWD_troughTimes{iSWD}(1) ;
        SWDendTime = type1SWDs.SWD_troughTimes{iSWD}(end) ;
        SWDduration = SWDendTime - SWDstartTime  ;
