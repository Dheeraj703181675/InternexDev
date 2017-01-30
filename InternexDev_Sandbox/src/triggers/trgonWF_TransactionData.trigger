trigger trgonWF_TransactionData on WF_Transaction_Data__c (before Insert,before Update,after insert,after update) {
    if(Trigger.isBefore)
    {
        system.debug('<-------WF Transaction Before Trigger---->');
        try{
            if(Trigger.isInsert || Trigger.isUpdate)
            {
                Set<string> matchingstring_set = new Set<String>();
                Set<String> PRmatching_Set = new Set<string>();
                for(WF_Transaction_Data__c WFT : Trigger.New)
                {
                    matchingstring_set.add(WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + WFT.Transaction_Number__c);
                    PRmatching_Set.add(WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + String.valueof(Integer.valueof(WFT.Transaction_Number__c)));
                } 
                list<WF_Envelope__c> Envelopedata_List = [Select id,DepositDate_LockboxNo_Batch_Transaction__c 
                                                          from WF_Envelope__c where DepositDate_LockboxNo_Batch_Transaction__c in: matchingstring_set];
                Map<string,WF_Envelope__c> MapofEnvelopeData = new Map<string,WF_Envelope__c>();
                for(WF_Envelope__c ED : Envelopedata_List) 
                {
                    MapofEnvelopeData.put(ED.DepositDate_LockboxNo_Batch_Transaction__c ,ED);
                }
                Map<string,WF_PR__c> mapof_PR = new Map<string,WF_PR__c>();
                list<WF_PR__c> PR_List = [Select id, Matching_string_for_Image_mapping__c,Payment__c,Item_sequence_number__c from WF_PR__c where Matching_string_for_Image_mapping__c in : PRmatching_Set];
                for(WF_PR__c PR : PR_List)
                {
                    mapof_PR.put(PR.Matching_string_for_Image_mapping__c+PR.Item_sequence_number__c,PR);
                } 
                for(WF_Transaction_Data__c WFT : Trigger.New)
                {
                    string matchingstring = WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + WFT.Transaction_Number__c;
                    String PR_matchingstring = WFT.Deposit_date__c + WFT.Lockbox_no__c + WFT.Batch__c + String.valueof(Integer.valueof(WFT.Transaction_Number__c)) + WFT.Sequence_Number__c;
                    if(MapofEnvelopeData != NULL && MapofEnvelopeData.containsKey(matchingstring))
                    {
                        WFT.WF_Envelope__c = MapofEnvelopeData.get(matchingstring).id;
                    }
                    if(mapof_PR != NULL && mapof_PR.containsKey(PR_matchingstring))
                    {
                        WFT.WF_PR__c = mapof_PR.get(PR_matchingstring).id;
                    }
                }
            }
        }
        catch(exception e){System.debug('Expcetion --> '+ e);}
    } 
    if(Trigger.isAfter)
    {
        system.debug('<-------WF Transaction After Trigger---->');
        try{
            if(Trigger.isInsert ||Trigger.isUpdate)
            {
                Set<string> Uniquestring_Set = new Set<String>();
                set<String> ImageMatchingString_Set = new Set<String>();
                for(WF_Transaction_Data__c WFT : Trigger.New)
                {
                    Uniquestring_Set.add(WFT.Matching_string_for_Image_mapping__c);
                    if(WFT.Front_image_file__c != NULL)
                        ImageMatchingString_Set.add(WFT.Front_image_file__c.toUpperCase().trim());
                    if(WFT.Rear_Image_File__c != NULL)
                        ImageMatchingString_Set.add(WFT.Rear_Image_File__c.toUpperCase().trim());
                }
                Map<string,WF_PR__c> mapof_PR = new Map<string,WF_PR__c>();
                list<WF_PR__c> PR_List = [Select id, Matching_string_for_Image_mapping__c,Payment__c ,Item_sequence_number__c from WF_PR__c where Matching_string_for_Image_mapping__c in : Uniquestring_Set];
                for(WF_PR__c PR : PR_List)
                {
                    mapof_PR.put(PR.Matching_string_for_Image_mapping__c+PR.Item_sequence_number__c ,PR);
                } 
                Map<string,Lockbox_Image__c> mapof_LockboxImage = new Map<string,Lockbox_Image__c>();
                list<Lockbox_Image__c> LockboxImage_List = [Select id,Image_Name__c,Image_extension__c,Payment__c,WF_PR__c,Zip_File_Name__c,Image_Name_formula__c from Lockbox_Image__c where Image_Name_formula__c in : ImageMatchingString_Set and (Payment__c =: NULL or WF_PR__c =: NULL)];
                for(Lockbox_Image__c LI : LockboxImage_List)
                {
                    mapof_LockboxImage.put(LI.Image_Name_formula__c,LI);
                }
                if(mapof_LockboxImage != NULL && mapof_PR != NULL)
                {
                    for(WF_Transaction_Data__c WFT : Trigger.New)
                    {
                        if(mapof_PR.containsKey(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c))
                        {
                            if(WFT.Front_image_file__c != NULL && mapof_LockboxImage.containsKey(WFT.Front_image_file__c.toUpperCase().trim()))
                            {
                                mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).WF_PR__c = mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).id;
                                if(mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).Payment__c != NULL)
                                    mapof_LockboxImage.get(WFT.Front_image_file__c.toUpperCase().trim()).Payment__c = mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).Payment__c;
                            }
                            if(WFT.Rear_Image_File__c != NULL && mapof_LockboxImage.containsKey(WFT.Rear_Image_File__c.toUpperCase().trim()))
                            {
                                mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).WF_PR__c = mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).id;
                                if(mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).Payment__c != NULL)
                                    mapof_LockboxImage.get(WFT.Rear_Image_File__c.toUpperCase().trim()).Payment__c = mapof_PR.get(WFT.Matching_string_for_Image_mapping__c+WFT.Sequence_Number__c).Payment__c;
                            }
                        }
                    }
                    system.debug(mapof_LockboxImage);
                    update mapof_LockboxImage.values();
                }
                
            }
            
        }catch(exception e){System.debug('Expcetion --> '+ e);}
    }
}