@isTest
public class TestClientbatch_Akrtiv_to_Grade_portal {
    static testmethod void Clientbatch_Akrtiv_to_Grade_portalTest()
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
            Client.QB_AccessTokenSecret__c = 'AccessTokenSecret123456743r5';
            Client.QB_ConsumerKey__c = 'ConsumerKey123456780912';
            Client.QB_OauthToken__c = 'OauthToken1234567435';
            Client.QB_ConsumerSecret__c = '1234567891234567';
            Client.QB_Realm__c = '12342353';
            client.Portal_External_Id__c = '123p'+i;
            Client.Sync_with_Grade__c = false;
            Client.Sync_with_Portal__c = false;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Origination_Fee_Percentage__c = 1;
            CA.Drawal_Fee_Percentage__c = 1;
            CA.Sync_with_Grade__c = False;
            Ca.Sync_with_Portal__c = False;
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
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
            Debt.Debtor_Status__c = 'Eligible';
            Debt.Sync_with_Portal__c=False;
           
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
            Invoice.akritiv__Account__c = AccountList[1].id;
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
        
        List<Case> Caselist = new List<Case>();
        for(integer j = 0 ; j<3;j++)
        {
            Case cas = new Case();
            Cas.Client_Account__c = ClientAccountList[0].id;
            Cas.Funding_Requested__c = 400;
            cas.Deal_Acceptance_Date__c = date.today();
            if(j == 0)
            Cas.Status = 'UNALLOCATED';
            else if(j == 1)
               Cas.Status = 'REJECTED'; 
            else
               Cas.Status = 'FUNDS TRANSFERRED'; 
            Cas.Sync_with_Market_Place__c = false;
            Cas.Sync_with_Portal__c = false;
            Caselist.add(Cas);
        }
        insert Caselist;
        Test.startTest();
        
   /*     Clientbatch_Akrtiv_to_Grade_portal AGB = new Clientbatch_Akrtiv_to_Grade_portal();
         Database.executeBatch(AGB, 3);
        */
        Consolidated_GL_Report SIC = new Consolidated_GL_Report();
         Database.executeBatch(SIC, 1);
        
        InvoiceAgingCalculations DBA = new InvoiceAgingCalculations();
         Database.executeBatch(DBA, 1); 
        
        QBCustomerandInvoiceBatch QBC = new QBCustomerandInvoiceBatch();
         Database.executeBatch(QBC, 3); 
        
