@istest
public class testdoCallout
{
    static testmethod void callout()
    {
        Account Acc = new Account();
            Acc.Name ='abc';
            Acc.AccountNumber = '00qsw';
            Acc.akritiv__Account_Key__c = 'key001' ;
            Acc.Funding_Limit__c = 100000;
            Acc.Email__c = 'abc@gmail.com';
            Acc.PAN_TAN__c = '123456789';
            ACC.BillingState = 'NY';
            ACC.BillingPostalCode = '99999';
            Acc.Funding_Limit__c = 100000;
           insert Acc;
        
         Account Acc1 = new Account();
            Acc1.Name ='abcd';
            Acc1.AccountNumber = '00qswdd';
            Acc1.akritiv__Account_Key__c = 'key0011' ;
            Acc1.Funding_Limit__c = 200000;
            Acc1.Email__c = 'abdc@gmail.com';
            Acc1.PAN_TAN__c = '123456789';
            Acc1.BillingState = 'NY';
            Acc1.BillingPostalCode = '89999';
            Acc1.Funding_Limit__c = 200000;
           insert Acc1; 
        
        akritiv__Brand__C Client = new akritiv__Brand__C();
          Client.CounterParty__c = Acc.Id;
          Client.Name = Acc.Name;
          Client.External_Foreign_Key__c='ee4';
          Client.Portal_External_Id__c='rr4';
          Client.MP_External_Id__c='rrr';
          Client.Sync_with_Grade__c=False;
          Client.Sync_with_Market_Place__c=False;
          Client.Sync_with_Portal__c=False;
         Client.Business_Transaction_Date__c=date.today();
         Client.Active__c=true;
         Client.Funding_Limit__c=50;
        Client.City__c='abc';
        Client.Company_Code__c='compcode1';
        Client.Remit_ABA__c='aba';
        Client.Remit_Account__c='remitacc1';
        Client.Remit_Address__c='fdgg';
        Client.Remit_Bank__c='bank';
        Client.Remit_Email__c='abv@dff.com';
        Client.Remit_Name__c='remit';
        Client.Remit_PO_Box__c='po1box';
        Client.Remit_Zip__c='zip1';
        Client.State__c='state1';
        Client.ZIP_Code__c='201013';
        
        
        
          insert Client;
        
        Product__c Product = new Product__c();
          Product.Name = 'LOC';
          insert Product;
        
        Client_Account__c CA = new Client_Account__c();
            CA.Client__c = Client.Id;
            CA.Product__c = Product.Id;
            CA.CurrencyIsoCode='USD';
            CA.External_Id__c='re4';
            CA.External_Req_Id__c='556tt';
            CA.Portal_External_Id__c='hjgh4';
            CA.MP_External_Id__c='sss3';
            CA.Sync_with_Grade__c=true;
            CA.Sync_with_Market_Place__c=true;
            CA.Sync_with_Portal__c=true;
            CA.Source__c='abc';
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
            CA.Ineligibles_Amount__c=100;
           CA.Sum_of_Received_funds__c=100;
           CA.Payments__c=10;
          insert CA;
        
        
        
          Debtor__c Debt = new Debtor__c();
            Debt.Client_Account__c = CA.Id;
            Debt.Counterparty__c = Acc1.Id;
            Debt.Dilution__c = 5;
            Debt.Funding_Limit__c = 50000;
            Debt.Concentration_Limit__c = 50;
            Debt.Eligible_AR__c = 1000;
            Debt.Borrowing_Base_Reserve__c = 0;
            Debt.Max_Credit_Period__c = 90;
            Debt.Debtor_Status__c = 'Eligible';
            Debt.Invoice_Amount__c=100;
            Debt.Sum_of_Payments__c=50;
            insert Debt;
        
        set<Id> setAccId = new Set<ID>();
        setAccId.add(Client.id);
        
        Test.startTest();
            doCallout_toupdate_in_portal.doCallout_toupdatetheClient_in_portal(setAccId);
        Test.stopTest();


        

    }

}