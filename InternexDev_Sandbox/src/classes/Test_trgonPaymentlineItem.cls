@istest
public class Test_trgonPaymentlineItem
{
    static testmethod void Test_trgonPaymentlineItemdata()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;


            Account TestAcc3 = new Account();
            TestAcc3.Name ='abghc';
            TestAcc3.AccountNumber = '00hgqsw';
            TestAcc3.akritiv__Account_Key__c = 'keyuy001' ;
            TestAcc3.Funding_Limit__c = 100000;
            TestAcc3.Email__c = 'abgc@gmail.com';
            TestAcc3.PAN_TAN__c = '193456789';
            TestAcc3.BillingState = 'NY';
            TestAcc3.BillingPostalCode = '99999';
            TestAcc3.Funding_Limit__c = 100000;
            insert TestAcc3;
            
            Account TestAcc4 = new Account();
            TestAcc4.Name ='ahbcd';
            TestAcc4.AccountNumber = '0y40qsw';
            TestAcc4.akritiv__Account_Key__c = 'keky3001' ;
            TestAcc4.Funding_Limit__c = 500000;
            TestAcc4.Email__c = 'ahbcd@gmail.com';
            TestAcc4.PAN_TAN__c = '133456789';
            TestAcc4.BillingState = 'NY';
            TestAcc4.BillingPostalCode = '99999';
            TestAcc4.Funding_Limit__c = 300000;
            insert TestAcc4;
            
            Product__c testProduct1 = new Product__c();
            testProduct1.Name = 'LO';
            insert testProduct1;
            
            akritiv__Brand__C TestClient1 = new akritiv__Brand__C();
            TestClient1.CounterParty__c = TestAcc3.Id;
            TestClient1.Name = TestAcc3.Name;
            insert TestClient1;
            
            Client_Account__c testCA1 = new Client_Account__c();
            testCA1.Client__c = TestClient1.Id;
            testCA1.Product__c = testProduct1.Id;
            testCA1.Funding_Limit__c = 100000;
            testCA1.Commitment__c = 1000;
            testCA1.Commitment_rate__c = 3.5;
            testCA1.Index__c = 'WS Prime';
            testCA1.Method__c = '360/Actual';
            testCA1.Rate_Type__c = 'Fixed';
            testCA1.Spread__c = 5;
            testCA1.Rate__c = 10;
            testCA1.Index_Value__c = 0;
            testCA1.Borrowing_Base_Reserve__c = 0;
            testCA1.Minimum_Drawal_Fee__c = 100;
            testCA1.Minimum_Origination_Fee__c = 100;
            testCA1.Drawal_Fee_Percentage__c = 8;
            testCA1.Origination_Fee_Percentage__c = 6;
            testCA1.IUF_Reserve_Retained__c=20;
            testCA1.Interest_Due__c=100;
            testCA1.UL_Fee_Due__c=10;
            testCA1.Interest_Due_Since__c=date.today();
            testCA1.UL_Fee_Due_Since__c=date.today();
            insert testCA1;
            
            
            Debtor__c testdebtor1= new Debtor__c();
            testdebtor1.Client_Account__c = testCA1.Id;
            testdebtor1.Counterparty__c = TestAcc4.Id;
            testdebtor1.Dilution__c = 4;
            testdebtor1.Funding_Limit__c = 40000;
            testdebtor1.Concentration_Limit__c = 40;
            testdebtor1.Eligible_AR__c = 2000;
            testdebtor1.Borrowing_Base_Reserve__c = 0;
            testdebtor1.Max_Credit_Period__c = 80;
            testdebtor1.Debtor_Status__c = 'Eligible';
            insert testdebtor1;
            
