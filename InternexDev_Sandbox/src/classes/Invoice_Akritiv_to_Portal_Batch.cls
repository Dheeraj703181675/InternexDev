global class Invoice_Akritiv_to_Portal_Batch implements Database.Batchable<sObject>,Database.Allowscallouts {
global Database.QueryLocator Start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate,Client__c, Product__c, External_Id__c, External_Req_Id__c,';
            query = query+'Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c, Sync_with_Portal__c,';
            query = query+'Source__c  FROM Client_Account__c where Debtor_Count_for_Invoices__c > 0 and Portal_External_Id__c != Null limit 49999';//(Portal_External_Id__c = Null or Sync_with_Portal__c = False)
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Client_Account__c> Scope)
    {
        for(Client_Account__c ClientAccount : Scope)
        {
          //  if(ClientAccount.Sync_with_Portal__c == False || ClientAccount.Portal_External_Id__c == Null)
                TPSSF.TPConnectorService.SubmitExt('Client_Account__c',ClientAccount.Id, '' ,'' ,'sendtoportalAllInvoices','akritiv-inernex-user-invoices' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');   
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
    }
}