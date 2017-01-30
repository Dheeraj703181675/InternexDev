/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class TestclientController {
	Static testmethod void CreateNewClient()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 10 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Email__c = 'Test'+i+'@test.com';
            Acc.PAN_TAN__c = '12345678'+i;
            Acc.Funding_Limit__c = 100000;
            Acc.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(10, AccountList.size());
        List<akritiv__Brand__c> ClientList = new List<akritiv__Brand__c>();
        ApexPages.StandardController SC = new ApexPages.StandardController(New akritiv__Brand__c());
        for(Integer j = 0 ;j < 5 ; j++)
        {
            ClientController CC = new ClientController(SC);
            CC.Client.CounterParty__c = AccountList[j].id;
            CC.CounterPartyId = AccountList[j].Name;
            CC.FillClientName();
            CC.SaveClient();
        }
        ClientController CC = new ClientController(SC);
        CC.Client.CounterParty__c = AccountList[6].id;
        CC.CounterPartyId = AccountList[6].Name;
        CC.FillClientName();
        CC.SaveandNew();
       
        ClientController CC1 = new ClientController(SC);
        CC.Client.CounterParty__c = AccountList[7].id;
        CC.FillClientName();
         CC.SaveClient();
         
        ClientController CC2 = new ClientController(SC);
        CC.Client.CounterParty__c = AccountList[8].id;
        CC.FillClientName();
        CC.SaveandNew();
		CC.Cancel();
        
        ClientController CC3 = new ClientController(SC);
         CC3.FillClientName();
        CC3.SaveandNew();
		
       
		
    }
    Static testmethod void CreateNewClient1()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 10 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Email__c = 'Test'+i+'@test.com';
            Acc.PAN_TAN__c = '12345678'+i;
            Acc.Funding_Limit__c = 100000;
            Acc.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(10, AccountList.size());
        List<akritiv__Brand__c> ClientList = new List<akritiv__Brand__c>();
        ApexPages.StandardController SC = new ApexPages.StandardController(New akritiv__Brand__c());
        for(Integer j = 0 ;j < 5 ; j++)
        {
            ClientController CC = new ClientController(SC);
            CC.Client.CounterParty__c = AccountList[j].id;
            CC.CounterPartyId = AccountList[j].Name;
            CC.FillClientName();
            CC.SaveandNew();
        }
        ClientController CC = new ClientController(SC);
        CC.Client.CounterParty__c = AccountList[6].id;
        CC.CounterPartyId = AccountList[6].Name;
        CC.FillClientName();
        CC.SaveandNew();
       
       
		
    }

}