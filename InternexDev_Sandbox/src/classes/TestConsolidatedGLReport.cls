@istest
public class TestConsolidatedGLReport {
	static testmethod void testmethod1()
    {
        Account TestAcc = new Account();
        TestAcc.Name ='Lockbox Account';
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

  		Monthly_Interest_Application__c MI = new Monthly_Interest_Application__c();
        MI.Client_Account__c =testCA.id;
       // MI.Name='abc';
        MI.Date__c = Date.today();
        Insert MI;
        
        Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
        Di.Monthly_Interest_Application__c = MI.ID;
        DI.Date__c = Date.today();
        Insert DI;
        
        FIU_Report__c FIU = new FIU_Report__c();
        FIU.Client_Account__c = testCA.id;
        FIU.Date__c = Date.today();
        FIU.Funding__c = 1000;
        FIU.Payments__c = 10;
        FIU.Reference__c = 'Test1';
        FIU.Transaction_ID__c = 'Test1';
        FIU.Transaction_Name__c = 'Testing';
        insert FIU;
        
        Applied_Monthly_Interest__c AMI = new Applied_Monthly_Interest__c();
        AMI.Client_Account__c = testCA.id;
        //AMI.Client_Account__c = 'a1tR0000003PoUgIAK';
        AMI.Date__c = date.today();
        AMI.Monthly_Interest_Application__c = MI.Id;
        AMI.Commitment_fee_Accrued__c = -0.34;
        AMI.Reference__c = 'a1yR0000000tOalIAE';
        AMI.Name = '10-2016 Report';
        AMI.Interest__c= 2.38;
       // AMI.Monthly_Interest_Application__r.name = MI.Name;
        //AMI.CreatedDate = system.now();
        insert AMI;
        
        test.startTest();
        	Consolidated_GL_Report CG = new Consolidated_GL_Report();
            database.executeBatch(CG, 1);
        Test.stopTest();
    }       
       
        
    }