            akritiv__Transaction__c invoice1 = new akritiv__Transaction__c();
            invoice1.Name='Ahnkima';
            invoice1.Currency__c='INR';
            invoice1.akritiv__Amount__c=10000;
            invoice1.Debtor__c=testdebtor1.Id;
            // invoice.Credit_Period__c=1;
            invoice1.Sync_with_Portal__c=False;
            invoice1.Invoice_Status_Internex__c='APPROVED';
            invoice1.Portal_External_Id__c='ghghg4';
          //  test.startTest();
            insert invoice1;
          //  test.stopTest();
            akritiv__Payment__c testPayment1 = new akritiv__Payment__c();
            testPayment1.Name = 'Anhkima Payment';
            testPayment1.Debtor__c = testdebtor1.Id;
            testPayment1.Client_Account__c = testCA1.Id;
            testPayment1.akritiv__Payment_Date__c=Date.today();
            testPayment1.akritiv__Amount__c= 15000;
            testPayment1.Sync_with_Grade__c= false;
            testPayment1.Sync_with_Portal__c=false;
            testPayment1.akritiv__Payment_Type__c='Manual';
            testPayment1.Portal_External_Id__c='gghg545';
            testPayment1.Payment_Status__c='Applied - No Funds';
            
            // test.startTest();
            insert testPayment1;
            // test.stopTest();
            
            
            akritiv__Payment_Line__c obj1 = new akritiv__Payment_Line__c();
            
            obj1.akritiv__Applied_To__c=invoice1.Id;
            obj1.akritiv__Payment__c = testPayment1.Id;
            obj1.Invoice_Portal_External_ID__c='ghghg4';
            obj1.Payment_Portal_External_ID__c='gghg545';
            obj1.akritiv__Applied_Amount__c=100;
            obj1.Flag_for_Line_Amount__c = false;
            insert obj1;
            
            Fees__c Fee = new Fees__c();
            Fee.Client_Account__c = testCA1.Id;
            Fee.Fee_Amount__c = 100;
            Fee.Fee_Date__c = Date.today();
            Fee.Fee_type__c = 'Servicer Type';
            Fee.Fee_status__c = 'UNPAID';
            Fee.Fee_description__c = 'Testing';
            insert Fee;
            
            Payment_and_Fee__c PF0 = new Payment_and_Fee__c();
            PF0.Amount__c = 10;
            PF0.Fees__c = Fee.id;
            PF0.Payment_Line__c = obj1.id;
            insert PF0;
            
