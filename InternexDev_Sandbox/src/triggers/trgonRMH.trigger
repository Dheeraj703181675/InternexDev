trigger trgonRMH on WF_RMH__c (after insert,before insert,before update) {
    if(Trigger.isBefore)
    {
        set<string> PRID_Set = new Set<string>();
        Map<string,WF_PR__c> PR_Map = new Map<string,WF_PR__c>();
        for(WF_RMH__c RMH : Trigger.New)
        {
            if(RMH.WF_PR__c != NULL && RMH.Envelope_Number__c == NULL)
            {
                PRID_Set.add(RMH.WF_PR__c);
            }
        }
        if(PRID_Set.size() > 0)
        {
            for(WF_PR__c PR : [Select id,Name,Reference_1_PR22B__c from WF_PR__c where id in: PRID_Set])
            {
                PR_Map.put(PR.ID,PR);
            }
        }
        if(PRID_Set.size() > 0)
        {
            if(PR_Map != NULL)
            {
                for(WF_RMH__c RMH : Trigger.New)
                {
                    if(PR_Map.containsKey(RMH.WF_PR__c))
                    {
                        RMH.Envelope_Number__c = PR_Map.get(RMH.WF_PR__c).Reference_1_PR22B__c;
                    }
                }
            }
        }
    }
    if(Trigger.isAfter)
    {
        set<string> Envelope_Set = new Set<string>();
      //  set<string> PRID_Set = new Set<string>();
        List<WF_PR__c> PR_List = new List<WF_PR__c>();
        if(Trigger.isInsert)
        {
            for(WF_RMH__c RMH : Trigger.New)
            {
                if(RMH.WF_PR__c != NULL)
                {
            //        PRID_Set.add(RMH.WF_PR__c);
                    Envelope_Set.add(RMH.PR_Envelope_No__c);
                }
            }
            if(Envelope_Set.size() > 0)
            {
                PR_List = [Select id,Name,Reference_1_PR22B__c from WF_PR__c where Reference_1_PR22B__c in: Envelope_Set]; // and id in: PRID_Set
                if(PR_List.size() > 0)
                {
                    list<PR_and_RMH__c> PRRMH_Junciton = new list<PR_and_RMH__c>();
                    for(WF_RMH__c RMH : Trigger.New)
                    {
                        for(WF_PR__c PR : PR_List)
                        {
                            if( RMH.Envelope_Number__c == PR.Reference_1_PR22B__c)
                            {
                                PR_and_RMH__c JO = new PR_and_RMH__c();
                                JO.WF_PR__c = PR.id;
                                JO.WF_RMH__c = RMH.id;
                                PRRMH_Junciton.add(JO);
                            }
                        }
                    }
                    try
                    {
                        insert PRRMH_Junciton;
                    }catch(Exception e){system.debug('--> exception e --> '+ e);}
                }
            }
        }
    }
}