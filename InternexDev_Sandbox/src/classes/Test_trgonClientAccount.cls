@istest
public class Test_trgonClientAccount
{
    static id ank;
    static testmethod void trgonCA()
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
        
        Contact  con = new Contact();
        con.CurrencyIsoCode ='USD';
        con.LastName='srivastava';
        con.AccountId=TestAcc.Id;
        con.Contact_Key__c='hgf5';
        con.Email ='ankima.sr@gmail.com';
        insert con;
        
          Product__c testProduct = new Product__c();
          testProduct.Name = 'LOC';
         testProduct.External_Id__c='ghfhgf7';
          insert testProduct;
        
          akritiv__Brand__C TestClient = new akritiv__Brand__C();
         TestClient.CounterParty__c = TestAcc.Id;
         TestClient.Name = TestAcc.Name;
         TestClient.External_Id__c='hghh4';
          insert TestClient;
        
        
        
        Client_Account__c testCA = new Client_Account__c();
          ank = testCA.Id;
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
           testCA.Client_External_Foreign_Key__c ='hghh4';
           testCA.Product_External_Foreign_Key__c = 'ghfhgf7';
            testCA.Primary_Contact_External_ID__c='hgf5';
              testCA.Secondary_Contact_External_Id__c='ggg5';
        testCA.Non_performing_asset__c=true;
        testCA.IUF_Reserve_Retained__c=Null;
            insert testCA;
        testCA.Non_performing_asset__c=false;
        update testCA;
        
    }
    
     static id pank;
    static testmethod void trgonCA1()
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
        
        Contact  con = new Contact();
        con.CurrencyIsoCode ='USD';
        con.LastName='srivastava';
        con.AccountId=TestAcc.Id;
        con.Contact_Key__c='ggg5';
        con.Email ='ankima.sr@gmail.com';
        insert con;
        
          Product__c testProduct = new Product__c();
          testProduct.Name = 'LOC';
         testProduct.External_Id__c='ghfhgf7';
          insert testProduct;
        
          akritiv__Brand__C TestClient = new akritiv__Brand__C();
         TestClient.CounterParty__c = TestAcc.Id;
         TestClient.Name = TestAcc.Name;
         TestClient.External_Id__c='hghh4';
          insert TestClient;
        
        
        
        Client_Account__c testCA = new Client_Account__c();
          pank = testCA.Id;
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
           testCA.Client_External_Foreign_Key__c ='hghh4';
           testCA.Product_External_Foreign_Key__c = 'ghfhgf7';
            testCA.Primary_Contact_External_ID__c='hgf5';
              testCA.Secondary_Contact_External_Id__c='ggg5';
        testCA.Non_performing_asset__c=false;
        testCA.IUF_Reserve_Retained__c=Null;
        testCA.Interest_Due__c=100;
        testCA.UL_Fee_Due__c=100;
            insert testCA;
        testCA.Non_performing_asset__c=true;
        testCA.Interest_Due__c = 50;
        testCA.UL_Fee_Due__c=50;
        update testCA;
        
    }

    

}