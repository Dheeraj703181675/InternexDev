public with sharing class InvoiceModification {

    public void writeoffinvoices() {
    system.debug('WriteOff Transaction');
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        List<WriteOff__c> WriteoffList = new List<WriteOff__c>();
        for(Invoicewrapper IW : Invoicewrapperlist)
        {
            if(IW.Check == True)
            { 
                WriteOff__c wo = new WriteOff__c();
                wo.Invoices__c = IW.Invoice.Id;
                if(BsnsTransact != Null)
                {
                    wo.Date__C = BsnsTransact.Business_Transaction_Date__c;
                }
                else
                {
                     wo.Date__C = Date.today();
                }
                wo.WriteOff_Amount__c = IW.Writeoffamount;
                WriteoffList.add(wo);
            }
        }  
        try{
        system.debug(WriteoffList);
            insert WriteoffList;
            InvoiceSearch();
        }catch(exception e){
            system.debug('Write-Off Exception '+ e);
            apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,String.valueof(e.getMessage())));
            }
      //  return null;
    }


    public void SaveInvoices() {
        system.debug('Invoice Modification');
        List<akritiv__Transaction__c> TransactionList_toUpdate = new List<akritiv__Transaction__c>();
        for(Invoicewrapper IW : Invoicewrapperlist)
        {
            if(IW.Check == True)
            {    
                IW.Invoice.Remaining_Amt_from_Portal__c = IW.Invoice.akritiv__Amount__c;
                if(IW.Invoice.Invoice_Status_Internex__c == 'Pending Approval' || IW.Invoice.Invoice_Status_Internex__c == 'Rejected' )
                {
                    IW.Invoice.Invoice_Status_Internex__c = 'Approved';
                    IW.Invoice.IsModified__c = True;
                }
                TransactionList_toUpdate.add(IW.Invoice);
            }
        }  
        try{
            update TransactionList_toUpdate;
            InvoiceSearch();
        }catch(exception e){
            system.debug('Invoice Update Exception '+ e);
            apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,String.valueof(e.getMessage())));
        }      
      //  return null;
    }


    public InvoiceModification() {
        Inv = new akritiv__Transaction__c();         
    }
  
    public void InvoiceSearch() {
        Invoicewrapperlist = getInvoicelistwrap();
     //   return null;
    }

    public String InvoiceStatus { get; set; }
    public String ApprovalStatus { get; set; }
    public String operation { get; set; }
    public akritiv__Transaction__C Inv{ get; set; }
    Public list<Invoicewrapper> Invoicewrapperlist{get;set;}
    
    public list<Invoicewrapper> getInvoicelistwrap()
    {  system.debug('123');
        Invoicewrapper Invwrpr;
        list<Invoicewrapper> InvoiceListWrapper= new list<Invoicewrapper>();
        List<akritiv__Transaction__c> TransactionList = new List<akritiv__Transaction__c>();
        string queryString;
 
                    if(operation == '' || operation == 'None' || operation == NULL)
                    {
                   // operation.addError('Please select Operation.');
                        apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Operation.'));
                    }
                    if(Inv.Client_Acc__c != NULL )
                    {
                    queryString = 'select id,Name,Invoice_Status_Internex__c,akritiv__Amount__c,akritiv__Create_Date__c,Invoice_Due_Date__c,akritiv__Due_Date__c,Balance_Internex__c,akritiv__Batch_Number__c,Debtor_Status__c,Client_Acc__c, Invoice_Status__c,Flag_for_Modification__c,Remaining_Amt_from_Portal__c,';
                        queryString = queryString + 'IsModified__c,Debtor__c,Debtor__r.Client_Product_Counterparty__c,Debtor__r.Client_Account__c,Ineligibles_Amount__c,Past_Due_Days__c,Payment_Line_Count__c,Sum_of_Writeoff_amount__c from akritiv__Transaction__c where Debtor__r.Client_Account__c = \''+ Inv.Client_Acc__c +'\'';
                     //   queryString = queryString +' and Invoice_Status__c = \''+'Open'+'\'';
                                if(operation == 'Write-off')
                                {
                                    queryString = queryString +' and Invoice_Status_Internex__c = \''+ 'Approved' +'\' and Balance_Internex__c != 0';
                                }
                                if(operation == 'Modification')
                                {
                                    queryString = queryString +' and Payment_Line_Count__c = 0 and Sum_of_Writeoff_amount__c = 0 and Flag_for_Modification__c = True';
                                }                     
                                if(Inv.Debtor__c != NULL)
                                {
                                   queryString = queryString +' and Debtor__c = \''+ Inv.Debtor__c +'\'';
                                }
                                if(Inv.Document_Date__c != NULL)
                                {
                                    string From_Date  = string.valueof(Inv.Document_Date__c);
                                    string[] FromDate = From_Date.split(' ');
                                   queryString = queryString +' and akritiv__Create_Date__c >= '+ FromDate[0];
                                }
                                if(Inv.Last_Payment_Date__c != NULL)
                                {
                                    string To_Date  = string.valueof(Inv.Last_Payment_Date__c);
                                    string[] ToDate = To_Date.split(' ');
                                   queryString = queryString +' and akritiv__Create_Date__c <= '+ ToDate[0];
                                }
                                if(Inv.akritiv__Amount__c != NULL)
                                {
                                   queryString = queryString +' and akritiv__Amount__c >= '+ Inv.akritiv__Amount__c;
                                }
                                if(ApprovalStatus != NULL && ApprovalStatus != 'None')
                                {
                                   queryString = queryString +' and Invoice_Status_Internex__c = \''+ ApprovalStatus+'\'';
                                }
                           /*     if(InvoiceStatus != NULL && InvoiceStatus != 'None')
                                {
                                   queryString = queryString +' and Invoice_Status__c = \''+ InvoiceStatus +'\'';
                                } */
                               
                        queryString = queryString +' order by createddate desc Limit 9999';
                        system.debug('Query String==> '+queryString );     
                        TransactionList = Database.Query(queryString);
                    }
                    else
                    {
                        apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Client-Account.'));
                    } 
        
         integer count = 0;
        for(akritiv__Transaction__c INV : TransactionList){
            
            if(INV.akritiv__Due_Date__c == NULL)
            {
                INV.akritiv__Due_Date__c = INV.Invoice_Due_Date__c;
            }
            Invwrpr = new Invoicewrapper(false,INV,count);
            InvoiceListWrapper.add(Invwrpr);
            Count++; 
         }
        return InvoiceListWrapper;
    }

    public class InvoiceWrapper
    {
        public boolean Check {get;set;}
        Public akritiv__Transaction__C Invoice{ get; set; }
        Public double Writeoffamount{get;set;}
        Public integer rowCount{get;set;}
        Public Invoicewrapper(boolean Chck,akritiv__Transaction__c INV,integer c)
        {
             check = Chck;
             Invoice = INV;
             Writeoffamount = 0;
             rowCount = c; 
        }    
        
    }
}