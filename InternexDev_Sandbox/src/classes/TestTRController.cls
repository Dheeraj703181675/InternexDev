@istest
public class TestTRController
{
     @istest
    public static void TestTR()
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
        
        
        akritiv__Transaction__c testinvoice= new akritiv__Transaction__c();
        testinvoice.Name='Ankima';
        testinvoice.Currency__c='INR';
        testinvoice.akritiv__Amount__c=10000;
        testinvoice.Debtor__c=testdebtor.Id;
        testinvoice.Invoice_Status_Internex__c='Pending Approval';
       // insert testinvoice;
       
       ApexPages.StandardController sc = new ApexPages.standardController(testinvoice);
         TRController controller = new TRController(sc);
        
        controller.SaveTR();
      
    }

}