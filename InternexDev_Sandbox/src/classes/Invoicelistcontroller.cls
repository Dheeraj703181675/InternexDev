public with sharing class Invoicelistcontroller {

    public Invoicelistcontroller(ApexPages.StandardController controller) {
        if(size == null)
            size = 10;
        if(Invoicestatus == Null)
          Invoicestatus = 'Pending Approval';
            Invoicewrapperlist = getInvoicelistwrap();
            Debtor = new Debtor__c();
    }
    
    Public list<Invoicewrapper> Invoicewrapperlist{get;set;}
    Public string Invoicestatus{get;set;}
    Public Debtor__c Debtor{get;set;}
//    Public List<String> BatchList{get;set;}
    Public String BatchNumber{get;set;}
    Public String ClientAccountName{get;set;}
    
    public list<Invoicewrapper> getInvoicelistwrap()
    {  
        Invoicewrapper Invwrpr;
        list<Invoicewrapper> InvoiceListWrapper= new list<Invoicewrapper>();
        for(akritiv__Transaction__c INV:(List<akritiv__Transaction__c >)setCon.getRecords()){
            Invwrpr = new Invoicewrapper(false,INV);
            InvoiceListWrapper.add(Invwrpr); 
         }
        return InvoiceListWrapper;
    }
    
    Public Void showclientAccountName()
    {
        if(Debtor.Client_Account__c != NULL)
        {
            ClientAccountName = [Select id,Client_Account__c From Client_Account__c where id =: Debtor.Client_Account__c].Client_Account__c;
        }
    }
    
    Public List<Wrapperclass> getSelectbatch()
    {
        if(Debtor.Client_Account__c != NULL)
        {
            List<Wrapperclass> Listbatch = new List<Wrapperclass>();
            integer i=0,j=0,k=0;String BatchNumber;
            for(aggregateResult Invaggr : [Select Count(id) cid,Invoice_Status_Internex__c Status,akritiv__Batch_Number__c BN,Debtor__r.Client_Account__c from akritiv__Transaction__c where Debtor__r.Client_Account__c =: Debtor.Client_Account__c Group By akritiv__Batch_Number__c,Invoice_Status_Internex__c,Debtor__r.Client_Account__c order by akritiv__Batch_Number__c DESC limit 49999])
            {
                if(Invaggr.get('BN') != NULL)
                {
                    if(BatchNumber != String.valueof(Invaggr.get('BN')))
                    {
                        i = 0;j = 0;k = 0;
                    }
                
                    if(Invaggr.get('Status') == 'Approved' && Invaggr.get('cid') != Null)
                        i = Integer.valueof(Invaggr.get('cid'));
                    if(Invaggr.get('Status') == 'Pending Approval' && Invaggr.get('cid') != Null)
                        j = Integer.valueof(Invaggr.get('cid'));
                    if(Invaggr.get('Status') == 'Rejected' && Invaggr.get('cid') != Null)
                        k = Integer.valueof(Invaggr.get('cid'));

                        BatchNumber = String.valueof(Invaggr.get('BN'));
                    
                    Wrapperclass WC = new Wrapperclass(BatchNumber,i+j+k,j,i,k);  
                     
                    if(Listbatch.Size()>0)
                    {
                        Integer m = 0;
                        while (m < Listbatch.size())
                        {
                          if(Listbatch.get(m).batchNumber == BatchNumber)
                          {
                     //      system.debug('12 > '+ Listbatch);
                            Listbatch.remove(m);
                      //     system.debug('123 > '+ Listbatch); 
                          }else
                          {
                            m++;
                          }
                        }
                    }
                 Listbatch.add(WC);
                }
              //  system.debug('1234 > '+ Listbatch);
            }
            return Listbatch;
        }
        else
        {
            return NULL;
        }
      
    }
    
    Public void RefreshTable()
    {
         size = integer.valueof(limits);
         setCon.setPageNumber(size );
         setCon = null;
         Invoicewrapperlist = getInvoicelistwrap();    
    }
    public ApexPages.StandardSetController setCon {
        get{   
            if( setCon == null)
            {
                string queryString = 'select id,Name,Invoice_Status_Internex__c,akritiv__Amount__c,akritiv__Create_Date__c,Invoice_Due_Date__c,Balance_Internex__c,akritiv__Batch_Number__c,Debtor_Status__c,Remaining_Amt_from_Portal__c,';
                    queryString = queryString + 'Debtor__c,Debtor__r.Client_Product_Counterparty__c,Debtor__r.Client_Account__c,Ineligibles_Amount__c,Past_Due_Days__c from akritiv__Transaction__c where Invoice_Status_Internex__c = \''+Invoicestatus+ '\'and akritiv__Batch_Number__c = \''+BatchNumber+'\'';
                    if(Debtor != NULL && Debtor.Client_Account__c != NULL)
                    {
                       queryString = queryString +' and Debtor__r.Client_Account__c = \''+ Debtor.Client_Account__c +'\'';
                    }
                    queryString = queryString +' order by createddate desc Limit 9999';
                   system.debug('Query String==> '+queryString );     
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize(); 
            }               
            return setCon;
        }set;
    }
    
    Public void InvoiceApprove()
    {
        List<akritiv__Transaction__c> InvoiceList = new List<akritiv__Transaction__c>();
        for(Invoicewrapper Invwrp : Invoicewrapperlist)
        {
            if(Invwrp.check == True)
            {
            //    if(Invwrp.Invoice.Debtor_Status__c == 'Eligible')
            //    {
                    Invwrp.Invoice.Invoice_Status_Internex__c = 'Approved';
                    InvoiceList.add(Invwrp.Invoice);
            /*    }
                else
                {
                    apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Debtor should be in Eligible Status for approving the Invoice.'));
                } */
            }
        }
        try{
            update InvoiceList;
    /*    for(akritiv__Transaction__c Inv : InvoiceList)
        {
            string partnerURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
            TPSSF.TPConnectorService.SubmitExt('akritiv__Transaction__c',Inv.Id, '' ,'' ,'sendtoportal','akritiv-internex-invoice','',UserInfo.getUserId(),UserInfo.getSessionId(),partnerURL, UserInfo.getUserName(), '','','');
        }
        */
         setCon = null;
         Invoicewrapperlist = getInvoicelistwrap(); 
         getSelectbatch();
             
        }catch(Exception e){system.debug('exception ==> '+ e); // apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,String.valueof(e.getMessage())));
        }
    }
    Public Void InvoiceReject()
    {
        List<akritiv__Transaction__c> InvoiceList = new List<akritiv__Transaction__c>();
        for(Invoicewrapper Invwrp : Invoicewrapperlist)
        {
            if(Invwrp.check == True)
            {
             //   if(Invwrp.Invoice.Debtor_Status__c == 'Eligible')
             //   {
                    Invwrp.Invoice.Invoice_Status_Internex__c = 'Rejected';
                    InvoiceList.add(Invwrp.Invoice);
             /*   }
                else
                {
                    apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Debtor should be in Eligible Status for Rejecting the Invoice.'));
                } */   
            }
        }
        try{
            update InvoiceList;
      /*      for(akritiv__Transaction__c Inv : InvoiceList)
            {
                string partnerURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
                TPSSF.TPConnectorService.SubmitExt('akritiv__Transaction__c',Inv.Id, '' ,'' ,'sendtoportal','akritiv-internex-invoice','',UserInfo.getUserId(),UserInfo.getSessionId(),partnerURL, UserInfo.getUserName(), '','','');
            }
     */
             setCon = null;
         Invoicewrapperlist = getInvoicelistwrap();
         getSelectbatch();      
        }catch(Exception e){system.debug('exception ==> '+ e);}

    }
    
    //============= Pagination Code ==============//    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    Public string limits{get;set;}
    Public Integer totalPage{
        get {
            if((setCon.getResultSize() / setCon.getPageSize()) == 0)
                return 1;
            else
                return (setCon.getResultSize() / setCon.getPageSize())+1;
        }
        set;
    }
    Public Pagereference changeLimit(){
        size = integer.valueof(limits);
        setCon.setPageNumber(size );
         setCon = null;
         Invoicewrapperlist = getInvoicelistwrap();    
        return null;
    } 
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    public Integer pageNumber {
        get {  
            return setCon.getPageNumber();
        }
        set;
    }
    
    public void first() {
       setCon.first();
       Invoicewrapperlist = getInvoicelistwrap();
    }
    
    public void last() {
        setCon.last();
        Invoicewrapperlist = getInvoicelistwrap();
    }
    
    public void previous() {
        setCon.previous();
        Invoicewrapperlist = getInvoicelistwrap();
    }
    
    public void next() {
        setCon.next();
         Invoicewrapperlist = getInvoicelistwrap();
    }
 //===============End of Pagination Code==================//   
    public class Invoicewrapper
    {
        public boolean check{ get; set; }
        public akritiv__Transaction__c Invoice{ get; set; }
        
        Public Invoicewrapper(boolean Chck,akritiv__Transaction__c INV)
        {
             check = Chck;
             Invoice = INV; 
        }    
    }
    Public Class Wrapperclass
    {
        Public string batchNumber{get;set;}
        Public integer Total{get;set;}
        Public integer PAcount{get;set;}
        Public integer Approvalcount{get;set;}
        Public integer Rejectcount{get;set;}
        Public Wrapperclass(string BN,integer T,integer PAC,integer AC,integer RC)
        {
            batchNumber = BN;
            Total = T;
            PAcount = PAC;
            Approvalcount = AC;
            Rejectcount = RC;
        }
    }

}