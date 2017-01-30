@istest
public class TestInvoiceAkritivtoPortal 
{
    static testmethod void invoicetogradeorportal()
    {
        Account Acc = new Account();
            Acc.Name ='abc';
            Acc.AccountNumber = '00qsw';
            Acc.akritiv__Account_Key__c = 'key001' ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'abc@gmail.com';
            Acc.PAN_TAN__c = '123456789';
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            Acc.Funding_Limit__c = 100000;
           insert Acc;
        
            Account Acc1 = new Account();
            Acc1.Name ='abcd';
            Acc1.AccountNumber = '00qswdd';
            Acc1.akritiv__Account_Key__c = 'key0011' ;
            Acc1.Funding_Limit__c = 200000;
            Acc1.Email__c = 'abdc@gmail.com';
            Acc1.PAN_TAN__c = '123456789';
            Acc1.BillingState = 'NY';
            Acc1.BillingPostalCode = '89999';
            Acc1.Funding_Limit__c = 200000;
           insert Acc1; 
        
          Product__c Product = new Product__c();
          Product.Name = 'LOC';
          insert Product;
        
          akritiv__Brand__C Client = new akritiv__Brand__C();
          Client.CounterParty__c = Acc.Id;
          Client.Name = Acc.Name;
          insert Client;
        
          Client_Account__c CA = new Client_Account__c();
            CA.CurrencyIsoCode='USD';
            CA.External_Id__c='223ee';
            CA.External_Req_Id__c='556t';
            CA.Portal_External_Id__c='33eed';
            CA.MP_External_Id__c='dffg22';
            CA.Sync_with_Grade__c = False;
            CA.Sync_with_Market_Place__c = False;
            CA.Sync_with_Portal__c = False;
            CA.Source__c='hhgggdd3';
            
            
            CA.Client__c = Client.Id;
            CA.Product__c = Product.Id;
            CA.Funding_Limit__c = 100000;
            CA.Commitment__c = 1000;
            CA.Commitment_rate__c = 3.5;
            CA.Index__c = 'WS Prime';
            CA.Method__c = '360/Actual';
            CA.Rate_Type__c = 'Fixed';
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            insert CA;
        
           
           Debtor__c Debtor = new Debtor__c();
            Debtor.Client_Account__c = CA.Id;
            Debtor.Counterparty__c = Acc1.Id;
            Debtor.Dilution__c = 5;
            Debtor.Funding_Limit__c = 50000;
            Debtor.Concentration_Limit__c = 50;
            Debtor.Eligible_AR__c = 1000;
            Debtor.Borrowing_Base_Reserve__c = 0;
            Debtor.Max_Credit_Period__c = 90;
            Debtor.Debtor_Status__c = 'Eligible';
            Debtor.Portal_External_Id__c='hgh5';
            insert Debtor;
        
           akritiv__Transaction__c Invoice = new akritiv__Transaction__c();
            Invoice.name = 'Test Invoice';
            Invoice.Debtor__c = debtor.id;
            Invoice.akritiv__Account__c = Acc.id;
            Invoice.akritiv__Amount__c = 1000;
            Invoice.akritiv__Create_Date__c = Date.today();
            Invoice.Transaction_Date__c = Date.today();
            Invoice.akritiv__Balance__c = 1000;
            Invoice.akritiv__Batch_Number__c = 'Batch';
            Invoice.Source__c = 'Akritiv';
            Invoice.Invoice_Status_Internex__c = 'Rejected';
            Invoice.Sync_with_Grade__c=false;
            
          Insert Invoice;
        
         
        
        Test.startTest();
        SchedulableContext ctx;
        InvoiceBatch_scheduler IB = new InvoiceBatch_scheduler();
        IB.execute(ctx);
        
      //  Invoice_Akritiv_to_Portal_Batch IB= new Invoice_Akritiv_to_Portal_Batch();
      //  Schedulable.executeBatch(IB, 20);
      //  Test.stopTest();

        
    }

}