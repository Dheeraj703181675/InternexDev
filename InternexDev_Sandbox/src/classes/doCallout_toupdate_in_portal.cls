public class doCallout_toupdate_in_portal {
	   @future (callout=true)
    public static void doCallout_toupdatetheClient_in_portal(set<id> clientidlist)
    {
        List<akritiv__Brand__c> Clientlist = [SELECT Id,External_Foreign_Key__c, Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c,
                                              Sync_with_Portal__c, Counter_Party_ID__c, Business_Transaction_Date__c, Ineligibles_Amount__c, CounterParty__c, Active__c,
                                              Funding_Limit__c, City__c, Company_Code__c, Country__c, Remit_ABA__c, Remit_Account__c, Remit_Address__c, Remit_Bank__c,
                                              Remit_Email__c, Remit_Name__c, Remit_PO_Box__c, Remit_Zip__c, State__c, ZIP_Code__c, Invoice_Amount__c, FIU_Outstanding__c,
                                              Net_Availability__c, Active_Facilitites__c, Application_Number__c, Application_Name__c, Referal_Source__c, Account__c,
                                              External_Id__c FROM akritiv__Brand__c where id in : clientidlist and Portal_External_Id__c =: NUll limit 49999];
        for(akritiv__Brand__c Client: clientlist)
        {
        //    system.debug('C123 '+ Client.Id);
            TPSSF.TPConnectorService.SubmitExt('akritiv__Brand__c',Client.Id, '' ,'' ,'sendtoportal','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(), '','','');  
        }
    }
}