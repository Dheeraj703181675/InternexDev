/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   : Rollup summery logic.
 * Usage   : updating the flags to know the integration status
 * Usage   : Stamp the Business Transaction Date from customsettings.
*/ 
Trigger FundingRequestTrigger on Case (Before insert,Before Update,After Insert,After Update,After Delete) {
    //=========Rollup summery logic===================//
    if(Trigger.isAfter)
    {
        set<Id> ClientProductId = new Set<Id>();
        if(Trigger.isUpdate || Trigger.isInsert)
        {
            for(Case FundingRequest: Trigger.new)
            {
                ClientProductId.add(FundingRequest.Client_Account__c);
            }
        }
        if(Trigger.isDelete)
        {
            for(Case FundingRequest: Trigger.old)
            {
                ClientProductId.add(FundingRequest.Client_Account__c);
            }
        }
        Map<String,Double> ClientProductmap_Totalpayment = new Map<string,Double>();
        Map<String,Double> ClientProductmap_FRCount = new Map<string,Double>();
        for(AggregateResult PM : [select count(ID) FRC,Client_Account__c CP,sum(Funding_Amount__c) Fundreleased from Case where Client_Account__c IN : ClientProductId group by Client_Account__c])
        {
            ClientProductmap_Totalpayment.put((Id)PM.get('CP'),(Double)PM.get('Fundreleased'));
            ClientProductmap_FRCount.put((Id)PM.get('CP'),(Double)PM.get('FRC'));
        }
        List<Client_Account__c> ClientProduct_list_toUpdate = new List<Client_Account__c>();
        for(Client_Account__c CP : [Select Id, Sum_of_Received_funds__c,Funding_Request_Count__c from Client_Account__c
                                            where Id IN : ClientProductId])
        {
            CP.Sum_of_Received_funds__c = ClientProductmap_Totalpayment.get(CP.Id);
            CP.Funding_Request_Count__c = ClientProductmap_FRCount.get(CP.Id);
            ClientProduct_list_toUpdate.add(CP);
        }
        system.debug('CPD_list_toUpdate==> '+ClientProduct_list_toUpdate);
        try{
              Update ClientProduct_list_toUpdate;
        }catch(Exception e){system.debug('Exception ==> '+ e);}
        
        if(Trigger.isUpdate)
        {
            //=====Updating the related Tasks when Funding Status is Funds Transfered================ 
            Map<Id, Case> CaseMap= new Map<Id, Case>([select id,Status from Case where id in:Trigger.newMap.keyset()]);
            
            Map<Id, Task> taskMap= new Map<Id, Task>([select Whatid,status from task where Whatid in : Trigger.newMap.keyset()]);
            
            if(taskMap.size() > 0)
            {
                for(Task currentTask : taskMap.values())
                {
                    if(CaseMap.get(currentTask.Whatid).Status=='Approved'||CaseMap.get(currentTask.Whatid).Status=='Rejected')
                    {
                        currentTask.status = 'Completed';
                    }
                }
                update taskMap.values();
            }
            
            Set<string> Set_FundingRequestID = new Set<String>();
            for(Case Cs : Trigger.new)
            {
                if(Trigger.oldMap.get(Cs.Id).Origination_Fee__c != Cs.Origination_Fee__c || Trigger.oldMap.get(Cs.Id).Draw_Fee__c != Cs.Draw_Fee__c || Trigger.oldMap.get(Cs.Id).Wire_Mode__c != Cs.Wire_Mode__c || Trigger.oldMap.get(Cs.Id).Wire_Fee__c != Cs.Wire_Fee__c || Trigger.oldMap.get(Cs.Id).ACH_Mode__c != Cs.ACH_Mode__c)
                {
                    Set_FundingRequestID.add(Cs.id);
                }
            }
            if(Set_FundingRequestID.size() > 0)
            {
                Update[Select id,Funding_Request__c from Funding_Transaction__c where Funding_Request__c in:Set_FundingRequestID ];
            }
        }

    }
    // ============= updating the flags and Stamping the Transaction Data from custom settings========//
    if(Trigger.IsBefore)
    {
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        set<string> ClientaccountId_set = new set<String>();
        if(Trigger.isInsert  || Trigger.isUpdate)
        {
            for(Case cas : Trigger.New)
            {
                if(BsnsTransact != Null && Trigger.isInsert)
                {
                    cas.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
                if(Trigger.isInsert)
                {
                    ClientaccountId_set.add(cas.Client_Account__c);
                }
            }
            if(Trigger.isInsert)
            {
                map<string,Client_Account__c> Client_Account_map =new map<string,Client_Account__c>([Select id,Borrowing_Base__c,Gross_Availability__c,Funding_Limit__c,Borrowing_Base_Reserve__c,Funding_Request_Count__c,FIU_Outstanding__c,Partner_Draw_Fee__c,Partner_Origination_Fee__c,
                                                                                                        Origination_Fee_Percentage__c,Minimum_Origination_Fee__c,Drawal_Fee_Percentage__c,Minimum_Drawal_Fee__c,Net_Availability__c
                                                                                                        from Client_Account__c where id in : ClientaccountId_set]);
                if(Client_Account_map != NULL)
                {
                    for(Case cas : Trigger.New)
                    {//system.debug('==> '+ Client_Account_map.get(cas.Client_Account__c));
                        if(Client_Account_map.get(cas.Client_Account__c) != NULL)
                        {
                            if(cas.Remittance__c == False)
                            {
                                if(Client_Account_map.get(cas.Client_Account__c).Net_Availability__c == 0.00 || Client_Account_map.get(cas.Client_Account__c).Net_Availability__c < cas.Funding_Requested__c)
                                    cas.addError('You can not create Funding Request for the Client-Account which has the 0 or less Net Availability.'); 
                            }
                        /*    else
                            {
                                if(math.abs(Client_Account_map.get(cas.Client_Account__c).Net_Availability__c) < cas.Funding_Requested__c)
                                    cas.addError('Funding Requested Amount must be lessthan or equal to Net Availability.');  
                            } */
                            
                        }
                        if(Client_Account_map.get(cas.Client_Account__c) != NULL && Client_Account_map.get(cas.Client_Account__c).Funding_Request_Count__c != NULL)
                            cas.Request_Number__c = Client_Account_map.get(cas.Client_Account__c).Funding_Request_Count__c;
                        if(Client_Account_map.get(cas.Client_Account__c) != NULL && (Client_Account_map.get(cas.Client_Account__c).Funding_Request_Count__c == 0 || Client_Account_map.get(cas.Client_Account__c).Funding_Request_Count__c == NULL))
                        {
                            cas.Origination_Fee__c = True;
                        }
                        else if(cas.Portal_External_Id__c != NULL)
                        {
                            Cas.Draw_Fee__c = True;
                        } 
                        if(Client_Account_map.get(cas.Client_Account__c) != NULL)
                        {
                           if(Client_Account_map.get(cas.Client_Account__c).Origination_Fee_Percentage__c != NULL)
                           {
                               cas.CA_Origination_Fee_Percentage__c = Client_Account_map.get(cas.Client_Account__c).Origination_Fee_Percentage__c;
                           }
                           if(Client_Account_map.get(cas.Client_Account__c).Minimum_Origination_Fee__c != NULL)
                           {
                               Cas.CA_Minimum_Origination_Fee__c = Client_Account_map.get(cas.Client_Account__c).Minimum_Origination_Fee__c;
                           }
                           if(Client_Account_map.get(cas.Client_Account__c).Drawal_Fee_Percentage__c != NULL)
                           {
                               Cas.CA_Drawal_Fee_Percentage__c = Client_Account_map.get(cas.Client_Account__c).Drawal_Fee_Percentage__c;
                           }
                           if(Client_Account_map.get(cas.Client_Account__c).Minimum_Drawal_Fee__c != NULL)
                           {
                               Cas.CA_Minimum_Drawal_fee__c = Client_Account_map.get(cas.Client_Account__c).Minimum_Drawal_Fee__c;
                           }
                           if(Client_Account_map.get(cas.Client_Account__c).Funding_Limit__c != NULL)
                           {
                               Cas.CA_Funding_Limit__c = Client_Account_map.get(cas.Client_Account__c).Funding_Limit__c;
                           } 
                           if(Client_Account_map.get(cas.Client_Account__c).Partner_Draw_Fee__c != NULL)
                           {
                               Cas.Partner_Draw_Fee__c = Client_Account_map.get(cas.Client_Account__c).Partner_Draw_Fee__c;
                           } 
                           if(Client_Account_map.get(cas.Client_Account__c).Partner_Origination_Fee__c != NULL)
                           {
                               Cas.Partner_Origination_Fee__c = Client_Account_map.get(cas.Client_Account__c).Partner_Origination_Fee__c;
                           }  
                        }
                     }
                }
                
            }
        }
        if(Trigger.IsUpdate)
        {
            //     profile p = [select id from profile where name = 'Integration Admin'];
            //     system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
            //     if(p.Id != userinfo.getProfileId())
            //     {
            for(Case cas : Trigger.New)
            {
                if(cas.Profile_Name__c != 'Integration Admin')
                {
                    cas.Sync_with_Grade__c = False;
                    cas.Sync_with_Market_Place__c = False;
                    cas.Sync_with_Portal__c = False;
                }
            }
            //     }
        }
    }
}