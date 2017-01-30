@istest
public class TestPaymentstoportal_1 
{
    static testmethod void TestPaymentstoportal()
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
            insert Debtor;
        
        Bank_Account_Matrix__c BA = new Bank_Account_Matrix__c();
        BA.Bank_Name__c='abcdefg';
        BA.Bank_Account__c='savings';
        BA.Account__c=acc.Id;
        BA.Routing_Number__c='gfhgf56';
        insert BA;
        
        akritiv__Payment__c payment = new akritiv__Payment__c();
        payment.akritiv__Account__c = Acc.Id;
        payment.akritiv__Bank_Name__c='bankgfgff';
        payment.akritiv__Customer_Name__c='Ankima';
        payment.akritiv__Payment_Address__c='abc';
        payment.akritiv__Payment_Date__c= date.today();
        payment.akritiv__Payment_Type__c='Manual';
        payment.akritiv__Phone__c='6756fgfg';
        payment.akritiv__Status__c='Unapplied';
       // payment.akritiv__Unapplied_Balance__c=100;
      // payment.akritiv__Applied_Amount__c=100;
        payment.MP_External_Id__c='65ty';
        payment.Portal_External_Id__c='fgf';
        payment.Sync_with_Market_Place__c=false;
        payment.Sync_with_Grade__c=true;
        payment.Sync_with_Portal__c=false;
        payment.Bank_Account__c= BA.Id;
       payment.Client_Account__c = CA.Id;
      // paymnt internex formula
      // debtor name formula
       payment.Transaction_Date__c= date.today();
       payment.Portal_Transaction_Id__c='abcff44';
       payment.Business_Transaction_Date__c=date.today();
      // payment.Unapplied_Amount_internex__c=100;
       payment.Payment_Status__c='Unapplied';
     //  payment.Account_Name__c='ggfg';
      // payment.Account_Type__c='yyg5';
      // payment.Batch_Number__c
        payment.Document_Date__c=date.today();
        payment.Document_Number__c='ahgg4';
        payment.Document_Type__c='ghg';
        payment.IsActive__c=true;
        payment.Transaction_Type__c='Apply Cash';
       // payment.UnApplied_Balance_calc__c=100;
        payment.Write_Off_Type__c='Bank Charges';
      //----  payment.Count__c
       payment.Debtor__c= debtor.Id;
       payment.External_Id__c='ahg5';
        insert payment;
        
        akritiv__Transaction__c invoice = new akritiv__Transaction__c();
        invoice.Name='Ankima';
        invoice.Currency__c='INR';
        invoice.akritiv__Amount__c=10000;
        invoice.Debtor__c=debtor.Id;
       // invoice.Credit_Period__c=1;
        invoice.Sync_with_Portal__c=False;
        invoice.Invoice_Status_Internex__c='APPROVED';
        insert invoice;
        
       akritiv__Payment_Line__c line = new akritiv__Payment_Line__c();
        line.akritiv__Payment__c= payment.Id;
        line.akritiv__Applied_To__c = invoice.Id;
       // insert line;
        
        Test.startTest();
        Paymentstoportal_1 IB= new Paymentstoportal_1();
         Database.executeBatch(IB, 20);
         
        
        Test.stopTest(); 
        
        
        
    }

}