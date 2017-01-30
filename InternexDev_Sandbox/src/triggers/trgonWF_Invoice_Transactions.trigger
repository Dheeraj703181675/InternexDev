trigger trgonWF_Invoice_Transactions on WF_Invoice_Transactions__c (before insert,before update,after insert,after update) {
    if(Trigger.isBefore)
    {
        system.debug('<-------WF Invoice Transaction After Trigger---->');
        if(Trigger.isInsert)
        {
            Set<string> matchingstring_set = new Set<String>();
            for(WF_Invoice_Transactions__c WFT : Trigger.New)
            {
                matchingstring_set.add(WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + WFT.Transaction_Number__c);
            }
            list<WF_Envelope__c> Envelopedata_List = [Select id,DepositDate_LockboxNo_Batch_Transaction__c 
                                                      from WF_Envelope__c where DepositDate_LockboxNo_Batch_Transaction__c in: matchingstring_set];
            Map<string,WF_Envelope__c> MapofEnvelopeData = new Map<string,WF_Envelope__c>();
            for(WF_Envelope__c ED : Envelopedata_List) 
            {
                MapofEnvelopeData.put(ED.DepositDate_LockboxNo_Batch_Transaction__c ,ED);
            }
            for(WF_Invoice_Transactions__c WFT : Trigger.New)
            {
                string matchingstring = WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + WFT.Transaction_Number__c;
                if(MapofEnvelopeData != NULL && MapofEnvelopeData.containsKey(matchingstring))
                {
                    WFT.WF_Envelope__c = MapofEnvelopeData.get(matchingstring).id;
                }
            }
        }
    }
    if(Trigger.isAfter)
    {
        system.debug('<-------WF Invoice Transaction After Trigger---->');
        try{
            if(Trigger.isInsert ||Trigger.isUpdate)
            {
                Set<string> Uniquestring_Set = new Set<String>();
                set<String> ImageMatchingString_Set = new Set<String>();
                for(WF_Invoice_Transactions__c WFT : Trigger.New)
                {
                    Uniquestring_Set.add(WFT.Matching_string_for_Image_mapping__c);
                    if(WFT.Front_image_file__c != NULL)
                        ImageMatchingString_Set.add(WFT.Front_image_file__c.toUpperCase().trim());
                    if(WFT.Rear_Image_File__c != NULL)
                        ImageMatchingString_Set.add(WFT.Rear_Image_File__c.toUpperCase().trim());
                }
                Map<string,list<WF_PR__c>> mapof_PR = new Map<string,list<WF_PR__c>>();
                list<WF_PR__c> PR_List = [Select id, Matching_string_for_Image_mapping__c,Payment__c from WF_PR__c where Matching_string_for_Image_mapping__c in : Uniquestring_Set];
                
                for(string str : Uniquestring_Set)
                {
                    list<WF_PR__c> tempPRList = new list<WF_PR__c>();
                    for(WF_PR__c PR : PR_List)
                    {
                        if(str == PR.Matching_string_for_Image_mapping__c)
                        {
                            tempPRList.add(PR);
                        }
                    } 
                    mapof_PR.put(str,tempPRList);
                }
                Map<string,Lockbox_Image__c> mapof_LockboxImage = new Map<string,Lockbox_Image__c>();
                set<string> LockboxImageset = new Set<string>();
                list<Lockbox_Image__c> LockboxImage_List = [Select id,Image_Name__c,Image_extension__c,Payment__c,WF_PR__c,Zip_File_Name__c,Image_Name_formula__c from Lockbox_Image__c where Image_Name_formula__c in : ImageMatchingString_Set and (Payment__c =: NULL or WF_PR__c =: NULL)];
                for(Lockbox_Image__c LI : LockboxImage_List)
                {
                    mapof_LockboxImage.put(LI.Image_Name_formula__c,LI);
                    LockboxImageset.add(LI.id);
                }
                Map<string,LBI_and_PR__c> mapof_LBIPR = new Map<string,LBI_and_PR__c>();
                list<LBI_and_PR__c> LBIPRlist = [Select id,Lockbox_Image__c,WF_PR__c,Payment__c from LBI_and_PR__c where Lockbox_Image__c in : LockboxImageset];
                for(LBI_and_PR__c LI : LBIPRlist)
                {
                    mapof_LBIPR.put(string.valueof(LI.Lockbox_Image__c)+string.valueof(LI.WF_PR__c),LI);
                }
                
                if(mapof_LockboxImage != NULL && mapof_PR != NULL)
                {
                    list<LBI_and_PR__c> LBIPR_List = new List<LBI_and_PR__c>();
                    for(WF_Invoice_Transactions__c WFT : Trigger.New)
                    {
                        if(mapof_PR.containsKey(WFT.Matching_string_for_Image_mapping__c))
                        {
                            for(WF_PR__c PR : mapof_PR.get(WFT.Matching_string_for_Image_mapping__c))
                            {
                                if(WFT.Front_image_file__c != NULL && mapof_LockboxImage.containsKey(WFT.Front_image_file__c.toUpperCase().trim()))
                                {
                                    if(mapof_LBIPR != NULL && mapof_LBIPR.containsKey(string.valueof(mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).id) + string.valueof(PR.id)))
                                    {
                                        if(mapof_LBIPR.get(string.valueof(mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).id) + string.valueof(PR.id)).Payment__c == NULL)
                                        {
                                            if(PR.Payment__c != NULL)
                                                mapof_LBIPR.get(string.valueof(mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).id) + string.valueof(PR.id)).Payment__c = PR.Payment__c;
                                        }
                                    }
                                    else
                                    {
                                        LBI_and_PR__c LBIPR = new LBI_and_PR__c();
                                        LBIPR.Lockbox_Image__c = mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).id;
                                        LBIPR.WF_PR__c = PR.id;
                                        //   mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).WF_PR__c = PR.id;
                                        if(PR.Payment__c != NULL)
                                            LBIPR.Payment__c = PR.Payment__c;
                                        LBIPR_List.add(LBIPR);
                                    }
                                }
                                if(WFT.Rear_Image_File__c != NULL && mapof_LockboxImage.containsKey(WFT.Rear_Image_File__c.toUpperCase().trim()))
                                {
                                    if(mapof_LBIPR != NULL && mapof_LBIPR.containsKey(string.valueof(mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).id) + string.valueof(PR.id)))
                                    {
                                        if(PR.Payment__c != NULL)
                                            mapof_LBIPR.get(string.valueof(mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).id) + string.valueof(PR.id)).Payment__c = PR.Payment__c;
                                    }
                                    else
                                    {
                                        LBI_and_PR__c LBIPR = new LBI_and_PR__c();
                                        LBIPR.Lockbox_Image__c = mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).id;
                                        LBIPR.WF_PR__c = PR.id;
                                        //   mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).WF_PR__c = PR.id;
                                        if(PR.Payment__c != NULL)
                                            LBIPR.Payment__c = PR.Payment__c;
                                        
                                        LBIPR_List.add(LBIPR);
                                    }
                                }
                            }
                        }
                    }
                    update mapof_LBIPR.values();
                    system.debug('LBIPR_List--> '+LBIPR_List);
                    if(LBIPR_List.size() > 0)
                    {
                        insert LBIPR_List;
                    }
                }
                
            }
            
        }catch(exception e){System.debug('Expcetion --> '+ e);}
    }
}