global class ClientAccountBatch_AkritivtoGradePortal implements Database.Batchable<sObject>,Database.Allowscallouts {
    
global Database.QueryLocator Start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate,Client__c, Product__c, External_Id__c, External_Req_Id__c,';
            query = query+'Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c, Sync_with_Portal__c,Send_to_Grade__c,Send_to_Portal__c,';
            query = query+'Source__c  FROM Client_Account__c limit 49999';//where (Send_to_Grade__c > 0 or Send_to_Portal__c > 0)
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Client_Account__c> Scope)
    {
        for(Client_Account__c ClientAccount : Scope)
        {
            if(ClientAccount.Send_to_Grade__c > 0 && ClientAccount.External_Id__c != NULL)																														//Sync_with_Portal__c,au
            	TPSSF.TPConnectorService.SubmitExt('Client_Account__c',ClientAccount.Id, '' ,'' ,'sendtograde','akritiv-internex-client_account__c' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');
            if(ClientAccount.Send_to_Portal__c > 0 && ClientAccount.Portal_External_Id__c != NULL)
             	TPSSF.TPConnectorService.SubmitExt('Client_Account__c',ClientAccount.Id, '' ,'' ,'sendtoportal','akritiv-internex-client_account__c' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');   
            if(ClientAccount.External_Id__c != NULL)
            TPSSF.TPConnectorService.SubmitExt('Client_Account__c',ClientAccount.Id, '' ,'' ,'sendtompbe','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
 	/*	Payments_Batch PB = new Payments_Batch();
        Database.executeBatch(PB, 1); */
    }
}