@isTest
public class TestCashAppUtitlityController {
	static testmethod void Unittest1()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 2 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(2, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Amount__c = 800;
        Payment.Applied_Amount_calc__c = 10;
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Transaction_Code__c='Credit note';
        insert Payment;
        
        map<id,double> AppliedTXMap = new map<id,double>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            AppliedTXMap.put(INV.id, 10.0);
        }
        map<id,double> ClientAccount_Map = new map<id,double>();
        for(Client_Account__c CA : ClientAccountList)
        {
            ClientAccount_Map.put(CA.id, 10.0);
        }
        map<id,Date> TransactionDateMap = new map<id,Date>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            TransactionDateMap.put(null, Date.today());
        }
        akritiv__Payment__c pmnt = [Select id,Name,Unapplied_Balance_Calc__c,Debtor__c,Client_Account__c,akritiv__Account__c,akritiv__Payment_Date__c,akritiv__Amount__c,Applied_Amount_calc__c,akritiv__Payment_Type__c from akritiv__Payment__c where id =: payment.id limit 1];
        Client_Account__c CA = [Select id,name,Client__c,Product__c,Funding_Limit__c,Commitment__c,Commitment_rate__c,Index__c,Method__c,Rate_Type__c,Spread__c,Rate__c,Index_Value__c,Borrowing_Base_Reserve__c,
                                Minimum_Drawal_Fee__c,Minimum_Origination_Fee__c,Origination_Fee_Percentage__c,Drawal_Fee_Percentage__c,Client__r.CounterParty__c From Client_Account__c where id =: ClientAccountList[0].id limit 1];
      
        test.startTest(); 
        CashAppUtitlityController.ApplyCash_new(debtorList[0], pmnt, Invoicelist, AppliedTXMap, 'Test Comment', TransactionDateMap);
       // CashAppUtitlityController.WriteOffTransaction_New(debtorList[0],Invoicelist, 'writeoff', AppliedTXMap);
	   // CashAppUtitlityController.WriteOffClientaccountFIU( CA, ClientAccountList, 'writeoff', ClientAccount_Map);
        test.stopTest();
    }
    static Testmethod void unittest2()
    {
         List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 2 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(2, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Amount__c = 800;
        Payment.Applied_Amount_calc__c = 10;
        payment.akritiv__Payment_Type__c = 'Manual';
        insert Payment;
        
        map<id,double> AppliedTXMap = new map<id,double>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            AppliedTXMap.put(INV.id, 10.0);
        }
        map<id,double> ClientAccount_Map = new map<id,double>();
        for(Client_Account__c CA : ClientAccountList)
        {
            ClientAccount_Map.put(CA.id, 10.0);
        }
        map<id,Date> TransactionDateMap = new map<id,Date>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            TransactionDateMap.put(INV.id, Date.today());
        }
        akritiv__Payment__c pmnt = [Select id,Name,Unapplied_Balance_Calc__c,Debtor__c,Client_Account__c,akritiv__Account__c,akritiv__Payment_Date__c,akritiv__Amount__c,Applied_Amount_calc__c,akritiv__Payment_Type__c from akritiv__Payment__c where id =: payment.id limit 1];
        Client_Account__c CA = [Select id,name,Client__c,Product__c,Funding_Limit__c,Commitment__c,Commitment_rate__c,Index__c,Method__c,Rate_Type__c,Spread__c,Rate__c,Index_Value__c,Borrowing_Base_Reserve__c,
                                Minimum_Drawal_Fee__c,Minimum_Origination_Fee__c,Origination_Fee_Percentage__c,Drawal_Fee_Percentage__c,Client__r.CounterParty__c From Client_Account__c where id =: ClientAccountList[0].id limit 1];
      
        test.startTest(); 
		 CashAppUtitlityController.WriteOffTransaction_New(debtorList[0],Invoicelist, 'writeoff', AppliedTXMap);
        test.stopTest();
    }
    static Testmethod void Unittest3()
    {
         List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 2 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(2, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Amount__c = 800;
        Payment.Applied_Amount_calc__c = 10;
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Transaction_Code__c='Credit note';
        insert Payment;
        
        map<id,double> AppliedTXMap = new map<id,double>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            AppliedTXMap.put(INV.id, 10.0);
        }
        map<id,double> ClientAccount_Map = new map<id,double>();
        for(Client_Account__c CA : ClientAccountList)
        {
            ClientAccount_Map.put(CA.id, 10.0);
        }
        map<id,Date> TransactionDateMap = new map<id,Date>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            TransactionDateMap.put(INV.id, Date.today());
        }
        akritiv__Payment__c pmnt = [Select id,Name,Unapplied_Balance_Calc__c,Debtor__c,Client_Account__c,akritiv__Account__c,akritiv__Payment_Date__c,akritiv__Amount__c,Applied_Amount_calc__c,akritiv__Payment_Type__c from akritiv__Payment__c where id =: payment.id limit 1];
        Client_Account__c CA = [Select id,name,Client__c,Product__c,Funding_Limit__c,Commitment__c,Commitment_rate__c,Index__c,Method__c,Rate_Type__c,Spread__c,Rate__c,Index_Value__c,Borrowing_Base_Reserve__c,
                                Minimum_Drawal_Fee__c,Minimum_Origination_Fee__c,Origination_Fee_Percentage__c,Drawal_Fee_Percentage__c,Client__r.CounterParty__c From Client_Account__c where id =: ClientAccountList[0].id limit 1];
      
        test.startTest(); 
	   	 CashAppUtitlityController.WriteOffClientaccountFIU( CA, ClientAccountList, 'writeoff', ClientAccount_Map);
        test.stopTest();
    }
    
    static testmethod void Unittest11()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 2 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(2, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Amount__c = 800;
        Payment.Applied_Amount_calc__c = 10;
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Transaction_Code__c='Credit note';
        payment.akritiv__Amount__c =100;
        payment.Applied_Amount_calc__c=10;
        insert Payment;
        
        map<id,double> AppliedTXMap = new map<id,double>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            AppliedTXMap.put(INV.id, 100.0);
        }
        map<id,double> ClientAccount_Map = new map<id,double>();
        for(Client_Account__c CA : ClientAccountList)
        {
            ClientAccount_Map.put(CA.id, 10.0);
        }
        map<id,Date> TransactionDateMap = new map<id,Date>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            TransactionDateMap.put(INV.id, null);
        }
        akritiv__Payment__c pmnt = [Select id,Name,Unapplied_Balance_Calc__c,Debtor__c,Client_Account__c,akritiv__Account__c,akritiv__Payment_Date__c,akritiv__Amount__c,Applied_Amount_calc__c,akritiv__Payment_Type__c from akritiv__Payment__c where id =: payment.id limit 1];
        Client_Account__c CA = [Select id,name,Client__c,Product__c,Funding_Limit__c,Commitment__c,Commitment_rate__c,Index__c,Method__c,Rate_Type__c,Spread__c,Rate__c,Index_Value__c,Borrowing_Base_Reserve__c,
                                Minimum_Drawal_Fee__c,Minimum_Origination_Fee__c,Origination_Fee_Percentage__c,Drawal_Fee_Percentage__c,Client__r.CounterParty__c From Client_Account__c where id =: ClientAccountList[0].id limit 1];
      
        test.startTest(); 
        CashAppUtitlityController.ApplyCash_new(debtorList[0], pmnt, Invoicelist, AppliedTXMap, 'Test Comment', TransactionDateMap);
       // CashAppUtitlityController.WriteOffTransaction_New(debtorList[0],Invoicelist, 'writeoff', AppliedTXMap);
	   // CashAppUtitlityController.WriteOffClientaccountFIU( CA, ClientAccountList, 'writeoff', ClientAccount_Map);
        test.stopTest();
    }
 static testmethod void Unittest22()
    {
        List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 2 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '12345678'+i;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(2, AccountList.size());
        Product__c Product = new Product__c(Name = 'LOC');
        insert Product;
        List<akritiv__Brand__C> Clientlist = new List<akritiv__Brand__c>();
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Amount__c = 800;
        Payment.Applied_Amount_calc__c = 10;
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Transaction_Code__c='Credit note';
        payment.akritiv__Amount__c =100;
        payment.Applied_Amount_calc__c=10;
       
        insert Payment;
        
        map<id,double> AppliedTXMap = new map<id,double>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            AppliedTXMap.put(INV.id, 100.0);
        }
        map<id,double> ClientAccount_Map = new map<id,double>();
        for(Client_Account__c CA : ClientAccountList)
        {
            ClientAccount_Map.put(CA.id, 10.0);
        }
        map<id,Date> TransactionDateMap = new map<id,Date>();
        for(akritiv__Transaction__c INV : Invoicelist)
        {
            TransactionDateMap.put(INV.id, date.today());
        }
        akritiv__Payment__c pmnt = [Select id,Name,Unapplied_Balance_Calc__c,Debtor__c,Client_Account__c,akritiv__Account__c,akritiv__Payment_Date__c,akritiv__Amount__c,Applied_Amount_calc__c,akritiv__Payment_Type__c,Transaction_Code__c from akritiv__Payment__c where id =: payment.id limit 1];
        Client_Account__c CA = [Select id,name,Client__c,Product__c,Funding_Limit__c,Commitment__c,Commitment_rate__c,Index__c,Method__c,Rate_Type__c,Spread__c,Rate__c,Index_Value__c,Borrowing_Base_Reserve__c,
                                Minimum_Drawal_Fee__c,Minimum_Origination_Fee__c,Origination_Fee_Percentage__c,Drawal_Fee_Percentage__c,Client__r.CounterParty__c From Client_Account__c where id =: ClientAccountList[0].id limit 1];
      
        test.startTest(); 
        CashAppUtitlityController.ApplyCash_new(debtorList[0], pmnt, Invoicelist, AppliedTXMap, 'Test Comment', TransactionDateMap);
       // CashAppUtitlityController.WriteOffTransaction_New(debtorList[0],Invoicelist, 'writeoff', AppliedTXMap);
	   // CashAppUtitlityController.WriteOffClientaccountFIU( CA, ClientAccountList, 'writeoff', ClientAccount_Map);
        test.stopTest();
    }

}