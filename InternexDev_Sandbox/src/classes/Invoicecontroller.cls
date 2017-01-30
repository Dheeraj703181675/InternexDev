public with sharing class Invoicecontroller {

    public akritiv__Transaction__c Invoice{get;set;}
    Public String DebtorID{get;set;}
    public Invoicecontroller(ApexPages.StandardController controller) {
        Invoice = (akritiv__Transaction__c)controller.getRecord();
        Invoice.Invoice_Status_Internex__c = 'Pending Approval';
        if(Invoice.Debtor__c != NULL)
        {
            DebtorID = Invoice.Debtor__c;
            FillCounterParty();
        }
    }
    Public Void FillCounterParty()
    {
        
        String CounterPartyID = [Select Counterparty__c from Debtor__c where id =: DebtorID limit 1].Counterparty__c;
        Invoice.akritiv__Account__c = ID.valueof(CounterPartyID);
    }
    Public Pagereference SaveInvoice()
    {
       try
        {
            
            Invoice.akritiv__Balance__c = Invoice.Akritiv__Amount__C;
            Invoice.Remaining_Amt_from_Portal__c = Invoice.Akritiv__Amount__C;
            Insert Invoice;
            return new pagereference('/'+Invoice.Id);
        }Catch(Exception e){
            system.debug('Exception => '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
        }
        return Null;
    }
    Public Pagereference SaveandNewInvoice()
    {
         try
        {
            Invoice.akritiv__Balance__c = Invoice.Akritiv__Amount__C;
            Invoice.Remaining_Amt_from_Portal__c = Invoice.Akritiv__Amount__C;
            Insert Invoice;
            PageReference pageRef = new PageReference('/apex/InvoiceNewPage');
            pageRef.setRedirect(true);
            return pageRef;
            
        }Catch(Exception e){
            system.debug('Exception => '+ e);
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
        }
        return Null;
    }
    Public Pagereference Cancel()
    {
         Schema.DescribeSObjectResult result =akritiv__Transaction__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
             
            pageRef.setRedirect(true);
            return pageRef;
    }
}