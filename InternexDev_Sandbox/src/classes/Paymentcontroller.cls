public with sharing class Paymentcontroller {

    Public akritiv__Payment__c Payment{get;set;}
 //   Public String DebtorID{get;set;}
 //   Public Account Acc{get;set;}
    public Paymentcontroller(ApexPages.StandardController controller) {
        Payment = (akritiv__Payment__c)Controller.getRecord();
     //   if(payment.Debtor__c != NULL)
     //   {
            FillClientaccount();
     //   }
    }
  
    Public Void FillClientaccount()
    {
        if(payment.Debtor__c != NULL)
        {
            List<Debtor__c> Debtor = [Select id,Client_Account__c,Counterparty__c from Debtor__c where id =: payment.Debtor__c limit 1];
            if(Debtor.size()>0)
            {
                Payment.Client_Account__c = Debtor[0].Client_Account__c ;
                Payment.akritiv__Account__c = Debtor[0].Counterparty__C;
            }
        }
        else if(payment.Client_Account__c != NULL)
        {
            List<Client_Account__c> ClientAccount = [Select id,Client__c,Client__r.CounterParty__c from Client_Account__c where id =: payment.Client_Account__c limit 1];
            if(ClientAccount.size()>0)
            {
                Payment.Client_Account__c = ClientAccount[0].ID;
                Payment.akritiv__Account__c = ClientAccount[0].Client__r.CounterParty__c;
            }
        }
    } 
    Public Pagereference Savepayments()
    {
        try
        {
            insert Payment;
            return new pagereference('/'+Payment.Id);
        }catch(Exception e){
            system.debug('Exception  '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
        }
        return NULL;
    }
    Public Pagereference SaveandNewPayments()
    {
        try
        {
            insert Payment;
            PageReference pageRef = new PageReference('/apex/NewPayment');
            pageRef.setRedirect(true);
            return pageRef;
        }catch(Exception e){
            system.debug('Exception  '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
        }
        return NULL;
    }
    Public Pagereference Cancel()
    {
        Schema.DescribeSObjectResult result =akritiv__Payment__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
             
            pageRef.setRedirect(true);
            return pageRef;
    }
}