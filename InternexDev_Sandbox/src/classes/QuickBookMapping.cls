public with sharing class QuickBookMapping {

    public PageReference SendtoPortal() {
 //   system.debug('123 '+QuickbookId );
      string partnerURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
        TPSSF.TPConnectorService.SubmitExt('QB_Customer__c',QuickbookId, '' ,'' ,'sendtoportal','' ,'',UserInfo.getUserId(),UserInfo.getSessionId(),partnerURL, UserInfo.getUserName(), '','','');
        SearchCustomers();
        return null;
    }

    public string QuickbookId{get;set;}
    Public Client_Account__c Client{get; set;}
    
    Public void FillDebtor()
    {
       map<String,String> Account_Phone_map = new map<String,String>();
       map<String,String> Account_Email_map = new map<String,String>();
        Set<String> PhoneNumbers = new Set<String>();
        Set<String> Emails = new Set<String>();
       for(customerwrap CW : CustomerwrapList )
        {
            if(CW.QBC.Phone_for_Integration__c != NULL)
            {
                PhoneNumbers.add(CW.QBC.Phone_for_Integration__c);
                Emails.add(CW.QBC.Email_for_Integration__c);
            }
        }
        for(Contact Con : [Select id,Name,AccountId,Phone,Primary_Contact__c,Phone_for_Integration__c,Email_for_Integration__c From Contact where Primary_Contact__c =: True and ((Phone_for_Integration__c != NULL and Phone_for_Integration__c in : PhoneNumbers) or (Email_for_Integration__c != NULL and Email_for_Integration__c  in : Emails))])
        {
            Account_Phone_map.put(con.Phone_for_Integration__c ,Con.AccountId);
            Account_Email_map.put(con.Email_for_Integration__c ,Con.AccountId);
        }
        list<Debtor__C> Debtorlist = [Select id,Counterparty__c,Client_Product_Counterparty__c,Client_Account__r.Client__C from Debtor__C where (Counterparty__c in : Account_Phone_map.values() or Counterparty__c in : Account_Email_map.values()) and Client_Account__r.Client__C =: Client.Client__c];
        for(customerwrap CW : CustomerwrapList)
        {
            for(Debtor__C Debtor : Debtorlist)
            {
               if(Account_Phone_map != NULL && Account_Phone_map.containsKey(CW.QBC.Phone_for_Integration__c))
               {
                   if(Debtor.Counterparty__c == Account_Phone_map.get(CW.QBC.Phone_for_Integration__c))
                   {
                       CW.QBC.debtor__C = Debtor.ID;
                       CW.DebtorName = Debtor.Client_Product_Counterparty__c;
                       CW.check = true;
                   }
               }
               else if(Account_Email_map != NULL && Account_Email_map.containsKey(CW.QBC.Email_for_Integration__c))
               {
                   if(Debtor.Counterparty__c == Account_Email_map.get(CW.QBC.Email_for_Integration__c))
                   {
                       CW.QBC.debtor__C = Debtor.ID;
                       CW.DebtorName = Debtor.Client_Product_Counterparty__c;
                       CW.check = true;
                   }        
               } 
            }
        }
    }

    public PageReference ApplyCustomers() {
        List<QB_Customer__c> QBC_Update_List = new List<QB_Customer__c>();
        seT<string> QB_ID = new Set<String>();
        Set<String> ClientID_set = new Set<String>();
        for(customerwrap CW : CustomerwrapList )
        {
            if(CW.check == True)
            {
                QB_ID.add(CW.QBC.QuickBook_ID__c);
                ClientID_set.add(CW.QBC.Client_Id__c);system.debug('CW.QBC.Client_Id__c==> '+ CW.QBC.Client_Id__c);
                QBC_Update_List.add(CW.QBC);
            }
        }
        if(QBC_Update_List.size() > 0)
        {
            try{
            Update QBC_Update_List;
            List<akritiv__Transaction__c> Invoice_List = new List<akritiv__Transaction__c>();
            system.debug('QB ID==> '+ QB_ID);system.debug('ClientID_set==> '+ ClientID_set);
            List<QB_Invoice__c> QbInvoice_List = [Select id,name,QB_ID__c,Transaction_Date__c,DueDate__c,TotalAmt__c,QB_LastUpdatedTime__c,CustomerRef__c from QB_Invoice__c where CustomerRef__c in : QB_ID and Client_Id__c in : ClientID_set];
            for(QB_Invoice__c QB_INV : QbInvoice_List)
            {
                akritiv__Transaction__c INV = new akritiv__Transaction__c();
                INV.Name = QB_INV.Name;
                INV.akritiv__Create_Date__c = QB_INV.Transaction_Date__c;
                INV.akritiv__Due_Date__c = QB_INV.DueDate__c;
                for(QB_Customer__c QBC : QBC_Update_List)
                {
                      if(String.valueof(QBC.QuickBook_ID__c).toUpperCase().trim() == String.valueof(QB_INV.CustomerRef__c).toUpperCase().trim())
                      INV.Debtor__c = QBC.Debtor__c;
                }
                
       //         INV.akritiv__Account__c = QB_INV
                INV.akritiv__Amount__c = QB_INV.TotalAmt__c;
         //       INV.akritiv__Batch_Number__c = 'Batch '+ QB_INV.QB_LastUpdatedTime__c;
                INV.Document_Type__c = 'IN';
                INV.QB_Invoice_ID__c =  QB_INV.QB_ID__c;
                INV.Source__c = 'Quick Books';
                Invoice_List.add(INV);
            }
                insert Invoice_List;
            }catch(Exception e){
                system.debug('Exception e => '+ e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
            }
        }
        setCon = null;
        CustomerwrapList = FillCustomerList();
        return null;
    }


public QuickBookMapping()
{
    if(size == null)
        size = 20;
        Client = New Client_Account__C();
    CustomerwrapList = new List<customerwrap>();
    CustomerwrapList = FillCustomerList();
}

Public List<customerwrap> FillCustomerList()
{
    List<customerwrap> Temp_CustomerWraplist = new List<customerwrap>();
    
 /*   List<QB_Customer__c> QBC_list = [Select id,Active__c,Balance__c,DisplayName__c,FullyQualifiedName__c,Job__c,Primary_Email__c,Primary_Phone_Number__c,
                                    QB_CreateTime__c,QB_LastUpdatedTime__c,QuickBook_ID__c,SyncToken__c,Taxable__c,Phone_for_Integration__c,
                                    Debtor__C from QB_Customer__c where Active__c =: True and Debtor__C =: Null];*/
    integer count = 0;
    for(QB_Customer__c QBC : (List<QB_Customer__c>)setCon.getRecords())
    {
        customerwrap CW = new customerwrap();
        CW.check = False;
        CW.QBC = QBC;
        CW.rowCount = Count;
        Temp_CustomerWraplist.add(CW); 
        count++;
    }
    return Temp_CustomerWraplist;
}

Public List<customerwrap> CustomerwrapList {get;set;}
    public class customerwrap
    {
        public Boolean check {get;set;}
        public QB_Customer__c QBC{get;set;}
        public integer rowCount{get;set;}
        Public String DebtorName{get;set;}
        public customerwrap()
        {
            rowCount = 0;
        }
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
        setCon = null;
     //   getInvoiceListWrapper();
        CustomerwrapList = FillCustomerList();
        return null;
    }
    
  Public void SearchCustomers()
  {
       string queryString = 'Select id,Active__c,Balance__c,DisplayName__c,FullyQualifiedName__c,Job__c,Primary_Email__c,Primary_Phone_Number__c,Client_Id__c,Client_ID_formula__c,Portal_External_ID__c,';
                  queryString = queryString + 'QB_CreateTime__c,QB_LastUpdatedTime__c,QuickBook_ID__c,SyncToken__c,Taxable__c,Phone_for_Integration__c,Email_for_Integration__c,';
                  queryString = queryString + ' Debtor__C from QB_Customer__c where Active__c = True and Debtor__C = Null';
                 if(Client.Client__c != NULL)
                  {
                       queryString = queryString + ' and Client_ID_formula__c = \''+ Client.Client__c +'\'';
                  }
                  
                  queryString = queryString +' order by createddate desc limit 9999';
              system.debug('queryString => '+ queryString);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
               noOfRecords = setCon.getResultSize();
               CustomerwrapList = FillCustomerList();
  }  
    
public ApexPages.StandardSetController setCon {
        get{   
            if( setCon == null)
             {    string queryString = 'Select id,Active__c,Balance__c,DisplayName__c,FullyQualifiedName__c,Job__c,Primary_Email__c,Primary_Phone_Number__c,Client_Id__c,Portal_External_ID__c,';
                  queryString = queryString + 'QB_CreateTime__c,QB_LastUpdatedTime__c,QuickBook_ID__c,SyncToken__c,Taxable__c,Phone_for_Integration__c,Email_for_Integration__c,';
                  queryString = queryString + ' Debtor__C from QB_Customer__c where Active__c = True and Debtor__C = Null and Client_ID_formula__c = \''+ Client.Client__c +'\'';//order by createddate desc limit 9999';
              
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
               noOfRecords = setCon.getResultSize(); 
             }               
            return setCon;
        }set;
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
        CustomerwrapList = FillCustomerList();
    }
  
    public void last() {
        setCon.last();
        CustomerwrapList = FillCustomerList();
    }
  
    public void previous() {
        setCon.previous();
        CustomerwrapList = FillCustomerList();
    }
  
    public void next() {
        setCon.next();
        CustomerwrapList = FillCustomerList();
    }   
}