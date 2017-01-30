global class Funding_AllocationBatch implements Database.Batchable<Sobject>,Database.Allowscallouts{
	global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate,Funding_Request__c, Deal_Acceptance_Date__c, Discount_Interest_Rate__c,';
        	   Query = Query + 'Fund__c, Funding_Provider__c, Funding_Transaction_Date__c, External_Id__c, Bank_Details__c, Portal_External_Id__c, MP_External_Id__c,';
        	   query = Query + 'Sync_with_Market_Place__c, Sync_with_Grade__c, Sync_with_Portal__c, Origination_Fee__c, Origination_Fee_Applicable__c,';
			   query = Query + 'Origination_Fee_Percentage__c, Minimum_origination_fee__c, Drawal_Fee__c, Drawal_Fee_Percentage__c, Minimum_Drawal_fee__c';
       		   query = Query + ' FROM Funding_Transaction__c order by Createddate Desc limit 5';
               system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Funding_Transaction__c> Scope)
    {
		for(Funding_Transaction__c FT : Scope)
        {
            TPSSF.TPConnectorService.SubmitExt('Funding_Transaction__c',FT.Id,'','','sendtoportal','','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');
        }
    }
    global void Finish(Database.BatchableContext BC)
    {
    }
}