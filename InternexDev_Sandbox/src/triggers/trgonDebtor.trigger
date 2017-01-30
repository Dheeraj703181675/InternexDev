/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   : Stamping the LookupIds by external Id's while loading the data from ESB and updating the flags to know the integration status
 * Usage   : Stamp the Business Transaction Date from customsettings.
*/ 
trigger trgonDebtor on Debtor__c (Before Insert,before update,after Insert,after Update,after delete) {
if(Trigger.isBefore)
    {  
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        // =========Stamping the LookupIds by external Id's while loading the data from ESB //
        // =========Stamp the Business Transaction Date from customsettings===========//
        if(Trigger.isInsert )//|| Trigger.isUpdate
        {
            Set<String> ClientAccountKeys = new Set<String>();
            Set<String> CounterPartyKeys = new Set<String>();
            map<String,Client_Account__c> ClientAccountmap = new map<String,Client_Account__c>();
            map<String,Account> Accountmap = new map<String,Account>();
            
            for(Debtor__c Debtor: Trigger.New)
            {
                if(Debtor.ClientAccount_External_Foreign_Key__c != NULL)
                    ClientAccountKeys.add(Debtor.ClientAccount_External_Foreign_Key__c);
                if(Debtor.CounterParty_External_Foreign_Key__c != NULL)
                    CounterPartyKeys.add(Debtor.CounterParty_External_Foreign_Key__c);
                if(BsnsTransact != Null)
                {
                    Debtor.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
            }
            for(Client_Account__c ClientAccount : [Select id,External_Id__c from Client_Account__c where External_Id__c in : ClientAccountKeys])
            {
                ClientAccountmap.put(ClientAccount.External_Id__c,ClientAccount);
            }
            for(Account ACC : [Select id,akritiv__Account_Key__c from Account where akritiv__Account_Key__c in : CounterPartyKeys])
            {
                Accountmap.put(ACC.akritiv__Account_Key__c ,ACC);
            }
            for(Debtor__c Debtor : Trigger.New)
            {
                if(ClientAccountmap != NULL && ClientAccountmap.get(Debtor.ClientAccount_External_Foreign_Key__c) != NULL)
                    Debtor.Client_Account__c = ClientAccountmap.get(Debtor.ClientAccount_External_Foreign_Key__c).ID;
                if(Accountmap != NULL && Accountmap.get(Debtor.CounterParty_External_Foreign_Key__c) != NULL)
                    Debtor.Counterparty__c = Accountmap.get(Debtor.CounterParty_External_Foreign_Key__c).ID;
            }
            
        }
        // ================= updating the flags ===============//
    /*    if(Trigger.IsUpdate)
        {
        //    profile p = [select id from profile where name = 'Integration Admin'];
        //    system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
        //    if(p.Id != userinfo.getProfileId())
        //    {
                for(Debtor__c Debtor : Trigger.New)
                {
               //     if(Debtor.Profile_Name__c != 'Integration Admin')
               //     {
                        Debtor.Sync_with_Grade__c = False;
                        Debtor.Sync_with_Market_Place__c = False;
                        Debtor.Sync_with_Portal__c = False; 
               //     }
                }
         //   }
        } */

    }
    if (Trigger.isAfter)
    {
        //=============== Adding the logic by Dheeraj to update the rollup summery operation on Client product object ===========//
        set<ID> ClientProductset = new Set<ID>();
        
        //When adding/updating debtor
        if(Trigger.isUpdate || Trigger.isInsert)
        {
            Map<Id, Debtor__c> DebtorMap= new Map<Id, Debtor__c>();
            for(Debtor__c debtor : Trigger.new)
            {
                ClientProductset.add(debtor.Client_Account__c);
                DebtorMap.put(debtor.id, debtor);
            }
            
            //=====Updating the related Tasks when Debtor Status is Pending================ 
           // Map<Id, Debtor__c> DebtorMap= new Map<Id, Debtor__c>([select id,Debtor_Status__c from Debtor__c where id in:Trigger.newMap.keyset()]);
            
            Map<Id, Task> taskMap= new Map<Id, Task>([select Whatid,status from task where Whatid in : Trigger.newMap.keyset()]);
            
            if(taskMap.size() > 0)
            {
                for(Task currentTask : taskMap.values())
                {
                    if(DebtorMap.get(currentTask.Whatid).Debtor_Status__c=='Pending' )
                    {
                        currentTask.status = 'Completed';
                    }
                }
                update taskMap.values();
            }
		    //============================
            //===1 Logic to Update the Invoice Count for sending portal if the debtor is synched with portal after the Invoice Loading===// 
            if(Trigger.isupdate)
            {
                Map<string,Debtor__C> Debtor_map = new Map<string,Debtor__C>();
                for(Debtor__C Deb : Trigger.New)
                {
                    if((Deb.Debtor_Status__c == 'Eligible' && Trigger.oldMap.get(Deb.Id).Debtor_Status__c == 'Ineligible') || (Deb.Debtor_Status__c == 'Ineligible' && Trigger.oldMap.get(Deb.Id).Debtor_Status__c == 'Eligible') || (Trigger.oldMap.get(Deb.Id).Portal_External_Id__c == NULL && Deb.Portal_External_Id__c != NULL && (Trigger.oldMap.get(Deb.Id).Portal_External_Id__c != Deb.Portal_External_Id__c)))
                    {
                        Debtor_map.put(Deb.Id,Deb);
                    }
                }system.debug('Debtor map ==> '+ Debtor_map);
                if(Debtor_map != NULL)
                {
                    /*   List<AggregateResult> InvoiceCount = [Select Count(ID) ICT, Debtor__C Deb from akritiv__Transaction__c where Debtor__c IN : Debtor_map.keySet() and Send_to_Portal__c =: True group by Debtor__c];
                    for(AggregateResult INV : InvoiceCount)
                    {
                    if(Debtor_map.containsKey((Id)INV.get('Deb')))
                    {
                    Debtor_map.get((Id)INV.get('Deb')).Invoice_Count_for_Sending_Portal__c = (Double)INV.get('ICT');
                    }
                    } */
                    Update [Select id from akritiv__Transaction__c where debtor__c IN : Debtor_map.keySet()];
                }
            }
            //======end 1=========//
        }
        // when deleting the debtor
        if(Trigger.isDelete)
        {
            for(Debtor__c debtor : Trigger.old)
            {
                ClientProductset.add(debtor.Client_Account__c);
            }
        }
        
        Map<String,Double> DebtorGrossAvailability = new Map<string,Double>();
        Map<String,Double> DebtorIneligiblesamount = new Map<string,Double>();
        Map<String,Double> DebtorEligiblefunding = new Map<string,Double>();
        Map<String,Double> DebtorInvoicesCount = new Map<string,Double>();
        
        //Produce a sum of Gross availability and add them to the map
        for(AggregateResult deb: [select count(Id) DC,Client_Account__c CA,sum(Net_Availability__c) GrossAvailabiltyamt,Sum(Ineligibles_Amount_formula__c) Ineligiblesamnt,
                                  sum(Eligible_For_Funding__c) eligibleFunding,sum(Invoice_Count__c) InvCount from Debtor__c where Client_Account__c IN : ClientProductset group by Client_Account__c])
        {
            DebtorGrossAvailability.put((Id)deb.get('CA'),(Double)deb.get('GrossAvailabiltyamt'));
            DebtorIneligiblesamount.put((Id)deb.get('CA'),(Double)deb.get('Ineligiblesamnt'));
            DebtorEligiblefunding.put((Id)deb.get('CA'),(Double)deb.get('eligibleFunding'));
            DebtorInvoicesCount.put((Id)deb.get('CA'),(Double)deb.get('InvCount'));
        }
        List<Client_Account__c> CA_list_toUpdate = new List<Client_Account__c>();
        //Get the sum value from the map and create a list of ClientProductDebtorset to update
        for(Client_Account__c CA : [Select Id, Gross_Availability__c,Eligible_For_Funding__c,Ineligibles_Amount__c,Invoice_Count__c from Client_Account__c where Id IN :ClientProductset])
        {
            CA.Gross_Availability__c = DebtorGrossAvailability.get(CA.Id);
            CA.Ineligibles_Amount__c = DebtorIneligiblesamount.get(CA.Id);
            CA.Eligible_For_Funding__c =  DebtorEligiblefunding.get(CA.Id);
            CA.Invoice_Count__c =  DebtorInvoicesCount.get(CA.Id);
            CA_list_toUpdate.add(CA);
        }
        system.debug('CA_list_toUpdate==> '+CA_list_toUpdate);
        try{
            Update CA_list_toUpdate;
        }
        Catch(Exception e){System.debug('==>Exception '+e);}     
        
        //========= End of logic which is added by Dheeraj ===========================================================//
    }

}