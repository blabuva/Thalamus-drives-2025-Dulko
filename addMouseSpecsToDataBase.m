function dataBase = addMouseSpecsToDataBase(dataBase, experimentInfo, jumper) 

        dataBase.ExperimentNumber(jumper) = experimentInfo.recording.masterFileLineNumber ;
        dataBase.Strain{jumper} = experimentInfo.mouse.strain ;
        dataBase.MouseID{jumper} = experimentInfo.mouse.ID ;
        dataBase.Sex{jumper} = experimentInfo.mouse.sex ;
        dataBase.Age(jumper) = experimentInfo.mouse.age ;
        dataBase.ImplantDate{jumper} = string(experimentInfo.mouse.implantDate); 
        dataBase.RecordingDate{jumper} = string(experimentInfo.recording.recordingDate) ;