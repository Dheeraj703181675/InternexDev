global class DBAName_Batch implements Database.Batchable<Sobject>,Database.Allowscallouts{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, Name, DBA_Count_for_Grade__c, CreatedDate,DBA_Count_for_Portal__c,External_Id__c,Portal_External_Id__c,';
               query = query+'Client_Account__c FROM Debtor__c where ((External_Id__c != NULL and DBA_Count_for_Grade__c > 0) or (Portal_External_Id__c != NULL and DBA_Count_for_Portal__c > 0)) limit 49999';
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Debtor__c> Scope)
    {
        for(Debtor__c Deb : Scope)
        {
            if(Deb.External_Id__c != NULL && Deb.DBA_Count_for_Grade__c > 0)
                TPSSF.TPConnectorService.SubmitExt('Debtor__c',Deb.Id,'','','sendtogradedba','akritiv-inernex-dba-name','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(),'','','');
            if(Deb.Portal_External_Id__c != NULL && Deb.DBA_Count_for_Portal__c > 0)
                TPSSF.TPConnectorService.SubmitExt('Debtor__c',Deb.Id,'','','sendtoportaldba','akritiv-inernex-dba-name','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(),'','','');
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
        
    }
}