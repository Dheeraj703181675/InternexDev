@isTest
public class TestInvoicemodification {
	Static Testmethod void Testmethod1()
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
        Test.startTest();
        InvoiceModification IM = new InvoiceModification();
        IM.InvoiceSearch();
        IM.operation = 'Modification';
        IM.Inv.Client_Acc__c =  ClientAccountList[1].id;
		IM.Inv.Debtor__c = debtorList[0].id;
        IM.Inv.Document_Date__c = Date.today();
        IM.Inv.Last_Payment_Date__c = Date.today();
        IM.Inv.akritiv__Amount__c = 1000;
        IM.ApprovalStatus = 'Pending Approval';
        IM.InvoiceSearch();
        
		IM.Invoicewrapperlist[0].Invoice.Name = 'Modified Invoice for Test';
        IM.Invoicewrapperlist[0].Check = True;
		IM.SaveInvoices();
        
        IM.operation = 'Write-off';
        IM.Inv.Client_Acc__c =  ClientAccountList[1].id;
        IM.Inv.Debtor__c = debtorList[0].id;
        IM.Inv.Document_Date__c = Date.today();
        IM.Inv.Last_Payment_Date__c = Date.today();
        IM.Inv.akritiv__Amount__c = 1000;
        IM.ApprovalStatus = 'Approved';
        IM.InvoiceSearch();
        IM.InvoiceStatus='abc';
		IM.Invoicewrapperlist[0].Writeoffamount = 500;
        IM.Invoicewrapperlist[0].Check = True;
		IM.writeoffinvoices();
        Test.stopTest(); 
    }
        }