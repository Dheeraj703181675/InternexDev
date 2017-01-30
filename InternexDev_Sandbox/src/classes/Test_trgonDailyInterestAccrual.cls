@istest
public class Test_trgonDailyInterestAccrual 
{
    static testmethod void trgonDailyInterestAcc()
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


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
        DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        
        
    }
    static testmethod void trgonDailyInterestAcc1()
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
        testCA.IUF_Reserve_Retained__c=6;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=10;
        testCA.Interest_Due_Since__c=date.today();
        testCA.UL_Fee_Due_Since__c=null;
            insert testCA;


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
        DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        
        
    }
    static testmethod void trgonDailyInterestAcc2()
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
        testCA.IUF_Reserve_Retained__c=0;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=10;
        testCA.Interest_Due_Since__c=date.today();
        testCA.UL_Fee_Due_Since__c=null;
            insert testCA;


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
        DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        
        
    }
    
     static testmethod void trgonDailyInterestAcc3()
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
        testCA.IUF_Reserve_Retained__c=0.01;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=10;
        testCA.Interest_Due_Since__c=null;
        testCA.UL_Fee_Due_Since__c=date.today();
            insert testCA;


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
        DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        
        
    }
    // -----------------to make BsnsTransact = null (satisfying if condition) START------------
    
    static testmethod void trgonDailyInterestAcc4()
    {
       /* BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
        BTD.Business_Transaction_Date__c = Date.today();
        insert BTD; */

      
        
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
        testCA.IUF_Reserve_Retained__c=0.01;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=10;
        testCA.Interest_Due_Since__c=null;
        testCA.UL_Fee_Due_Since__c=date.today();
            insert testCA;


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
       // DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        
        
    }

 // -----------------to make BsnsTransact = null (satisfying if condition) END------------------)


static testmethod void trgonDailyInterestAcc5()
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
        testCA.IUF_Reserve_Retained__c=6;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=10;
        testCA.Interest_Due_Since__c=null;
        testCA.UL_Fee_Due_Since__c=date.today();
            insert testCA;


        Monthly_Interest_Application__c MIA = new Monthly_Interest_Application__c();
        MIA.Client_Account__c = testCA.Id;
        MIA.Date__c=date.today();
        MIA.CurrencyIsoCode='USD';
        MIA.Applied__c = True;
        MIA.Interest_Charged__c=2;
        MIA.UL_Fee_Charged__c = 2;
        insert MIA;
        
        Daily_Interest_Accrual__c DIA = new Daily_Interest_Accrual__c();
        DIA.Monthly_Interest_Application__c = MIA.Id;
        DIA.Business_Transaction_Date__c = date.today()+27;
        DIA.Date__c=date.today()+27;
        DIA.Interest_Base_Rate__c = 2;
        DIA.Interest_Spread__c=2;
        DIA.CurrencyIsoCode = 'USD';
        DIA.FIU_Outstanding__c=200;
        DIA.Funding_Limit__c=500;
        DIA.Commitment__c=20;
        DIA.Method__c='ACTUAL/360';
        DIA.Non_performing_asset__c=false;
        DIA.Commitment_rate__c =1000;
       
        insert DIA;
        delete DIA;
        
        
    }



}