  /*      string str = '00 00 12 * * ?';
        client_scheduler Cs = new client_scheduler();
        system.schedule('testClient',str, Cs);
        ClientAccount_scheduler CAS = new ClientAccount_scheduler();
        system.schedule('testClientAccount', str, CAS);
        DrawRequest_scheduler DRS = new DrawRequest_scheduler();
        system.schedule('testDrawRequest', str, DRS);
        */
        Test.stopTest();
    }
    static Testmethod void Clientbatch_Akrtiv_to_Grade_portalTest2()
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
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Client.Sync_with_Grade__c = false;
            Client.Sync_with_Portal__c = false;
            Client.QB_AccessTokenSecret__c = 'AccessTokenSecret123456743r5';
            Client.QB_ConsumerKey__c = 'ConsumerKey123456780912';
            Client.QB_OauthToken__c = 'OauthToken1234567435';
            Client.QB_ConsumerSecret__c = '1234567891234567';
            Client.QB_Realm__c = '12342353';
            client.Portal_External_Id__c = '123p'+i;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Origination_Fee_Percentage__c = 1;
            CA.Drawal_Fee_Percentage__c = 1;
            CA.Sync_with_Grade__c = False;
            Ca.Sync_with_Portal__c = False;
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
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
            Debt.Debtor_Status__c = 'Pending';
            Debt.External_Id__c = 'GR12';
            Debt.Portal_External_Id__c = 'pr12';
            debtorList.add(Debt);
        }
        insert debtorList;
        
        DBA_Name__c DBA = new DBA_Name__c();
        DBA.Name = 'TESTDBA';
        DBA.Debtor__c = debtorList[0].id;
        insert DBA;
        
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
        
        List<Case> Caselist = new List<Case>();
        for(integer j = 0 ; j<1;j++)
        {
            Case cas = new Case();
            Cas.Client_Account__c = ClientAccountList[0].id;
            Cas.Funding_Requested__c = 400;
            cas.Deal_Acceptance_Date__c = date.today();
            if(j == 0)
               Cas.Status = 'FUNDS TRANSFERRED'; 
            Cas.Sync_with_Market_Place__c = false;
            Cas.Sync_with_Portal__c = false;
            Caselist.add(Cas);
        }
        insert Caselist;
        
        Capital_Provider__c CP = New Capital_Provider__c(Name = 'BOI');
        insert CP;
        
        Funding_Transaction__c FT = new Funding_Transaction__c();
    //    FT.Deal_Acceptance_Date__c = Date.today();
        FT.Discount_Interest_Rate__c = 8;
   /*     FT.Drawal_Fee_Percentage__c = 6;
        FT.Minimum_Drawal_fee__c = 800; */
    /*    FT.Origination_Fee_Percentage__c = 7;
        FT.Minimum_origination_fee__c = 900;*/
        FT.Funding_Provider__c = CP.Id;
        FT.Funding_Request__c = Caselist[0].id;
       // FT.Funding_Transaction_Date__c = system.now();
 
        insert FT;
  /*      
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
        insert Invoicelist;*/
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Payment_Type__c = 'Manual';
        Payment.akritiv__Amount__c = 800;
        insert Payment;
        
        TPSSF__ConnectorSettings__c TC = new TPSSF__ConnectorSettings__c();
        TC.Name = 'ClientId';
        TC.TPSSF__value__c = 'ClientId';
        insert TC;
        
        Test.startTest();
        string str = '00 00 12 * * ?';
        client_scheduler Cs = new client_scheduler();
        system.schedule('testClient2',str, Cs);
        ClientAccount_scheduler CAS = new ClientAccount_scheduler();
        system.schedule('testClientAccount2', str, CAS);
        DrawRequest_scheduler DRS = new DrawRequest_scheduler();
        system.schedule('testDrawRequest2', str, DRS);
        PaymentsandFundingAllocation_Scheduler PFA = new PaymentsandFundingAllocation_Scheduler();
         system.schedule('testTop5paymentsandfundingallowcations2', str, PFA);
        Payments_Scheduler PB = new Payments_Scheduler();
         system.schedule('payment to portal2', str, PB);
        InvoiceBatch_scheduler IBS = new InvoiceBatch_scheduler();
         system.schedule('Invoice12', str, IBS);
        SendBusinessTransactionDate_scheduler SBTD = new SendBusinessTransactionDate_scheduler();
         system.schedule('Send Business Transaction2', str, SBTD);
        QuickbooksScheduler QB = new QuickbooksScheduler();
         system.schedule('QuickBooks2', str, QB);
        DBAName_Scheduler DBA_sche = new DBAName_Scheduler();
         system.schedule('DBA2', str, DBA_sche); 
         
        test.stopTest();
    }
    static Testmethod void Clientbatch_Akrtiv_to_Grade_portalTest3()
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
        for(integer i = 0 ;i < 1 ; i++)
        {
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = AccountList[i].id;
            Client.Name = AccountList[i].Name;
            Client.Sync_with_Grade__c = false;
            Client.Sync_with_Portal__c = false;
            Client.QB_AccessTokenSecret__c = 'AccessTokenSecret123456743r5';
            Client.QB_ConsumerKey__c = 'ConsumerKey123456780912';
            Client.QB_OauthToken__c = 'OauthToken1234567435';
            Client.QB_ConsumerSecret__c = '1234567891234567';
            Client.QB_Realm__c = '12342353';
            client.Portal_External_Id__c = '123p'+i;
            Clientlist.add(Client);
        }
        insert Clientlist;
        List<Client_Account__c> ClientAccountList = new List<Client_Account__c>();
        for(integer i = 0 ;i < 1; i++)
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
            CA.Origination_Fee_Percentage__c = 1;
            CA.Drawal_Fee_Percentage__c = 1;
            CA.Sync_with_Grade__c = False;
            Ca.Sync_with_Portal__c = False;
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
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
            Debt.Debtor_Status__c = 'Eligible';
            Debt.Sync_with_Portal__c=False;
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
        
        List<Case> Caselist = new List<Case>();
        for(integer j = 0 ; j<1;j++)
        {
            Case cas = new Case();
            Cas.Client_Account__c = ClientAccountList[0].id;
            Cas.Funding_Requested__c = 400;
            cas.Deal_Acceptance_Date__c = date.today();
            if(j == 0)
               Cas.Status = 'FUNDS TRANSFERRED'; 
            Cas.Sync_with_Market_Place__c = false;
            Cas.Sync_with_Portal__c = false;
            Caselist.add(Cas);
        }
        insert Caselist;
        
        Capital_Provider__c CP = New Capital_Provider__c(Name = 'BOI');
        insert CP;
        
        Funding_Transaction__c FT = new Funding_Transaction__c();
    //    FT.Deal_Acceptance_Date__c = Date.today();
        FT.Discount_Interest_Rate__c = 8;
   /*     FT.Drawal_Fee_Percentage__c = 6;
        FT.Minimum_Drawal_fee__c = 800; */
    /*    FT.Origination_Fee_Percentage__c = 7;
        FT.Minimum_origination_fee__c = 900;*/
        FT.Funding_Provider__c = CP.Id;
        FT.Funding_Request__c = Caselist[0].id;
    //    FT.Funding_Transaction_Date__c = system.now();
 
        insert FT;
  /*      
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
        insert Invoicelist;*/
        akritiv__Payment__c Payment = new akritiv__Payment__c();
        Payment.Name = 'TestPayment';
        payment.Debtor__c = debtorList[0].Id;
        payment.Client_Account__c = ClientAccountList[0].id;
        payment.akritiv__Account__c = AccountList[1].id;
        payment.akritiv__Payment_Date__c = Date.today();
        Payment.akritiv__Payment_Type__c = 'Manual';
        Payment.akritiv__Amount__c = 800;
        insert Payment;
        
        TPSSF__ConnectorSettings__c TC = new TPSSF__ConnectorSettings__c();
        TC.Name = 'ClientId';
        TC.TPSSF__value__c = 'ClientId';
        insert TC;
        
        Test.startTest();
        string str = '00 00 12 * * ?';
        client_scheduler Cs = new client_scheduler();
        system.schedule('testClient3',str, Cs);
        ClientAccount_scheduler CAS = new ClientAccount_scheduler();
        system.schedule('testClientAccount3', str, CAS);
        DrawRequest_scheduler DRS = new DrawRequest_scheduler();
        system.schedule('testDrawRequest3', str, DRS);
        PaymentsandFundingAllocation_Scheduler PFA = new PaymentsandFundingAllocation_Scheduler();
         system.schedule('testTop5paymentsandfundingallowcations3', str, PFA);
        Payments_Scheduler PB = new Payments_Scheduler();
         system.schedule('payment to portal3', str, PB);
        InvoiceBatch_scheduler IBS = new InvoiceBatch_scheduler();
         system.schedule('Invoice13', str, IBS);
        SendBusinessTransactionDate_scheduler SBTD = new SendBusinessTransactionDate_scheduler();
         system.schedule('Send Business Transaction3', str, SBTD);
        QuickbooksScheduler QB = new QuickbooksScheduler();
         system.schedule('QuickBooks3', str, QB);
        test.stopTest();
    }
}