trigger UpdateMaxCreditLimitOnParentAccount on Account (Before insert,before Update,after insert,after update) {
 
    if(Trigger.isAfter)
    {
     /*   if(Trigger.isUpdate)
        {
            akritiv__Trigger_Configuration__c triggerConf = akritiv__Trigger_Configuration__c.getOrgDefaults();                                    
            boolean isChecked = false; 
            
            if(triggerConf != null){      
                isChecked = triggerConf.ManageUpdateMaxCreditLimitOnParentAccoun__c;   
            }
            
            if (isChecked){
                Map<id,Account> mapOfParentAccounts = new Map<id,Account>();
                set<id> parentIds = new set<id>();
                List<Account> lstOfChildAccounts = new List<Account>();
                List<Account> lstOfParentAccount = new List<Account>();
                for(Account acc:Trigger.new){
                    if(acc.parentId != NULL){
                        parentIds.add(acc.ParentId);
                        lstOfChildAccounts.add(acc);
                    }
                }
                System.debug('----lstOfChildAccounts SIZE-----'+lstOfChildAccounts.size());
                System.Debug('####PARENTID' + parentIds);
                if(parentIds != null && parentIds.size()>0){
                    mapOfParentAccounts = new Map<id,Account>([select id, akritiv__Credit_Limit__c, name from Account where Id in :parentIds]);// and akritiv__Credit_Limit__c <> 0]);
                    System.Debug('####PArent Account'+mapOfParentAccounts);
                    Account objParentAccount = new Account();
                    if(mapOfParentAccounts != null && mapOfParentAccounts.size()>0){
                        for(Account acc:lstOfChildAccounts){
                            System.Debug('###CREDITLIMITID---' +  acc.akritiv__Credit_Limit__c);
                            if(acc.Akritiv__Account_Key__c != null){
                                objParentAccount = mapOfParentAccounts.get(acc.parentId);
                                if(acc.akritiv__Credit_Limit__c != null && objParentAccount.akritiv__credit_limit__c !=null && (acc.akritiv__credit_limit__c > objParentAccount.akritiv__credit_limit__c)){
                                    objParentAccount.akritiv__credit_limit__c = acc.akritiv__credit_limit__c;
                                    lstOfParentAccount.add(objParentAccount);
                                } */
                                //========Already commented============//
                                /*      if(objParentAccount.akritiv__credit_limit__c == null){
										objParentAccount.akritiv__credit_limit__c = acc.akritiv__credit_limit__c;
										parentAccount.add(objParentAccount);
										} */
                                //===========End=====================//
                   /*         }
                        }
                    }
                    system.debug('----------------------lstOfParentAccount SIZE :   '+lstOfParentAccount.size());
                    if(lstOfParentAccount.size() > 0){
                        Update lstOfParentAccount;            
                    }
                }
            }
        } */
        if(Trigger.isInsert)
        {	
            List<Debtor__c> Debtorlist = new List<Debtor__c>();
            for(Account Acc : Trigger.New)
            {
                if(Acc.Portal_Debtor_ID__c != NULL && Acc.Portal_Client_Account_ID__c != NULL)
                {
                    Debtor__c debt = new Debtor__c();
                    debt.Client_Account__c = Acc.Portal_Client_Account_ID__c;
                    debt.Counterparty__c = ACC.id;
                    debt.Dilution__c = 0;
                    debt.Funding_Limit__c = 0;
                    debt.Concentration_Limit__c = 0;
                    debt.Eligible_AR__c = 0;
                    debt.Borrowing_Base_Reserve__c = 0;
                    debt.Max_Credit_Period__c = 0;
                    debt.Debtor_Status__c = 'Pending-Portal';
                    debt.Portal_External_Id__c = Acc.Portal_Debtor_ID__c;
                    Debtorlist.add(debt);
                }
            }
            try
            {
                insert Debtorlist;
            }catch(Exception e){system.debug('==> exception 2 '+ e);}
        }
        if(Trigger.isUpdate)
        {
            Set<String> CounterpartyName = new Set<String>();
            Set<String> CounterpartyId = new Set<String>();
        	for(Account Acc : Trigger.New)
            {
                if(Acc.Name != NULL)
                {
                    CounterpartyName.add(Acc.Name);
                    CounterpartyId.add(Acc.Id);
                }
            }
            Map<String,akritiv__Brand__c> MapofClient = New Map<String,akritiv__Brand__c>();
            
            for(akritiv__Brand__c Client:[Select id,Name,CounterParty__c from akritiv__Brand__c where CounterParty__c in: CounterpartyId])
            {
                MapofClient.put(Client.CounterParty__c,Client);
            }
            
            if(MapofClient != NULL)
            {
                for(Account Acc : Trigger.New)
                {
                    if(MapofClient.containsKey(Acc.Id))
                    {
                        MapofClient.get(Acc.Id).Name = Acc.Name;
                    }
                }
                try{ update MapofClient.values();}catch(Exception e){system.debug('Exception e => '+e);}
            }
        }
    }
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
        //    profile p = [select id from profile where name = 'Integration Admin'];
        //    system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
        //    if(p.Id != userinfo.getProfileId())
       //     {
                for(Account Acc : Trigger.New)
                {
                    if(Acc.Profile_Name__c != 'Integration Admin')
                    {
                        Acc.Sync_with_Grade__c = False;
                        Acc.Sync_with_Market_Place__c = False;
                        Acc.Sync_with_Portal__c = False;
                    }
                }
         //   }
        }
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(Account Acc : Trigger.New)
            {
                if(BsnsTransact != Null)
                {
                    Acc.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
            }
        }
    }
}