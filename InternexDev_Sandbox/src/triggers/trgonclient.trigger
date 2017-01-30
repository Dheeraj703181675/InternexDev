/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   : Avoid Duplicate Entries.
 * Usage   : Stamping the LookupIds by external Id's while Integration from ESB and Updating the flags to know the integration status
 * Usage   : Stamp the Business Transaction Date from customsettings.
*/
trigger trgonclient on akritiv__Brand__c (Before Insert,Before Update) {

    if(Trigger.isBefore)
    {   // ========== Updating the Transaction date from Custom settings=================// 
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();

        if(Trigger.isInsert || Trigger.isUpdate)
        {
            Set<String> CountrerpartyKeys = new Set<String>();
            map<String,Account> AccountMap = new map<String,Account>();
            for(akritiv__Brand__c  Client : Trigger.New)
            {
                if(BsnsTransact != Null && Trigger.isInsert)
                {
                    Client.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
                if(Trigger.isInsert || client.Encryption_Key__c == NULL)
                	client.Encryption_Key__c = EncryptionandDecryption.getKey();
                if(Client.QB_ConsumerSecret__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(Client.Id).QB_ConsumerSecret__c != Trigger.newMap.get(Client.Id).QB_ConsumerSecret__c)))
                {
                  //  system.debug('==> '+Client.QB_ConsumerSecret__c+'==> '+  client.Encryption_Key__c);
                   Client.QB_ConsumerSecret__c = EncryptionandDecryption.Encrypt(Client.QB_ConsumerSecret__c, client.Encryption_Key__c);
                }
                if(Client.QB_ConsumerKey__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(Client.Id).QB_ConsumerKey__c != Trigger.newMap.get(Client.Id).QB_ConsumerKey__c)))
	               Client.QB_ConsumerKey__c = EncryptionandDecryption.Encrypt(Client.QB_ConsumerKey__c, client.Encryption_Key__c);
                if(Client.QB_OauthToken__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(Client.Id).QB_OauthToken__c != Trigger.newMap.get(Client.Id).QB_OauthToken__c)))
              	   Client.QB_OauthToken__c = EncryptionandDecryption.Encrypt(Client.QB_OauthToken__c, client.Encryption_Key__c);
                if(Client.QB_AccessTokenSecret__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(Client.Id).QB_AccessTokenSecret__c != Trigger.newMap.get(Client.Id).QB_AccessTokenSecret__c)))
                   Client.QB_AccessTokenSecret__c = EncryptionandDecryption.Encrypt(Client.QB_AccessTokenSecret__c , client.Encryption_Key__c);
            }
            if(Trigger.isInsert)
            {
                for(akritiv__Brand__c  Client : Trigger.New)
                {
                    if(Client.External_Foreign_Key__c != NULL)
                       CountrerpartyKeys.add(Client.External_Foreign_Key__c);
                }
                for(Account ACC : [Select id,akritiv__Account_Key__c from Account where akritiv__Account_Key__c in : CountrerpartyKeys])
                {
                    AccountMap.put(ACC.akritiv__Account_Key__c,ACC);
                }
                for(akritiv__Brand__c  Client : Trigger.New)
                {
                    if(AccountMap != NULL && AccountMap.get(Client.External_Foreign_Key__c) != NULL)
                        Client.CounterParty__c = AccountMap.get(Client.External_Foreign_Key__c).ID;
                }
            }
        }
        //=========== Added for avoid duplicate Entries===================//
         Map<String, Id> Clientmap = new Map<String, Id>();

        Set<String> Client_set = new Set<String>();
       for(akritiv__Brand__c Client: Trigger.New)
            Client_set.add(Client.Name);

        for(akritiv__Brand__c CLient:[SELECT Id, Name FROM akritiv__Brand__c WHERE Name IN : Client_set])
            Clientmap.put(CLient.name, CLient.Id);
		
        for(akritiv__Brand__c CLient: Trigger.New)
        {
            If(Trigger.IsInsert)
            {
                if(Clientmap.containsKey(CLient.name))
                    CLient.addError(
                        'Client already exists. ' /*+ 
                        'Refer: <a href=\'/' + 
                        Clientmap.get(CLient.Name) + '\'>' + 
                        CLient.Name + '</a>',
                        false*/
                    );
            }                
            else if(Trigger.IsUpdate)
            {
             if(Clientmap.containsKey(CLient.name) && Clientmap.get(CLient.name) != CLient.Id)
                 CLient.addError(
                     'Client already exists.    ' /*+ 
                     'Refer: <a href=\'/' + 
                     Clientmap.get(CLient.Name) + '\'>' + 
                     CLient.Name+ '</a>',
                     false*/
                 );
             
            }  
        }
        //==================End of avoid duplicates logic================//
        //================== Updating the flags to know the integration status ==========//
        if(Trigger.IsUpdate)
        {
     //       profile p = [select id from profile where name = 'Integration Admin'];
      //      system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
      //      if(p.Id != userinfo.getProfileId())
      //      {
                for(akritiv__Brand__c client : Trigger.New)
                {
                    if(client.Profile_Name__c != 'Integration Admin')
                    {
                        client.Sync_with_Grade__c = False;
                        client.Sync_with_Market_Place__c = False;
                        client.Sync_with_Portal__c = False;
                    }
                }
        //    }
        }
        //==================End of Updating the flags to know the integration status ==========//
    }

}