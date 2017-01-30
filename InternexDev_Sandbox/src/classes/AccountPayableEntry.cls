public with sharing class AccountPayableEntry {

    public PageReference deb_Save() {
        try{
           list<debtor__c> DebtorUpdate_list = new list<Debtor__c>();
           for(Debtorwrap DW: Debtorwraplist)
           {
                if(DW.check == True)
                {
                    DebtorUpdate_list.add(DW.Debtor);
                }           
           }
           Update DebtorUpdate_list;
           DebtorUpdate_list.clear();
           search();
        }
        catch(Exception e){
        system.debug('Exception --> '+ e);
        apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,String.valueof(e.getMessage())));}
        return null;
    }


    public PageReference CA_Save() {
          try{
            update CA;
        }
        catch(Exception e){
        system.debug('Exception --> '+ e);
        apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,String.valueof(e.getMessage())));}
        return null;
    }


public boolean showSection { get; set; }
Public akritiv__Transaction__c Invoice{ get; set; }
Public client_account__C CA{ get; set; }
Public List<Debtorwrap> Debtorwraplist { get; set; }

    public AccountPayableEntry()
    {
         CA = new client_account__C();
         Invoice = new akritiv__Transaction__c();
         showSection = false;
         Debtorwraplist = new List<Debtorwrap>();
    }

    public PageReference search() {
        system.debug('Client-Account -> '+ Invoice.Client_Acc__c);
    
        if(Invoice.Client_Acc__c != NULL)
        {
                CA = [Select id,Name,Status__c,Client_Account__c,Client__c,Product__c,AP_Current__c,AP_31_60__c,AP_1_15__c,AP_61_90__c,AP_16_30__c,AP_90__c from client_account__C where Id =: Invoice.Client_Acc__c];
                showSection = true;
                List<DebtorWrap> list_Debtorwrap = new List<DebtorWrap>();
                integer count = 0;
                for(Debtor__c deb: [Select id,Name,Contra_Balance__c,Client_Account__c,Client_Product_Counterparty__c,Net_Availability__c,Debtor_Net_Eligible_AR__c,Debtor_Adjusted_AR__c from Debtor__c where Client_Account__c =: Invoice.Client_Acc__c])
                {
                    DebtorWrap debwrp = new DebtorWrap(false,deb,count);
                    list_Debtorwrap.add(debwrp);
                    count++;
                }
                system.debug('Debtorwraplist--> '+ list_Debtorwrap);
                Debtorwraplist = list_Debtorwrap;
        }
        return null;
    }

public class DebtorWrap
{
    public boolean check {get;set;}
    public Debtor__c debtor{get;set;}
    Public integer rowCount{get;set;}
    public DebtorWrap(Boolean chk, Debtor__c deb,integer c)
    {
        check = chk;
        Debtor = deb;
        rowCount = c; 
    }
}

}