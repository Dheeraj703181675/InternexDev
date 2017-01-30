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
public class Test_InvoiceController {
	Static testmethod void InvoicecontrollerTest()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            Acc.Funding_Limit__c = 100000;
            Acc.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(3, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 3; i++)
        {
            Client_Account__c CA = new Client_Account__c();
            CA.Client__c = Clientlist[i].Id;
            CA.Product__c = Product.Id;
            CA.Funding_Limit__c = 100000;
            CA.Commitment__c = 1000;
            CA.Commitment_rate__c = 3.5;
            CA.Index__c = 'WS Prime';
            CA.Method__c = '360/Actual';
            CA.Rate_Type__c = 'Fixed';
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 2; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[1-i].id;
            Debt.Counterparty__c = AccountList[i].id;
            Debt.Dilution__c = 5;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 0;
            Debt.Eligible_AR__c = 0;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 0;
            Debt.Debtor_Status__c = 'Eligible';
            debtorList.add(Debt);
        }
        insert debtorList;
        BusinessTransactionDate__c BTD = new BusinessTransactionDate__c();
        BTD.Business_Transaction_Date__c = Date.today();
        insert BTD;
        
        Apexpages.StandardController SC = new Apexpages.StandardController(New akritiv__Transaction__c());
        //Invoicecontroller IC = new Invoicecontroller(SC);
        
       	for(Integer j = 0 ;j < 1 ; j++)
        {
            Invoicecontroller IC = new Invoicecontroller(SC);
            IC.Invoice.Name = 'Test Invoice'+j;
          	IC.Invoice.akritiv__Amount__c = 1000;
            IC.Invoice.akritiv__Create_Date__c = Date.today();
            IC.Invoice.Transaction_Date__c = Date.today();
            IC.Invoice.Debtor__c = debtorList[j].Id;
            IC.DebtorID = debtorList[j].Id;
            IC.FillCounterParty();
            IC.Invoice.akritiv__Batch_Number__c = 'Batch'+j;
            IC.Invoice.Source__c = 'Akritiv';	
            IC.SaveInvoice();
        }
        test.startTest();
        Apexpages.StandardController SC1 = new Apexpages.StandardController(New akritiv__Transaction__c());
        	Invoicecontroller IC = new Invoicecontroller(SC1);
            IC.Invoice.Name = 'Test Invoice1';
          	IC.Invoice.akritiv__Amount__c = 1000;
            IC.Invoice.akritiv__Create_Date__c = Date.today();
            IC.Invoice.Transaction_Date__c = Date.today();
            IC.Invoice.Debtor__c = debtorList[1].Id;
            IC.DebtorID = debtorList[1].Id;
            IC.FillCounterParty();
            IC.Invoice.akritiv__Batch_Number__c = 'Batch1';
            IC.Invoice.Source__c = 'Akritiv';	
            IC.SaveandNewInvoice();
        	IC.Cancel();
         Apexpages.StandardController SC2 = new Apexpages.StandardController(New akritiv__Transaction__c());
            Invoicecontroller IC1 = new Invoicecontroller(SC2);
            IC1.Invoice.Name = 'Test Invoice1';
          	IC1.Invoice.akritiv__Amount__c = 1000;
            IC1.Invoice.akritiv__Create_Date__c = Date.today();
            IC1.Invoice.Transaction_Date__c = Date.today();
            IC1.Invoice.Debtor__c = debtorList[1].Id;
            IC1.DebtorID = debtorList[1].Id;
            IC1.SaveandNewInvoice();
            IC1.SaveInvoice();
        test.stopTest();
    }
}