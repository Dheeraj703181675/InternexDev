@isTest
public class TestPaymentController {
	static testmethod void PaymentControllerTest()
    {
         List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 1000;
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
            Debt.Max_Credit_Period__c = 60;
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
        List<akritiv__Transaction__c> Invoicelist = new List<akritiv__Transaction__c>();
       	for(Integer j = 0 ;j < 1 ; j++)
        {
            akritiv__Transaction__c Invoice = new akritiv__Transaction__c();
            Invoice.Name = 'Test Invoice'+j;
          	Invoice.akritiv__Amount__c = 1000;
            Invoice.akritiv__Balance__c = 1000;
            Invoice.akritiv__Account__c = AccountList[j].id;
            Invoice.Remaining_Amt_from_Portal__c = 1000;
            Invoice.akritiv__Create_Date__c = Date.today();
            Invoice.Transaction_Date__c = Date.today();
            Invoice.Debtor__c = debtorList[j].Id;
            Invoice.Invoice_Status_Internex__c = 'Approved';
            Invoice.akritiv__Batch_Number__c = 'Batch'+j;
            Invoice.Source__c = 'Akritiv';
            Invoicelist.add(Invoice);
        }
        insert Invoicelist;
       
        ApexPages.StandardController SC = new ApexPages.StandardController(New akritiv__Payment__c());
        Paymentcontroller PC = new Paymentcontroller(SC);
        PC.Payment.Name = 'Testing Payment';
       // PC.Payment.Debtor__c = debtorList[0].Id;
       // PC.Payment.Client_Account__c = ClientAccountList[1].id;
        PC.Payment.akritiv__Account__c =  AccountList[0].id;
        PC.Payment.akritiv__Amount__c = 200;
        PC.payment.akritiv__Payment_Type__c = 'Manual';
        PC.Payment.akritiv__Payment_Date__c = Date.today();
        PC.Savepayments();
        ApexPages.StandardController SC1 = new ApexPages.StandardController(New akritiv__Payment__c(Debtor__c = debtorList[0].Id));
        Paymentcontroller PC1 = new Paymentcontroller(SC1);
        PC1.Payment.Name = 'Testing Payment';
       // PC1.Payment.Debtor__c = debtorList[0].Id;
      //  PC1.Payment.Client_Account__c = ClientAccountList[1].id;
        PC1.Payment.akritiv__Account__c =  AccountList[0].id;
        PC1.payment.akritiv__Payment_Type__c = 'Manual';
        PC1.Payment.akritiv__Amount__c = 200;
        PC1.Payment.akritiv__Payment_Date__c = Date.today();
        PC1.SaveandNewPayments();
        PC1.Cancel();
         ApexPages.StandardController SC2 = new ApexPages.StandardController(New akritiv__Payment__c());
        Paymentcontroller PC2 = new Paymentcontroller(SC2);
        PC2.Payment.Name = 'Testing Payment';
       // PC1.Payment.Debtor__c = debtorList[0].Id;
        PC2.Payment.Client_Account__c = ClientAccountList[1].id;
       // PC1.Payment.akritiv__Account__c =  AccountList[0].id;
        PC2.payment.akritiv__Payment_Type__c = 'Manual';
        PC2.Payment.akritiv__Amount__c = 200;
        PC2.Payment.akritiv__Payment_Date__c = Date.today();
        PC2.FillClientaccount();
        PC2.Savepayments();
        PC2.SaveandNewPayments();
         
    }
}