@istest
public class TestUpdateMax
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
          // TestAcc.Portal_Client_Account_ID__c='hghh67';
          // TestAcc.Portal_Debtor_ID__c='gfg56';
          // TestAcc.akritiv__Account_Key__c='fff44';
           insert TestAcc;
        
        
       
    }
}