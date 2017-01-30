@isTest
public class TestInterestcalculation {
	Static testmethod void interestcalculationtest()
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
        Pricing__c price = new Pricing__c(Date__c = Date.today(),Index__c = 'WS Prime',Rate__c = 2);
        insert price;
        
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
            if(i==0)
            {
                CA.Index__c = 'WS Prime';
                CA.Method__c = '360/Actual';
                CA.Rate_Type__c = 'Fixed';
            }
            else
            {
                CA.Index__c = 'WS Prime';
                CA.Method__c = '360/Actual';
                CA.Rate_Type__c = 'Floating';
                CA.Interest_Due__c = 10;
                CA.UL_Fee_Due__c = 10;
                CA.Interest_Due_Since__c = Date.today();
                CA.UL_Fee_Due_Since__c = Date.today();
            }
               
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            CA.IUF_Reserve_Retained__c = 10;
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
        Interestcalculation IC = new Interestcalculation();
        IC.interest_calculationFunctionality(ClientAccountList);
        
        Monthly_Interest_Application__c MI = new Monthly_Interest_Application__c();
        MI.Client_Account__c = ClientAccountList[2].id;
        MI.Date__c = Date.today();
        Insert MI;
        
        Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
        Di.Monthly_Interest_Application__c = MI.ID;
        DI.Date__c = Date.today();
        Insert DI;
	
        IUF__c IUF = new IUF__C();
        IUF.Client_Account__c = ClientAccountList[2].id;
        IUF.Date__c = Date.today();
        IUF.Payment_Line_Item__c = DI.ID;
        IUF.IUF_Retained__c = 0;
        IUF.IUF_used__c = 0;
        insert IUF;

        IC.interest_calculationFunctionality(ClientAccountList);
        Delete DI;
        
        Integer totalDays = Date.daysInMonth(Date.today().year(), Date.today().month());
		Date lastDay = Date.newInstance(Date.today().year(), Date.today().month(), totalDays);
       
        Daily_Interest_Accrual__c DI1 = new Daily_Interest_Accrual__c();
        Di1.Monthly_Interest_Application__c = MI.ID;
        DI1.Date__c = lastDay;
        DI1.Business_Transaction_Date__c = lastDay;
        DI1.FIU_Outstanding__c = 100;
        DI1.Interest_Base__c = 'WS Prime';
        DI1.Method__c = 'ACTUAL / 360';
        DI1.Non_performing_asset__c = false;
        DI1.Interest_Base_Rate__c = 1;
        DI1.Commitment__c =  1;
        DI1.Commitment_rate__c = 1;
        DI1.Funding_Limit__c = 10000;
        DI1.Interest_Spread__c = 0;
        DI1.MinCommitmentAmount__c = 1000;
        DI1.Invoice_Amount__c = 1500;
        DI1.Ineligibles_Amount__c = 0;
        DI1.Eligible_For_Funding__c = 1500;
        DI1.Gross_Availability__c = 800;
        DI1.Net_Availability__c = 790;
        Insert DI1;
        
        IUF__c IUF1 = new IUF__C();
        IUF1.Client_Account__c = ClientAccountList[2].id;
        IUF1.Date__c = Date.today();
	    IUF1.Interest_Due_Recovered__c = 10;
        IUF1.UL_Fee_Due_Recovered__c = 10;
        insert IUF1;
        
      /*  Test.startTest();
        	Schedule_Interest_calculationBatch SCI = new Schedule_Interest_calculationBatch();
        	String str = '0 0 0 * * ?';
         system.schedule('TestJob', str, SCI); 
         Test.startTest();
        Batchesexecution BE = new Batchesexecution();
		BE.InterestCalculation(); 
        Test.stopTest(); */ 
        
    }
    }