@istest
public class Test_trgonLockbox
{
     static testmethod void trgonLock()
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
         
          Client_Account__c testCA1 = new Client_Account__c();
          
           testCA1.Client__c = TestClient.Id;
           testCA1.Product__c = testProduct.Id;
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
           testCA1.Client_External_Foreign_Key__c ='hghh4';
           testCA1.Product_External_Foreign_Key__c = 'ghfhgf7';
            testCA1.Primary_Contact_External_ID__c='hgf5';
              testCA1.Secondary_Contact_External_Id__c='ggg5';
        testCA1.Non_performing_asset__c=true;
        testCA1.IUF_Reserve_Retained__c=Null;
            insert testCA1;

         
         /*  LockBox_Account__c lock1 = new LockBox_Account__c();
        // lock.Name='lockbox';
         lock1.Account_Number__c='4000161802';
         lock1.Routing_Number__c='121000248';
         lock1.Client_Account__c=testCA.id;
         lock1.Lockbox_Number__c='56565';
         lock1.Street_Address__c='abc';
        // lock.Account_Routing_Number__c='4000161802121000248';
         insert lock1; */
    
         LockBox_Account__c lock = new LockBox_Account__c();
        // lock.Name='lockbox';
         lock.Account_Number__c='1';
         lock.Routing_Number__c='2';
         lock.Client_Account__c=testCA.id;
         lock.Lockbox_Number__c='56565';
         lock.Street_Address__c='abc';
        // lock.Account_Routing_Number__c='12';
         insert lock;
        LockBox_Account__c lock1 = new LockBox_Account__c();
        // lock.Name='lockbox';
         lock1.Account_Number__c='11';
         lock1.Routing_Number__c='22';
         lock1.Client_Account__c=testCA1.id;
         lock1.Lockbox_Number__c='56565';
         lock1.Street_Address__c='abddc';
        // lock.Account_Routing_Number__c='12';
         insert lock1;
     }
    
    static testmethod void trgonLock1()
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
         
        
    
         LockBox_Account__c lock = new LockBox_Account__c();
        // lock.Name='lockbox';
         lock.Account_Number__c='4000161802';
         lock.Routing_Number__c='121000248';
         lock.Client_Account__c=testCA.id;
         lock.Lockbox_Number__c='56565';
         lock.Street_Address__c='abc';
        // lock.Account_Routing_Number__c='4000161802121000248';
         insert lock;
         lock.Street_Address__c='abcedf'; 
         lock.Account_Number__c='4500161802';
         lock.Routing_Number__c='124000248';
         update lock;
         
     } 
    
    static testmethod void trgonLock2()
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
    
         LockBox_Account__c lock = new LockBox_Account__c();
        // lock.Name='lockbox';
         lock.Account_Number__c='4000161802';
         lock.Routing_Number__c='121000248';
         lock.Client_Account__c=testCA.id;
         lock.Lockbox_Number__c='56565';
         lock.Street_Address__c='abc';
        // lock.Account_Routing_Number__c='4000161802121000248';
         insert lock;
         
         delete lock;
     }



}