public class SendBusinessTransactionDate_to_ESB {
/*	 public void SendBusinessTransactionDate_toESB()
    {
         BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
         TPSSF__ConnectorSettings__c connectorsettings = TPSSF__ConnectorSettings__c.getValues('ClientId');
         if(BsnsTransact != NULL )//&& connectorsettings != NULL
         {
             string ClientID = connectorsettings.TPSSF__value__c;
			 system.debug('ClienID ==> '+ClientID);
             system.debug('BTD ==> '+BsnsTransact.Business_Transaction_Date__c);
             String BusinessTransactionDateid = BsnsTransact.ID;
             system.debug('BTD.id ==> '+BusinessTransactionDateid);
             string partnerURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
             system.debug(TPSSF.TPConnectorService.SubmitExt('BusinessTransactionDate__c',BusinessTransactionDateid, '' ,'' ,'sendtoportalbtd','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),partnerURL, UserInfo.getUserName(),'','','')); 
         }
    }*/
}