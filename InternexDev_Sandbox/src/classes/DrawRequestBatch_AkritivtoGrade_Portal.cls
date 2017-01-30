global class DrawRequestBatch_AkritivtoGrade_Portal implements Database.Batchable<sObject>,Database.Allowscallouts{
global Database.QueryLocator Start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id,CaseNumber, Client_Account__c, ClosedDate,CreatedDate, CurrencyIsoCode, Funding_Balance__c, Funding_Requested__c,';
            query = query+'Funding_Transaction_Count__c,Funds_Released__c, Grade_Id__c,MP_External_Id__c,Portal_External_Id__c, Product__c, Status,Sync_with_Grade__c,';
            query = query+'Sync_with_Market_Place__c, Sync_with_Portal__c FROM Case where (Sync_with_Market_Place__c = False or Sync_with_Portal__c = False) limit 49999';
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Case> Scope)
    {
        for(Case Cas : Scope)
        {
            if(cas.Sync_with_Market_Place__c == False && Cas.Status.toUpperCase()== 'UNALLOCATED')																														//Sync_with_Portal__c,au
            	TPSSF.TPConnectorService.SubmitExt('Case',cas.Id, '' ,'' ,'sendtompbe','akritiv-internex-case' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');
            if(cas.Sync_with_Portal__c == False &&(Cas.Status.toUpperCase()== 'REJECTED' || Cas.Status.toUpperCase()== 'FUNDS TRANSFERRED'))
             	TPSSF.TPConnectorService.SubmitExt('Case',cas.Id, '' ,'' ,'sendtoportal','akritiv-internex-case' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');   
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
        
    }
}