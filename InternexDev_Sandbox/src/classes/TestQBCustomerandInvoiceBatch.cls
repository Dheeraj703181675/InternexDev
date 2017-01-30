@istest
public class TestQBCustomerandInvoiceBatch
{
    static testmethod void TestBatch()
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
        
        akritiv__Brand__C Client = new akritiv__Brand__C();
          Client.CounterParty__c = Acc.Id;
          Client.Name = Acc.Name;
        Client.Portal_External_Id__c='fff333';
    /*      Client.Encryption_Key__c='abc';
          Client.QB_AccessTokenSecret__c ='aaa';
         Client.QB_ConsumerKey__c='ttt';
        Client.QB_OauthToken__c='gsdgdsg';
        Client.QB_Realm__c='dhfh';
        
        Client.QB_ConsumerSecret__c='gggf'; */
        
          insert Client;
        
        Linked_Account_Type__c LAT = new Linked_Account_Type__c();
        LAT.Name = 'QuickBooks';
        insert LAT;
        
        Linked_Account__c LA = new Linked_Account__c();
        LA.Encryption_Key__c='abc';
        LA.access_token_secret__c ='aaa';
        LA.consumer_key__c='ttt';
        LA.oauth_token__c='gsdgdsg';
        LA.realm__c='dhfh';
        LA.consumer_secret__c='gggf';
        LA.Client__c = Client.id;
        LA.Linked_Account_Type__c = LAT.id;
        Insert LA;
        
        Test.startTest();
        SchedulableContext ctx;
        QuickbooksScheduler IB = new QuickbooksScheduler();
        IB.execute(ctx); 
     /*  QBCustomerandInvoiceBatch QB= new QBCustomerandInvoiceBatch();
        Database.executeBatch(QB, 20); 
        Test.stopTest(); */

    }

}