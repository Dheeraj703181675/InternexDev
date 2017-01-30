@istest
public class Test_trgonDebtor 
{
    static testmethod void trgonDebtor()
    {
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
          // TestAcc.akritiv__Account_Key__c='fff44';
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
           TestAcc1.akritiv__Account_Key__c='fff44';
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
            testCA.External_Id__c='fgffg5';
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
           testdebtor.ClientAccount_External_Foreign_Key__c='fgffg5';
           testdebtor.CounterParty_External_Foreign_Key__c='fff44';
            insert testdebtor;
        
        task ta = new task();
        ta.Status='Not Started';
        ta.WhatId=testdebtor.Id;
        insert ta;

        
    }
    
    static testmethod void trgonDebtor1()
    {
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
          // TestAcc.akritiv__Account_Key__c='fff44';
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
           TestAcc1.akritiv__Account_Key__c='fff44';
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
            testCA.External_Id__c='fgffg5';
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
           testdebtor.ClientAccount_External_Foreign_Key__c='fgffg5';
           testdebtor.CounterParty_External_Foreign_Key__c='fff44';
           testdebtor.Portal_External_Id__c=Null;
            insert testdebtor;
         testdebtor.Portal_External_Id__c='ghfg6';
        update testdebtor;
        
        
    }
    
     static testmethod void trgonDebtor2()
    {
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
          // TestAcc.akritiv__Account_Key__c='fff44';
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
           TestAcc1.akritiv__Account_Key__c='fff44';
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
            testCA.External_Id__c='fgffg5';
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
           testdebtor.ClientAccount_External_Foreign_Key__c='fgffg5';
           testdebtor.CounterParty_External_Foreign_Key__c='fff44';
           testdebtor.Portal_External_Id__c=Null;
            insert testdebtor;
         
        delete testdebtor;
        
        
    }


}