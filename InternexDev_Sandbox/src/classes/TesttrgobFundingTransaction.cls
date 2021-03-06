@isTest
public class TesttrgobFundingTransaction {
  Static Testmethod void FundingTransactionTriggerTest()
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
            ACC.BillingPostalCode = '99999';
            ACC.BillingState = 'NY';
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
            CA.Funding_Limit__c = 1000;
            CA.Commitment__c = 1000;
            CA.Commitment_rate__c = 3.5;
            CA.Index__c = 'WS Prime';
            CA.Method__c = '360/Actual';
            CA.Rate_Type__c = 'Fixed';
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Origination_Fee_Percentage__c = 8;
            CA.Drawal_Fee_Percentage__c = 6;
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        
        Capital_Provider__c CP = new Capital_Provider__c();
        CP.Name = 'Bank of America';
        insert CP;
         List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
            Debt.Dilution__c = 5;
            Debt.Max_Credit_Period__c = 60;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
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
            Invoice.akritiv__Account__c = AccountList[0].id;
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
        update debtorList;
        
        Case Cas = new Case();
        Cas.Client_Account__c = ClientAccountList[0].id;
        Cas.Status = 'Fully Funded';
        Cas.Funding_Requested__c = 400;
        Cas.Origin = 'Web';
        Cas.Wire_Mode__c=True;
       
        insert Cas;
        Funding_Transaction__c FT = new Funding_Transaction__c();
        FT.Funding_Request__c = Cas.id;
        FT.Funding_Provider__c = CP.Id;
      //  FT.Deal_Acceptance_Date__c = system.now();
      //  FT.Funding_Transaction_Date__c = system.now();
 
        Insert FT; 
        list<Funding_Transaction__c> List_FT = [Select id,Drawal_Fee__c from Funding_Transaction__c limit 1];
        if(List_FT.size()>0)
        {
            list<Funding_Transaction__c> UpdateList_FT = New List<Funding_Transaction__c>();
            for(Funding_Transaction__c FTU : List_FT)
            {
                FTU.Drawal_Fee__c = False;
                UpdateList_FT.add(FTU);
            }
            update UpdateList_FT;
        }
    }
    
     Static Testmethod void FundingTransactionTriggerTest1()
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
            ACC.BillingPostalCode = '99999';
            ACC.BillingState = 'NY';
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
            CA.Funding_Limit__c = 1000;
            CA.Commitment__c = 1000;
            CA.Commitment_rate__c = 3.5;
            CA.Index__c = 'WS Prime';
            CA.Method__c = '360/Actual';
            CA.Rate_Type__c = 'Fixed';
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Origination_Fee_Percentage__c = 8;
            CA.Drawal_Fee_Percentage__c = 6;
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        
        Capital_Provider__c CP = new Capital_Provider__c();
        CP.Name = 'Bank of America';
        insert CP;
         List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
            Debt.Dilution__c = 5;
            Debt.Max_Credit_Period__c = 60;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
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
            Invoice.akritiv__Account__c = AccountList[0].id;
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
        update debtorList;
        
        Case Cas = new Case();
        Cas.Client_Account__c = ClientAccountList[0].id;
        Cas.Status = 'Fully Funded';
        Cas.Funding_Requested__c = 400;
        Cas.Origin = 'Web';
        Cas.Wire_Mode__c=True;
       
        insert Cas;
        Funding_Transaction__c FT = new Funding_Transaction__c();
        FT.Funding_Request__c = Cas.id;
        FT.Funding_Provider__c = CP.Id;
     //   FT.Deal_Acceptance_Date__c = system.now();
     //   FT.Funding_Transaction_Date__c = system.now();
        
  /*      FT.Drawal_Fee_Percentage__c = 10;
        FT.Minimum_Drawal_fee__c = 1000;
        FT.Origination_Fee_Percentage__c = 5;
        FT.Minimum_origination_fee__c = 6000;*/
        Insert FT; 
       delete FT;
    }
 
    
   }