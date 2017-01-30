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
public class TestInvoicelistcontroller {
	Static Testmethod void InvoicelistcontrollerTest()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
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
            Client.QB_AccessTokenSecret__c = 'TestAccessToken';
            Client.QB_ConsumerKey__c = 'TestConsumerkey';
            Client.QB_ConsumerSecret__c = 'TestConsumerSecret';
            Client.QB_OauthToken__c = 'TestOauthToken';
            Client.QB_Realm__c = '120392823';
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
        
        list<akritiv__Transaction__c> Invoicelist = new list<akritiv__Transaction__c>();
        for(integer i = 0 ;i < 2; i++)
        {
            akritiv__Transaction__c Invoice = new akritiv__Transaction__c();
            Invoice.name = 'Test Invoice'+i;
            Invoice.Debtor__c = debtorList[i].id;
            Invoice.akritiv__Account__c = AccountList[i].id;
            Invoice.akritiv__Amount__c = 1000;
            Invoice.akritiv__Create_Date__c = Date.today();
            Invoice.Transaction_Date__c = Date.today();
            Invoice.akritiv__Balance__c = 1000;
            Invoice.akritiv__Batch_Number__c = 'Batch'+i;
            Invoice.Source__c = 'Akritiv';
            Invoice.Invoice_Status_Internex__c = 'Pending Approval';
            Invoicelist.add(Invoice);
        }
        Insert Invoicelist;
        Apexpages.StandardController SC = new Apexpages.StandardController(New akritiv__Transaction__c());
        Invoicelistcontroller ILC = new Invoicelistcontroller(SC);
        ILC.Debtor = debtorList[0];
        ILC.getSelectbatch();
        ILC.showclientAccountName();
        ILC.limits = '10';
        
        ILC.BatchNumber = 'Batch0';
        ILC.Invoicestatus = 'Pending Approval';
        ILC.RefreshTable();
		ILC.getInvoicelistwrap();
    //  ILC.getInvoicelistwrap()[0].check = True;
        ILC.InvoiceApprove();
        ILC.Invoicestatus = 'Approved';
        ILC.RefreshTable();
        ILC.InvoiceReject();
        
        ILC.RefreshTable();
        ILC.changeLimit();
        ILC.first();
        ILC.next();
        ILC.last();
        ILC.previous();
  
    }
    
    Static Testmethod void InvoicelistcontrollerTest1()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
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
            Client.QB_AccessTokenSecret__c = 'TestAccessToken';
            Client.QB_ConsumerKey__c = 'TestConsumerkey';
            Client.QB_ConsumerSecret__c = 'TestConsumerSecret';
            Client.QB_OauthToken__c = 'TestOauthToken';
            Client.QB_Realm__c = '120392823';
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
        
        list<akritiv__Transaction__c> Invoicelist = new list<akritiv__Transaction__c>();
        for(integer i = 0 ;i < 2; i++)
        {
            akritiv__Transaction__c Invoice = new akritiv__Transaction__c();
            Invoice.name = 'Test Invoice'+i;
            Invoice.Debtor__c = debtorList[i].id;
            Invoice.akritiv__Account__c = AccountList[i].id;
            Invoice.akritiv__Amount__c = 1000;
            Invoice.akritiv__Create_Date__c = Date.today();
            Invoice.Transaction_Date__c = Date.today();
            Invoice.akritiv__Balance__c = 1000;
            Invoice.akritiv__Batch_Number__c = 'Batch'+i;
            Invoice.Source__c = 'Akritiv';
            Invoice.Invoice_Status_Internex__c = 'Approved';
            Invoicelist.add(Invoice);
        }
        Insert Invoicelist;
        Apexpages.StandardController SC = new Apexpages.StandardController(New akritiv__Transaction__c());
        Invoicelistcontroller ILC = new Invoicelistcontroller(SC);
        ILC.Debtor = debtorList[0];
        ILC.getSelectbatch();
        ILC.showclientAccountName();
        ILC.limits = '10';
        
        ILC.BatchNumber = 'Batch0';
        ILC.Invoicestatus = 'Pending Approval';
        ILC.RefreshTable();
		ILC.getInvoicelistwrap();
    //  ILC.getInvoicelistwrap()[0].check = True;
        ILC.InvoiceApprove();
        ILC.Invoicestatus = 'Approved';
        ILC.RefreshTable();
        ILC.InvoiceReject();
        
        ILC.RefreshTable();
        ILC.changeLimit();
        ILC.first();
        ILC.next();
        ILC.last();
        ILC.previous();
  
    }
    Static Testmethod void InvoicelistcontrollerTest2()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
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
            Client.QB_AccessTokenSecret__c = 'TestAccessToken';
            Client.QB_ConsumerKey__c = 'TestConsumerkey';
            Client.QB_ConsumerSecret__c = 'TestConsumerSecret';
            Client.QB_OauthToken__c = 'TestOauthToken';
            Client.QB_Realm__c = '120392823';
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
        
        list<akritiv__Transaction__c> Invoicelist = new list<akritiv__Transaction__c>();
        for(integer i = 0 ;i < 2; i++)
        {
            akritiv__Transaction__c Invoice = new akritiv__Transaction__c();
            Invoice.name = 'Test Invoice'+i;
            Invoice.Debtor__c = debtorList[i].id;
            Invoice.akritiv__Account__c = AccountList[i].id;
            Invoice.akritiv__Amount__c = 1000;
            Invoice.akritiv__Create_Date__c = Date.today();
            Invoice.Transaction_Date__c = Date.today();
            Invoice.akritiv__Balance__c = 1000;
            Invoice.akritiv__Batch_Number__c = 'Batch'+i;
            Invoice.Source__c = 'Akritiv';
            Invoice.Invoice_Status_Internex__c = 'Rejected';
            Invoicelist.add(Invoice);
        }
        Insert Invoicelist;
        Apexpages.StandardController SC = new Apexpages.StandardController(New akritiv__Transaction__c());
        Invoicelistcontroller ILC = new Invoicelistcontroller(SC);
        ILC.Debtor = debtorList[0];
        ILC.getSelectbatch();
        ILC.showclientAccountName();
        ILC.limits = '10';
        ILC.pageNumber =2;
       
        ILC.BatchNumber = 'Batch0';
        ILC.totalPage=10;
        ILC.Invoicestatus = 'Pending Approval';
        ILC.RefreshTable();
		ILC.getInvoicelistwrap();
       
    //  ILC.getInvoicelistwrap()[0].check = True;
        ILC.InvoiceApprove();
        ILC.Invoicestatus = 'Approved';
        ILC.RefreshTable();
        ILC.InvoiceReject();
        ILC.hasNext=true;
         ILC.setCon.getHasNext();
        ILC.hasPrevious=true;
        ILC.RefreshTable();
        ILC.changeLimit();
        ILC.first();
        ILC.next();
        ILC.last();
        ILC.previous();
  
    }
   


}