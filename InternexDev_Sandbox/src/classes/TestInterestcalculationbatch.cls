@isTest
public class TestInterestcalculationbatch {
	static testmethod void Interestcalculationbatchtest()
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
        for(integer i = 0 ;i < 1; i++)
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
            }
               
            CA.Spread__c = 5;
            CA.Rate__c = 10;
            CA.Index_Value__c = 0;
            CA.Borrowing_Base_Reserve__c = 0;
       //     CA.Borrowing_Base_Reserve__c = 0;
            CA.Minimum_Drawal_Fee__c = 100;
            CA.Minimum_Origination_Fee__c = 100;
            CA.Drawal_Fee_Percentage__c = 8;
            CA.Origination_Fee_Percentage__c = 6;
            
          /*  CA.Non_performing_asset__c=True;
            CA.Commitment__c=10;
            CA.Commitment_rate__c=20;
            CA.Funding_Limit__c=100;
            CA.Sum_of_Received_funds__c=100;
            CA.Payments__c = 20;
            CA.Gross_Availability__c=500;
            CA.Ineligibles_Amount__c=10;
            CA.Eligible_For_Funding__c=1000;
            CA.Funding_Limit__c=400;
            CA.Borrowing_Base_Reserve__c=10;
            CA.Interest_Initiation_Date__c=date.today();
            CA.IUF_Reserve_Amount__c=500; */
            ClientAccountList.add(CA);
        }
        insert ClientAccountList;
        
      /*  IUF__c IUF = new IUF__c();
        IUF.Client_Account__c = ClientAccountList[0].id;
        IUF.IUF_Retained__c = 20;
        IUF.IUF_used__c = 50;
        IUF.Type__c='Manual';
        IUF.Interest_Due_Recovered__c=10;
        IUF.UL_Fee_Due_Recovered__c=10;
        
        insert IUF; */
        
        
        List<Debtor__c> debtorList = new List<Debtor__c>();
        for(integer i = 0 ;i < 1; i++)
        {
            Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = ClientAccountList[0].id;
            Debt.Counterparty__c = AccountList[1].id;
            Debt.Dilution__c = 5;
            Debt.Max_Credit_Period__c = 60;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 0;
            Debt.Debtor_Status__c = 'Eligible';
            
           /* Debt.Sum_of_Payments__c=50;
            Debt.Invoice_Amount__c=100; */
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
          Test.startTest();
        /*	Schedule_Interest_calculationBatch SCI = new Schedule_Interest_calculationBatch();
        	String str = '0 0 0 * * ?';
         system.schedule('TestJob', str, SCI);
        Batchesexecution BE = new Batchesexecution();
		BE.InterestCalculation(); 
        Test.stopTest(); */
        SchedulableContext ctx;
        Schedule_Interest_calculationBatch IB = new Schedule_Interest_calculationBatch();
        IB.execute(ctx);
        Test.stopTest(); 
    }
   }