            Payment_and_Fee__c PF1 = new Payment_and_Fee__c();
            PF1.Amount__c = 10;
            PF1.Fees__c = Fee.id;
            PF1.Payment_Line__c = obj1.id;
            insert PF1;
            Delete PF1;            
            
        }catch(Exception e){}
    }
  /*  static testmethod void Test_trgonPaymentlineItemdata1()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            testdebtor.Debtor_Status__c = 'Eligible';
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            testPayment.Sync_with_Grade__c= false;
            testPayment.Sync_with_Portal__c=false;
            testPayment.akritiv__Payment_Type__c='Manual';
            insert testPayment;
            
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            obj.Invoice_Portal_External_ID__c='ghghg4';
            obj.Payment_Portal_External_ID__c='gghg545';
            obj.akritiv__Applied_Amount__c=0;
            test.startTest();
            insert obj;
            test.stopTest();
            obj.akritiv__Applied_Amount__c=0;
            
            update obj;
            
        }catch(Exception e){}
    }
    static testmethod void Test_trgonPaymentlineItemdata22()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            testCA.IUF_Reserve_Retained__c=20;
            testCA.Interest_Due__c=100;
            testCA.UL_Fee_Due__c=10;
            testCA.Interest_Due_Since__c=date.today();
            testCA.UL_Fee_Due_Since__c=date.today();
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            testdebtor.Debtor_Status__c = 'Eligible';
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            invoice.Portal_External_Id__c='ghghg4';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            testPayment.Sync_with_Grade__c= false;
            testPayment.Sync_with_Portal__c=false;
            testPayment.akritiv__Payment_Type__c='Manual';
            testPayment.Portal_External_Id__c='gghg545';
            //testPayment.Payment_Status__c='Applied - No Funds';
            
            
            insert testPayment;
            
            
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            obj.Invoice_Portal_External_ID__c='ghghg4';
            obj.Payment_Portal_External_ID__c='gghg545';
            obj.akritiv__Applied_Amount__c=100;
            test.startTest();
            insert obj;
            test.stopTest();
            
        }catch(Exception e){}
    }
    static testmethod void Test_trgonPaymentlineItemdata33()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            testCA.IUF_Reserve_Retained__c=20;
            testCA.Interest_Due__c=100;
            testCA.UL_Fee_Due__c=90;
            testCA.Interest_Due_Since__c=date.today();
            testCA.UL_Fee_Due_Since__c=date.today();
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            testdebtor.Debtor_Status__c = 'Eligible';
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            invoice.Portal_External_Id__c='ghghg4';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            testPayment.Sync_with_Grade__c= false;
            testPayment.Sync_with_Portal__c=false;
            testPayment.akritiv__Payment_Type__c='Manual';
            testPayment.Portal_External_Id__c='gghg545';
            //testPayment.Payment_Status__c='Applied - No Funds';
            
            
            insert testPayment;
            
            
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            obj.Invoice_Portal_External_ID__c='ghghg4';
            obj.Payment_Portal_External_ID__c='gghg545';
            obj.akritiv__Applied_Amount__c=90;
            test.startTest();
            insert obj;
            test.stopTest();
            
        }catch(Exception e){}
    }
    static testmethod void Test_trgonPaymentlineItemdata55()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            testCA.IUF_Reserve_Retained__c=20;
            // testCA.Interest_Due__c=100;
            testCA.UL_Fee_Due__c=90;
            testCA.Interest_Due_Since__c=date.today();
            testCA.UL_Fee_Due_Since__c=date.today();
            
            testCA.Sum_of_Received_funds__c=100;
            testCA.Payments__c=5;
            testCA.IUF_Reserve_Retained__c=100;
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            testdebtor.Debtor_Status__c = 'Eligible';
            
            testdebtor.Sum_of_Payments__c=90;
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            invoice.Portal_External_Id__c='ghghg4';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            testPayment.Sync_with_Grade__c= false;
            testPayment.Sync_with_Portal__c=false;
            testPayment.akritiv__Payment_Type__c='Manual';
            testPayment.Portal_External_Id__c='gghg545';
            //testPayment.Payment_Status__c='Applied - No Funds';
            testPayment.Payment_Status__c='Partially Applied - Processing'; 
            
            insert testPayment;
            
            
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            obj.Invoice_Portal_External_ID__c='ghghg4';
            obj.Payment_Portal_External_ID__c='gghg545';
            obj.akritiv__Applied_Amount__c=100;
            test.startTest();
            insert obj;
            test.stopTest();
            
            IUF__c IUF = new IUF__c();
            IUF.Client_Account__c=testCA.Id;
            IUF.IUF_Retained__c=100;
            IUF.IUF_Retained__c=5;
            IUF.Type__c='Manual';
            insert IUF;
            
        }catch(Exception e){}
    }
    static testmethod void Test_trgonPaymentlineItemdata44()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            testCA.IUF_Reserve_Retained__c=20;
            // testCA.Interest_Due__c=100;
            testCA.UL_Fee_Due__c=100;
            testCA.Interest_Due_Since__c=date.today();
            testCA.UL_Fee_Due_Since__c=date.today();
            
            testCA.Sum_of_Received_funds__c=100;
            testCA.Payments__c=5;
            testCA.IUF_Reserve_Retained__c=100;
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            testdebtor.Debtor_Status__c = 'Eligible';
            
            testdebtor.Sum_of_Payments__c=90;
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            invoice.Portal_External_Id__c='ghghg4';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            testPayment.Sync_with_Grade__c= false;
            testPayment.Sync_with_Portal__c=false;
            testPayment.akritiv__Payment_Type__c='Manual';
            testPayment.Portal_External_Id__c='gghg545';
            // testPayment.Payment_Status__c='Applied - No Funds';
            testPayment.Payment_Status__c='Applied - Processing';
            
            insert testPayment;
            
            
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            obj.Invoice_Portal_External_ID__c='ghghg4';
            obj.Payment_Portal_External_ID__c='gghg545';
            obj.akritiv__Applied_Amount__c=90;
            test.startTest();
            insert obj;
            test.stopTest();
            
            IUF__c IUF = new IUF__c();
            IUF.Client_Account__c=testCA.Id;
            IUF.IUF_Retained__c=100;
            IUF.IUF_Retained__c=5;
            IUF.Type__c='Manual';
            insert IUF;
            
        }catch(Exception e){}
    }
    static testmethod void Test_trgonPaymentlineItemdata66()
    {
        try
        {
            BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
            BTD.Business_Transaction_Date__c = Date.today();
            insert BTD;
            
            
            
            Account TestAcc = new Account();
            TestAcc.Name ='abc';
            TestAcc.AccountNumber = '00qsw';
            TestAcc.akritiv__Account_Key__c = 'key001' ;
            TestAcc.Funding_Limit__c = 100000;
            TestAcc.Email__c = 'abc@gmail.com';
            TestAcc.PAN_TAN__c = '123456789';
            TestAcc.BillingState = 'NY';
            TestAcc.BillingPostalCode = '99999';
            TestAcc.Funding_Limit__c = 100000;
            insert TestAcc;
            
            Account TestAcc1 = new Account();
            TestAcc1.Name ='abcd';
            TestAcc1.AccountNumber = '040qsw';
            TestAcc1.akritiv__Account_Key__c = 'key3001' ;
            TestAcc1.Funding_Limit__c = 500000;
            TestAcc1.Email__c = 'abcd@gmail.com';
            TestAcc1.PAN_TAN__c = '133456789';
            TestAcc1.BillingState = 'NY';
            TestAcc1.BillingPostalCode = '99999';
            TestAcc1.Funding_Limit__c = 300000;
            insert TestAcc1;
            
            Product__c testProduct = new Product__c();
            testProduct.Name = 'LOC';
            insert testProduct;
            
            akritiv__Brand__C TestClient = new akritiv__Brand__C();
            TestClient.CounterParty__c = TestAcc.Id;
            TestClient.Name = TestAcc.Name;
            insert TestClient;
            
            
            
            Client_Account__c testCA = new Client_Account__c();
            testCA.Client__c = TestClient.Id;
            testCA.Product__c = testProduct.Id;
            testCA.Funding_Limit__c = 100000;
            testCA.Commitment__c = 1000;
            testCA.Commitment_rate__c = 3.5;
            testCA.Index__c = 'WS Prime';
            testCA.Method__c = '360/Actual';
            testCA.Rate_Type__c = 'Fixed';
            testCA.Spread__c = 5;
            testCA.Rate__c = 10;
            testCA.Index_Value__c = 0;
            testCA.Borrowing_Base_Reserve__c = 0;
            testCA.Minimum_Drawal_Fee__c = 100;
            testCA.Minimum_Origination_Fee__c = 100;
            testCA.Drawal_Fee_Percentage__c = 8;
            testCA.Origination_Fee_Percentage__c = 6;
            
            insert testCA;
            
            
            Debtor__c testdebtor= new Debtor__c();
            testdebtor.Client_Account__c = testCA.Id;
            testdebtor.Counterparty__c = TestAcc1.Id;
            testdebtor.Dilution__c = 4;
            testdebtor.Funding_Limit__c = 40000;
            testdebtor.Concentration_Limit__c = 40;
            testdebtor.Eligible_AR__c = 2000;
            testdebtor.Borrowing_Base_Reserve__c = 0;
            testdebtor.Max_Credit_Period__c = 80;
            
            insert testdebtor;
            
            akritiv__Transaction__c invoice = new akritiv__Transaction__c();
            invoice.Name='Ankima';
            invoice.Currency__c='INR';
            invoice.akritiv__Amount__c=10000;
            invoice.Debtor__c=testdebtor.Id;
            // invoice.Credit_Period__c=1;
            invoice.Sync_with_Portal__c=False;
            invoice.Invoice_Status_Internex__c='APPROVED';
            invoice.Portal_External_Id__c='ghghg4';
            insert invoice;
            
            akritiv__Payment__c testPayment = new akritiv__Payment__c();
            testPayment.Name = 'Ankima Payment';
            testPayment.Debtor__c = testdebtor.Id;
            testPayment.Client_Account__c = testCA.Id;
            testPayment.akritiv__Payment_Date__c=Date.today();
            testPayment.akritiv__Amount__c= 15000;
            //testPayment.Payment_Status__c='Applied - No Funds';
            insert testPayment;
            
            akritiv__Payment_Line__c obj = new akritiv__Payment_Line__c();
            obj.akritiv__Applied_To__c=invoice.Id;
            obj.akritiv__Payment__c = testPayment.Id;
            insert obj;
            delete obj;
            
            
        }catch(Exception e){}
    }
    */
}