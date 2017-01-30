Global class Payments_ToP5_Batch implements Database.Batchable<Sobject>,Database.Allowscallouts {
 global Database.QueryLocator start(Database.BatchableContext BC)
    {
	/*	String query = 'SELECT Id,CreatedDate,akritiv__Account__c,akritiv__Amount__c, akritiv__Bank_Name__c,akritiv__Customer_Name__c,akritiv__Payment_Address__c,';
        	   Query = Query + 'akritiv__Payment_Date__c, akritiv__Payment_Type__c, akritiv__Phone__c,akritiv__Status__c, akritiv__Unapplied_Balance__c,';
        	   query = Query + 'akritiv__Applied_Amount__c, MP_External_Id__c, Portal_External_Id__c, Sync_with_Market_Place__c, Sync_with_Grade__c,';
			   query = Query + 'Sync_with_Portal__c, Bank_Account__c, Client_Account__c, Payment_internex__c, Debtor_Name__c, Transaction_Date__c,Portal_Transaction_Id__c,';
       		   query = Query + 'Business_Transaction_Date__c, Unapplied_Amount_internex__c, Payment_Status__c,Account_Name__c, Account_Type__c, Batch_Number__c,';
               query = Query + 'Document_Date__c, Document_Number__c, Document_Type__c,IsActive__c,Transaction_Type__c, UnApplied_Balance_calc__c,Write_Off_Type__c,';
               query = Query + 'Count__c, Debtor__c, External_Id__c FROM akritiv__Payment__c';//order by Createddate Desc limit 5 where Portal_Transaction_Id__c = NULL
               system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);*/
        string query = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate,Client__c, Product__c, External_Id__c, External_Req_Id__c,';
            query = query+'Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c, Sync_with_Portal__c,';
            query = query+'Source__c  FROM Client_Account__c where Debtor_Count_for_Payments_to_Trans_Grid__c > 0 and Portal_External_Id__c != Null limit 49999';//where (Portal_External_Id__c = Null or Sync_with_Portal__c = False)
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Client_Account__c> Scope)
    {
        for(Client_Account__c CA : Scope)
        {
           // TPSSF.TPConnectorService.SubmitExt('akritiv__Payment__c',Payment.Id,'','','sendtoportal','akritiv-internex-payment','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(),'','','');
            TPSSF.TPConnectorService.SubmitExt('Client_Account__c',CA.id,'','','sendtoportalallpayments','akritiv-inernex-user-transaction','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(),'','','');
        }
         
    }
    global void Finish(Database.BatchableContext BC)
    {
      /*  Funding_AllocationBatch FAB = new Funding_AllocationBatch();
        Database.executeBatch(FAB, 1);*/
    }

}