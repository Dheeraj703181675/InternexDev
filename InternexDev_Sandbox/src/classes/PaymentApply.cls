/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage: #to perform the functionality of Apply Cash. 
 */
public with sharing class PaymentApply {
    
    Id PaymentId = null;
    Id DebtorId = null;
    public List<TransactionWrapper> TransactionWrapperList{get;set;}
    public String selectedpaymentId{get;set;}
    public Debtor__c Deb{get;set;}
    public akritiv__payment__c Payment{get;set;}
    List<akritiv__Payment__c> paymentList;
    List<Debtor__c> debList;
    public double UnappliedBalnce{get;set;}
    public Integer InvoiceListSize{get;set;}
   
       
    Public PaymentApply()
    {
         if(ApexPages.currentPage().getParameters().get('PaymentId') != null)
         {
              PaymentId = ApexPages.currentPage().getParameters().get('PaymentId');
         }
         TransactionWrapperList = new List<TransactionWrapper>();
          if (PaymentId != null){
                paymentList = Database.query(getCreatableFieldsSOQL('akritiv__Payment__c','id =: PaymentId '));
                DebtorId = paymentList.get(0).Debtor__c;
                List<Debtor__c> debList = [select id,Client_Account__r.Client_Account__c,Client_Product_Counterparty__c,name from Debtor__c where id =: DebtorId];
                if(debList.size() > 0)
                deb = debList.get(0);
            }
            SearchTransactionSectionForPaymentApply();
    }
     // this method is used to list out the transaction to apply the payment. - when "Show Invoice" is clicked
    public pagereference SearchTransactionSectionForPaymentApply(){

   //     InvoiceListSize = 0;
         
        TransactionWrapperList = new List<TransactionWrapper>();
        TransactionWrapper tw = null;
        paymentList = Database.query(getCreatableFieldsSOQL('akritiv__Payment__c','id =: PaymentId '));
        Payment = paymentList.get(0);
         String query;
         List<akritiv__Transaction__c> txList = new List<akritiv__Transaction__c>();
         // String query = 'select id,Name,akritiv__Balance__c,akritiv__Due_date__c,TDS_Amount__c,Default_TDS_Rate__c,Override_TDS_Amount__c from akritiv__Transaction__c where TDS_Required__c = ' + '\'' + key + '\''  + ' AND akritiv__balance__c != 0 AND akritiv__Account__c = ' + '\'' + acc.Id + '\'';  
         if(deb != NULL)
         {    
               query = 'select id,Name,akritiv__Balance__c,akritiv__Amount__c,Invoice_Due_Date__c,akritiv__Create_Date__c,Transaction_Date__c ,Document_Number__c,Balance_Internex__c,Currency_Rate__c from akritiv__Transaction__c where Balance_Internex__c > 0 AND Invoice_Status_Internex__c = \''+'Approved'+'\'AND Debtor__c = ' + '\'' + deb.Id + '\'' + ' and Invoice_Due_Date__c != null order by Invoice_Due_Date__c';  
                system.debug('---query----'+query);
                txList = Database.query(query);
         }
       
        
        system.debug('---txList ----'+txList );
        System.debug('====Payment.Unapplied_Balance_calc__c===='+Payment.Unapplied_Balance_calc__c);
        UnappliedBalnce = Payment.Unapplied_Balance_calc__c;
        System.debug('====UnappliedBalnce===='+UnappliedBalnce);
        integer count = 0;
        for(akritiv__Transaction__c  ExTx : txList){
            tw = new TransactionWrapper();
            tw.rowCount = count;
            tw.tx = ExTx ;
         //   System.debug('====ExTx.Balance_Internex__c===='+ExTx.Balance_Internex__c);
            tw.AppliedAmount =0.0;
            //tw.AppliedAmount=ExTx.akritiv__Base_Balance__c-Extx.TDS_Amount__c;
            UnappliedBalnce = UnappliedBalnce - tw.AppliedAmount;
     /*        System.debug('====Payment.Unapplied_Balance_calc__c===='+Payment.Unapplied_Balance_calc__c);
            System.debug('====UnappliedBalnce===='+UnappliedBalnce);
            System.debug('===tw.AppliedAmount==='+tw.AppliedAmount);
*/

            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
             
            tw.tx.Payment_Date__c = Date.Today();
            tw.tx.Posting_Date__c = Date.Today();
            if(BsnsTransact != NULL)
                tw.PaymentLine.akritiv__Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
            else
                tw.PaymentLine.akritiv__Transaction_Date__c = Date.Today();
          // tw.TDSAmount = ExTx.akritiv__Amount__c * 0.1;
            tw.selected = false;
          //  tw.tx.Cash_Transaction_Type__c = PaymentToDisplay.Transaction_Type__c;
            tw.tx.Cash_Transaction_Type__c = 'Apply Cash';
           
            TransactionWrapperList.add(tw);
            count++;
        }
        UnappliedBalnce = Payment.Unapplied_Balance_Calc__c;
        InvoiceListSize = TransactionWrapperList.size();
        //system.debug('----InvoiceListSize----'+InvoiceListSize);
        
        return null;
    }
        public static string getCreatableFieldsSOQL(String objectName, String whereClause){
 
        String selects = '';
        if (whereClause == null || whereClause == ''){ return null; }
 
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
 

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
              //  if (fd.isCreateable()){ // field is creatable                    
                    selectFields.add(fd.getName());
              //  }
            }
        }
        
       if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){
              selects = selects.substring(0,selects.lastIndexOf(','));
          }
        }
        
        system.debug('-------selects - 1134 : ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause);
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
       
     return null;
    } 
     // this method is used to apply the payment to the invoice by creating payment line itme and it also creates new payment on TDS account,
    // if there is a TDS amount.
    public Pagereference ApplyPaymentForTx(){
      try{
        System.debug('ApplyPaymentForTx is called....');
       List<akritiv__Transaction__c> TransactionToUpdate = new List<akritiv__Transaction__c>();
       Double WriteOffAmount = 0;
       Map<Id,Double> AppliedTXMap = new Map<Id,Double>();
       Map<Id,Double> AppliedTDSTXMap = new Map<Id,Double>();
       Map<Id,Date> TransactionDateMap = new Map<Id,Date>();
       for(TransactionWrapper tw : TransactionWrapperList){
      if(tw.selected){
          AppliedTXMap.put(tw.Tx.Id,tw.AppliedAmount);
          AppliedTDSTXMap.put(tw.Tx.Id,tw.AppliedTDSAmount);
          TransactionDateMap.put(tw.Tx.Id,Date.valueof(tw.PaymentLine.akritiv__Transaction_Date__c));
          TransactionToUpdate.add(tw.tx);
 
      }
    }
    system.debug('----AppliedTXMap----'+AppliedTXMap);
    system.debug('---------TransactionToUpdate-----'+TransactionToUpdate);
    system.debug('------payment-----'+payment+'------and debtor------'+deb);
    string debid = CashAppUtitlityController.ApplyCash_new(deb,payment,TransactionToUpdate,AppliedTXMap,'',TransactionDateMap).Id;
    system.debug('Deb id ==> '+ debid);
  //  pagereference pf = new pagereference('/'+debid);
  
   SearchTransactionSectionForPaymentApply();
    return null;
  //  return new Pagereference('/'+);
    }catch(Exception e){
       SearchTransactionSectionForPaymentApply();
        return null;
    }
  }
    
    public class TransactionWrapper{
        public akritiv__Transaction__c tx{get;set;}
        public boolean selected{get;set;}
        public Double AppliedAmount{get;set;}
        public double AppliedTDSAmount{get;set;}
        public double TDSAmount{get;set;}
        public double WriteOffAmount{get;set;}
        public String WriteOffApprover{get;set;}
        Public akritiv__Payment_Line__c PaymentLine{get;set;}
        
        public integer rowCount{get;set;}
        
        public TransactionWrapper(){
            rowCount= 0;
            PaymentLine = new akritiv__Payment_Line__c();
        }
    }
}