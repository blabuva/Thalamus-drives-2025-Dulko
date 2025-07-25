function  unitsCurrentSWD = collectUnitsForDataBase(mappedKSUnits, seizureFreeLeadTime, seizureFreePostTime, unitType, currentStruc)

        unitsCurrentStruc_IDX = find(contains(mappedKSUnits.(unitType).Channel_Brain, currentStruc) ==1) ;
        currentUnits = mappedKSUnits.(unitType).SpikeTimesSec(unitsCurrentStruc_IDX) ;
        unitsCurrentSWD = mappedKSUnits.(unitType)(unitsCurrentStruc_IDX, :) ;
        for iSingle = 1:length(currentUnits)
            allSpikeTimes = unitsCurrentSWD.SpikeTimesSec{iSingle} ;
            allIDX = unitsCurrentSWD.IDXofUncuratedSpikeVector{iSingle} ;
            singlesSWD_IDX = find(allSpikeTimes>= seizureFreeLeadTime & allSpikeTimes < seizureFreePostTime) ;
            unitsCurrentSWD.SpikeTimesSec{iSingle} = [] ;
            unitsCurrentSWD.IDXofUncuratedSpikeVector{iSingle} = [] ;
            unitsCurrentSWD.SpikeTimesSec{iSingle} = allSpikeTimes(singlesSWD_IDX) ;
            unitsCurrentSWD.IDXofUncuratedSpikeVector{iSingle} = allIDX(singlesSWD_IDX) ;
        end