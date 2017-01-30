@istest
public class TestClientSaveAndNew
{
  
   static testmethod void ClientSaveAndNew()
   {
       
            Account Acc = new Account();
            Acc.Name = 'AccountABC';
            Acc.AccountNumber = 'Account Number';
            Acc.akritiv__Account_Key__c = 'ACCKEY' ;
            Acc.Funding_Limit__c = 200000;
            Acc.Email__c = 'TestAcc@testing.com';
            Acc.PAN_TAN__c = '123456789';
            Acc.BillingState = 'IN';
            ACC.BillingPostalCode = '39999';
           insert ACC;
       
       
       
            akritiv__Brand__C Client = new akritiv__Brand__C();
            Client.CounterParty__c = ACC.Id;
            Client.Name = ACC.Name;
          
            Client.Sync_with_Grade__c = false;
            Client.Sync_with_Portal__c = false;
             Client.External_Foreign_Key__c='334rr';
            Client.MP_External_Id__c='rrt5';
            Client.Sync_with_Market_Place__c=True;
            Client.Business_Transaction_Date__c=date.today();
           
            Client.Active__c=True;
            Client.Funding_Limit__c=299;
            Client.City__c='delhi';
            Client.Company_Code__c='ggg';
            Client.Country__c='India';
            Client.Remit_ABA__c='adf';
            Client.Remit_Account__c='ggjj';
            Client.Remit_Address__c='hhjkkl';
            Client.Remit_Bank__c='hhh';
            Client.Remit_Email__c='ankima.g@gmail.com';
            Client.Remit_Name__c='ytrew';
            Client.Remit_PO_Box__c='567yt';
            Client.Remit_Zip__c='ytt555';
            Client.State__c='tttyyy';
            Client.ZIP_Code__c='5656q';
            Client.Application_Number__c='67667ffg';
            Client.Application_Name__c='yyy';
            Client.Referal_Source__c='tyy';
            client.Account__c='hhhhdd';
            client.External_Id__c='yuuh3334';
       insert Client;
    Apexpages.Standardcontroller stdvice = new Apexpages.Standardcontroller(Client);
ClientSaveAndNew classobj= new ClientSaveAndNew (stdvice);
  
  classobj.saveAndNew();
   }
}