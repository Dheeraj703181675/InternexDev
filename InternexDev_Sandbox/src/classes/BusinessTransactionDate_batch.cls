global class BusinessTransactionDate_batch implements Database.Batchable<sObject>,Database.Allowscallouts {
    global List<BusinessTransactionDate__c> Start(Database.BatchableContext BC)
    {
        List<BusinessTransactionDate__c> BsnsTransact_list = new List<BusinessTransactionDate__c>();
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        BsnsTransact_list.add(BsnsTransact);
       	 return BsnsTransact_list;
    }
    global Void Execute(Database.BatchableContext BC,List<BusinessTransactionDate__c> Scope)
    {
        for(BusinessTransactionDate__c BusinessTransactionDate : Scope)
        {
            if(BusinessTransactionDate != NULL)
            {
                system.debug('BTD ==> '+BusinessTransactionDate);
                string partnerURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
                 system.debug(TPSSF.TPConnectorService.SubmitExt('BusinessTransactionDate__c',BusinessTransactionDate.id, '' ,'' ,'sendtoportalbtd','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),partnerURL, UserInfo.getUserName(),'','',''));
            }
            
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
    }
}