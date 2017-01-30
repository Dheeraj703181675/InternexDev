@istest
public class TestPaymentTop5Batch
{
    static testmethod void paymentTop5Batch()
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
            CA.Client__c = Client.Id;
            CA.Product__c = Product.Id;
            CA.CurrencyIsoCode='USD';
            CA.External_Id__c='re4';
            CA.External_Req_Id__c='556tt';
            CA.Portal_External_Id__c='hjgh4';
            CA.MP_External_Id__c='sss3';
            CA.Sync_with_Grade__c=true;
            CA.Sync_with_Market_Place__c=true;
            CA.Sync_with_Portal__c=true;
            CA.Source__c='abc';
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
        
           
            
         
         Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = CA.Id;
            Debt.Counterparty__c = Acc1.Id;
            Debt.Dilution__c = 5;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
            Debt.Debtor_Status__c = 'Eligible';
            insert Debt;
        
       akritiv__Payment__c testPayment = new akritiv__Payment__c();
        testPayment.Name = 'Ankima Payment';
        testPayment.Debtor__c = Debt.Id;
        testPayment.Client_Account__c = CA.Id;
        testPayment.akritiv__Payment_Date__c=Date.today();
        testPayment.akritiv__Amount__c= 15000;
        testPayment.Sync_with_Grade__c= false;
        testPayment.Sync_with_Portal__c=false;
        
        testPayment.akritiv__Amount__c=1200;
        testPayment.akritiv__Bank_Name__c='abc';
        testPayment.akritiv__Customer_Name__c='def';
        testPayment.akritiv__Payment_Address__c='ghi';
        testPayment.Payment_Status__c='Partially Applied';
        testPayment.akritiv__Payment_Type__c='Manual';
        testPayment.akritiv__Phone__c='ooo';
        testPayment.akritiv__Status__c='unapplied';
        testPayment.akritiv__Amount__c=100;
        //testPayment.akritiv__Applied_Amount__c=20;
        testPayment.MP_External_Id__c='34d';
        testPayment.Portal_External_Id__c='4546f';
        testPayment.Sync_with_Market_Place__c=True;
        testPayment.Sync_with_Grade__c=True;
        testPayment.Sync_with_Portal__c=True;
        insert testPayment; 
        
        
        
        
         Test.startTest();
        SchedulableContext ctx;
        PaymentsandFundingAllocation_Scheduler IB = new PaymentsandFundingAllocation_Scheduler();
        IB.execute(ctx);
       // Payments_ToP5_Batch PTB= new Payments_ToP5_Batch();
       // Database.executeBatch(PTB, 20);
        Test.stopTest(); 

    }

}