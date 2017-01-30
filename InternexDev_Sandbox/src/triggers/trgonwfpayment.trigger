trigger trgonwfpayment on WF_PR__c (before insert,before update) {
    if(Trigger.isBefore)
    {
        system.debug('====Lockbox Payment Before Trigger====');
        if(Trigger.IsInsert || Trigger.IsUpdate)
        {
            Set<string> Set_Batch_headers = new Set<string>();
            for(WF_PR__c WF : Trigger.New)
            {
                Set_Batch_headers.add(WF.WF_BH__c);
            }
            Map<string,WF_BH__c> Map_batch_header = new Map<String,WF_BH__c>([Select id,name,PTH_Payment_source__c,PTH_RDFI_R_T__c,PTH_RDFI_account_number__c,PTH_Lockbox_number__c,LB_Number__c From WF_BH__c where id in: Set_Batch_headers]);
            system.debug('Map_batch_header==>  ' + Map_batch_header);
            if(Map_batch_header != NULL)
            {
            //    map<String,WF_BH__c> LockboxNumbermap = new map<String,WF_BH__c>();
                set<string> LockboxNumber_set = new Set<String>();
                for(WF_PR__c WF : Trigger.New)
                {
                    if(Map_batch_header.containsKey(WF.WF_BH__c) != NULL && Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c != NULL)
                    {
                        LockboxNumber_set.add(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c);
                //        LockboxNumbermap.put(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c);
                    }
                }
                Map<String,LockBox_Account__c> LockBox_Account_Map = new Map<String,LockBox_Account__c>();
                for(LockBox_Account__c CA : [Select id,Name,Lockbox_Number__c,Account_Number__c,Routing_Number__c from LockBox_Account__c where Account_Number__c in : LockboxNumber_set])
                {
                    LockBox_Account_Map.put(CA.Account_Number__c,CA);
                }
                system.debug('LockBox_Account_Map==>  ' + LockBox_Account_Map);
                for(WF_PR__c WF : Trigger.New)
                {
                    WF.Payment_Status__c = 'Suspense';
                    if(LockBox_Account_Map != NULL)
                    {
                        if(Map_batch_header.containsKey(WF.WF_BH__c) != NULL && Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c != NULL)
                        {
                            if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c) != NULL )
                            {
                             //   if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Account_Number__c == Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c)
                             //   {
                                    if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Routing_Number__c == Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_R_T__c)
                                    {
                                        WF.Payment_Status__c = 'Valid';
                                    }
                             //    }
                             }
                         }                
                     }
                }
            }
        }
    }
  /*  if(Trigger.isAfter)
    {
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        cp.Create_payment(Trigger.New);
    } */
}