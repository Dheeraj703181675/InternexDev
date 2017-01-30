Global class InvoiceBatch implements Database.Batchable<Sobject>,Database.Allowscallouts{
  global Database.QueryLocator start(Database.BatchableContext BC)
    {
	/*	String query = 'SELECT Id, Name, CurrencyIsoCode,CreatedDate,akritiv__Account__c, akritiv__Amount__c, akritiv__Balance__c,akritiv__Batch_Number__c, ';
        	   Query = Query + 'akritiv__Due_Date__c,akritiv__Status__c,Invoice_Status_Internex__c,Transaction_Date__c, Portal_External_Id__c, MP_External_Id__c,';
        	   query = Query + 'Sync_with_Market_Place__c, Sync_with_Grade__c, Sync_with_Portal__c, Credit_Period__c, Remaining_Amt_from_Portal__c,';
			   query = Query + 'Business_Transaction_Date__c, Applied_Amt_from__c, Tran_DT_Gt_90D_Plus_Inv_Date__c, Tran_DT_Gt_CPD_Plus_Inv_Date__c, Document_Type__c,';
               query = Query + 'Debtor__c,Balance_Remaining__c,Balance__c,Original_Invoice_Amount__c,Payment_Date__c, Write_off_Amount__c,Payment_Line_Count__c, ';
               query = Query + 'Invoice_Due_Date__c, Sum_of_Payments__c, Ineligibles_Amount__c, Balance_Internex__c, External_Id__c FROM akritiv__Transaction__c where (Sync_with_Portal__c = False) limit 49999';
               system.debug('Query ==> '+ query); */
        return NULL; //Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<akritiv__Transaction__c> Scope)
    {
     /*   for(akritiv__Transaction__c Inv : Scope)
        {
            if(Inv.Sync_with_Portal__c == False && (Inv.Invoice_Status_Internex__c.toUpperCase() == 'APPROVED' || Inv.Invoice_Status_Internex__c.toUpperCase() == 'REJECTED'))
            {
                TPSSF.TPConnectorService.SubmitExt('akritiv__Transaction__c',Inv.Id,'','','sendtoportal','akritiv-internex-invoice','',UserInfo.getUserId(),UserInfo.getSessionId(),'PartnerUrl', UserInfo.getUserName(),'','','');
            }
        }*/
    }
    global void Finish(Database.BatchableContext BC)
    {
     /*   Payments_Batch PB = new Payments_Batch();
        Database.executeBatch(PB, 1);*/
    }
}