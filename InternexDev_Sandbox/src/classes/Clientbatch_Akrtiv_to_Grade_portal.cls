global class Clientbatch_Akrtiv_to_Grade_portal implements Database.Batchable<sObject>,Database.Allowscallouts{
    global Database.QueryLocator Start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id,External_Foreign_Key__c, Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c,';
            query = query+'Sync_with_Portal__c, Counter_Party_ID__c, Business_Transaction_Date__c, Ineligibles_Amount__c, CounterParty__c, Active__c,';
            query = query+'Funding_Limit__c, City__c, Company_Code__c, Country__c, Remit_ABA__c, Remit_Account__c, Remit_Address__c, Remit_Bank__c,'; 
            query = query+'Remit_Email__c, Remit_Name__c, Remit_PO_Box__c, Remit_Zip__c, State__c, ZIP_Code__c, Invoice_Amount__c, FIU_Outstanding__c,';
            query = query+'Net_Availability__c, Active_Facilitites__c, Application_Number__c, Application_Name__c, Referal_Source__c, Account__c,';
            query = query+'External_Id__c FROM akritiv__Brand__c where Portal_External_Id__c != NULL limit 49999';
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<akritiv__Brand__c> Scope)
    {
        for(akritiv__Brand__c Client : Scope)
        {
           /* if(Client.Sync_with_Grade__c == False)																														//Sync_with_Portal__c,au
            	TPSSF.TPConnectorService.SubmitExt('akritiv__Brand__c',Client.Id, '' ,'' ,'save','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','',''); */
          //  if(Client.Sync_with_Portal__c == False)
             	TPSSF.TPConnectorService.SubmitExt('akritiv__Brand__c',Client.Id, '' ,'' ,'sendtoportal__ca','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
        
    }
}