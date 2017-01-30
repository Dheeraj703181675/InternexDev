@isTest
public class QuickBookMappingTest {
    Static Testmethod void QuickBookMapping_method1()
    {
		List<Account> AccountList = new List<Account>();
        for(integer i = 0 ;i < 3 ; i++)
        {
            Account Acc = new Account();
            Acc.Name = 'TestAccount'+i;
            Acc.AccountNumber = 'Account No' + i;
            Acc.akritiv__Account_Key__c = 'ACCKEY'+ i ;
            Acc.Email__c = 'Test'+i+'@testing.com';
            Acc.PAN_TAN__c = '123201689';
            Acc.Funding_Limit__c = 100000;
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            AccountList.add(ACC);
        }
        insert AccountList;
        system.assertEquals(3, AccountList.size());
        
        Contact con = new Contact();
        Con.LastName = 'Tester';
        Con.AccountId = AccountList[1].id;
        con.Primary_Contact__c = True;
        Con.Phone = '3254325445';
        con.Email = 'Test@Testing.com';
        insert con;
        
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
            Debt.Client_Account__c = ClientAccountList[i].id;
            Debt.Counterparty__c = AccountList[1-i].id;
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
        
        List<QB_Customer__c> QBC_List = new List<QB_Customer__c>();
        for(integer i=0;i<10;i++)
        {
			QB_Customer__c QBC = new QB_Customer__c();
       //     QBC.QuickBook_ID__c = '123';
			QBC.Active__c = True;
			QBC.Balance__c = 1000;
			QBC.DisplayName__c = 'Tester'+i;
			QBC.FullyQualifiedName__c = 'Tester'+i;
            QBC.Primary_Email__c = 'Test@Testing.com';
            QBC.Primary_Phone_Number__c = '3254325445';
            QBC.QB_CreateTime__c = DateTime.now();
            QBC.QB_LastUpdatedTime__c = DateTime.now();
            QBC.QuickBook_ID__c = String.valueof(Date.today())+i;
            QBC.SyncToken__c = '1';
            QBC.Client_ID__c = Clientlist[0].id;
            QBC_List.add(QBC);
        }
        insert QBC_List;
        system.assert(QBC_List.size() == 10);
        
        QB_Invoice__c QIn = new QB_Invoice__c();
        QIn.Balance__c = 100;
        QIn.DueDate__c = date.today();
		QIn.CustomerRef__c =  String.valueof(Date.today())+'0';
        QIn.Client_Id__c = Clientlist[0].id;
        insert QIn;

        QuickBookMapping QBM = new QuickBookMapping();
        QBM.Client.Client__C = Clientlist[0].id;
        QBM.SearchCustomers();
		QBM.FillDebtor();
		QBM.CustomerwrapList[0].check = True;
  //      QBM.CustomerwrapList[0].QBC.Debtor__c = debtorList[0].id;
        QBM.ApplyCustomers();
        QBM.last();
        QBM.first();
        QBM.next();
        QBM.previous();
        Boolean b = QBM.hasNext;
        Boolean C = QBM.hasPrevious;
        Integer i = QBM.pageNumber;
        QBM.limits = '10';
        QBM.changeLimit();
        QBM.SendtoPortal();
    }
}