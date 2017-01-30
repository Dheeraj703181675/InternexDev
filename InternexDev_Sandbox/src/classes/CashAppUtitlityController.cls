/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage: #Utility class of Cash Application.
          #Class is used to perform functionality of Cash Application.
          #Class have Account-to-account transfer, Reversal, Backout, Write Back,
           Write Off, Apply Cash.  
 */

public with sharing class CashAppUtitlityController {
    
    public Static String CreateComments(){
  /*  if(temp2.length() == 1){
            temp2 = '0' + temp2;
        }
        
        String cNote = temp2 + '-' + temp1 + '-' + temp3 + ' by ' + userInfo.getName() + '\n';*/
        
        String cNote = '';
        return cNote;
    }
   public static Debtor__C WriteOffTransaction_New(Debtor__C acc, List<akritiv__Transaction__c> txList,String writeOffType,Map<Id,Double> TxMap){
        double WriteOffAmount = 0;
        for(akritiv__transaction__c trx : txList){
                WriteOffAmount  = WriteOffAmount + TxMap.get(trx.Id);
        }
        list<akritiv__Payment__c> PaymentList_toInsert = new List<akritiv__Payment__c>();
        akritiv__Payment__c payment = new akritiv__Payment__c();
        payment.Name = generateUniqueKey(WriteOffAmount,String.valueOf(acc.Id));
        payment.akritiv__Amount__c = WriteOffAmount ;
        payment.Debtor__c = acc.Id;
        Payment.Client_Account__c = acc.Client_Account__c;
        payment.akritiv__Account__c = acc.Counterparty__c;
        payment.akritiv__Payment_Date__c = Date.Today();
        payment.Transaction_Date__c = Date.Today();
        payment.Transaction_Type__c = 'Write Off';
        payment.Write_Off_Type__c = writeOffType;
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Comments__c = 'Payment created for Writeoff';
        PaymentList_toInsert.add(payment);
        insert PaymentList_toInsert;
        
 //     Double SmallAmt = ConfigUtilController.getSmallWriteoffAmount();
 //       Account smallAmtAccount = CashAppUtitlityController.smallAmtWriteOffAcc();
        
 //       list<akritiv__Transaction__c> smallAmtTrxList = new list<akritiv__Transaction__c>();
        
        List<akritiv__Payment_Line__c> PaymentLineToInsert = new List<akritiv__Payment_Line__c>();
        akritiv__Payment_Line__c paymentLine = null;
        list<akritiv__Transaction__c> listTrxToUpdate = new list<akritiv__Transaction__c>();
        akritiv__Transaction__c trxObj;
        for(akritiv__Transaction__c tx : txList){
            paymentLine = new akritiv__Payment_Line__c();
            paymentLine.akritiv__Payment__c = payment.Id;
            paymentLine.Approval_Status__c = 'Approved';
			paymentLine.akritiv__Applied_Amount__c = TxMap.get(tx.Id); 
            
            trxObj = new akritiv__Transaction__c();
			trxObj.Id = tx.Id;
            listTrxToUpdate.add(trxObj);
            
            paymentLine.akritiv__Applied_To__c = tx.Id ;
            paymentLine.Transaction_Type__c = 'Write Off';
            paymentLine.Comments__c = 'Created for Writeoff';

            PaymentLineToInsert.add(paymentLine);
        }
        system.debug('---PaymentLineToInsert----'+PaymentLineToInsert);
        if(listTrxToUpdate.size() > 0){
            update listTrxToUpdate;
        }
        upsert PaymentLineToInsert;
        return acc;
    }
    
    public static Client_Account__c WriteOffClientaccountFIU(Client_Account__c acc, List<Client_Account__c> AcList,String writeOffType,Map<Id,Double> ACMap){
        double WriteOffAmount = 0;
        for(Client_Account__c CA : AcList){
                WriteOffAmount  = WriteOffAmount + ACMap.get(CA.Id);
        }
        list<akritiv__Payment__c> PaymentList_toInsert = new List<akritiv__Payment__c>();
        akritiv__Payment__c payment = new akritiv__Payment__c();
        payment.Name = generateUniqueKey(WriteOffAmount,String.valueOf(acc.Id));
        payment.akritiv__Amount__c = WriteOffAmount ;
  //      payment.Debtor__c = acc.Id;
        Payment.Client_Account__c = acc.ID;
        payment.akritiv__Account__c = acc.Client__r.CounterParty__c;
        payment.akritiv__Payment_Date__c = Date.Today();
        payment.Transaction_Date__c = Date.Today();
        payment.Transaction_Type__c = 'Write Off';
        payment.akritiv__Payment_Type__c = 'Manual';
        payment.Write_Off_Type__c = writeOffType;
        payment.Comments__c = 'Payment created for Writeoff';
        PaymentList_toInsert.add(payment);
        insert payment;

        return acc;
    }

    public static Debtor__c ApplyCash_new(Debtor__c acc, akritiv__Payment__c payment,List<akritiv__Transaction__c> txList, Map<Id,Double> AppliedTXMap,String Comment,Map<Id,Date> TransactionDateMap){
        System.debug('ApplyCash New method is called from CashAppUtility');
       // String TDSAcctKey = ConfigUtilController.getTDSAccountKey();
        List<akritiv__Payment_Line__c> PaymentLineToInsert = new List<akritiv__Payment_Line__c>();
        akritiv__Payment_Line__c paymentLine = null;
        //Account TdsAct = [select id from Account where akritiv__Account_key__c =: TDSAcctKey ] ;
        Double TotalTDSAmount = 0;
        
        System.debug('-----txList-----'+txList);
        
        Double TotalSelectedAmt = 0;
        for(akritiv__Transaction__c tx : txList){
            TotalSelectedAmt += AppliedTXMap.get(tx.Id);
        }
        
        Double SmallAmoutWriteOff = 0;
        system.debug('Id-----'+payment.Id);
        system.debug('SmallAmoutWriteOff'+SmallAmoutWriteOff);
        system.debug('TotalSelectedAmt'+TotalSelectedAmt);
	    system.debug('payment.akritiv__Amount__c'+payment.akritiv__Amount__c);
        system.debug('payment.Applied_Amount_calc__c'+payment.Applied_Amount_calc__c);
        system.debug('payment.Unapplied_Balance_Calc__c'+payment.Unapplied_Balance_Calc__c);      
        
        SmallAmoutWriteOff = TotalSelectedAmt - payment.Unapplied_Balance_Calc__c;
        akritiv__Payment__c smallPayment = null;
        
        if(SmallAmoutWriteOff > 0){
           
        }
        Double ConsumedAmt = Payment.Unapplied_Balance_Calc__c;
        Double remConvertedBalance = Payment.Unapplied_Balance_Calc__c;
        
        Double PreviosConsumeAmt = ConsumedAmt;
        boolean flag = false;

    	// ==commented on may31==deleted this class===   Double SmallAmt = ConfigUtilController.getSmallWriteoffAmount();
   		Double SmallAmt = 0.0;
        // ==commented on may31==deleted this class===   Double SmallWriteBackAmt = ConfigUtilController.getSmallWriteBackAmount();
        Double SmallWriteBackAmt = 0.0;
        
        String cNote  = CreateComments();
        cNote  = cNote  + comment;
        
//        Account smallAmtAccount = CashAppUtitlityController.smallAmtWriteOffAcc();
        
        list<akritiv__Transaction__c> smallAmtTrxList = new list<akritiv__Transaction__c>();
        
        //====================Populate Last Payment Date==============================================
        list<akritiv__Transaction__c> TrxListToUpdate = new list<akritiv__Transaction__c>();
        akritiv__Transaction__c trxObj;
        //============================================================================================
        
        for(akritiv__Transaction__c tx : txList){
           
            trxObj = new akritiv__Transaction__c();
            trxObj.Id = tx.Id;
            trxObj.Last_Payment_Date__c = Date.Today();
            TrxListToUpdate.add(trxObj);
            paymentLine = new akritiv__Payment_Line__c();
           
            if(AppliedTXMap.get(tx.Id)  > remConvertedBalance ){
                paymentLine.akritiv__Applied_Amount__c = remConvertedBalance;
            }else{
                paymentLine.akritiv__Applied_Amount__c = AppliedTXMap.get(tx.Id);
            }
            paymentLine.akritiv__Applied_To__c = tx.Id;
            paymentLine.akritiv__Payment__c = payment.Id;
       //     paymentLine.Approval_Status__c = 'Pending Approved';
            //paymentLine.Document_Number__c = tx.Document_Number__c;
            paymentLine.Transaction_Type__c = 'Apply Cash';
            paymentLine.Comments__c = cNote;
            if(TransactionDateMap != NULL && TransactionDateMap.containsKey(tx.Id))
            {
                if(TransactionDateMap.get(tx.Id) != NULL)
                	paymentLine.akritiv__Transaction_Date__c = TransactionDateMap.get(tx.Id);
                else
                    paymentLine.akritiv__Transaction_Date__c = Date.Today();
            }
            else
            {
                paymentLine.akritiv__Transaction_Date__c = Date.Today();
            }
            //paymentLine.Rate__c = double.valueOf(currencyRate);
            //paymentLine.CurrencyIsoCode = SelectedCurrency;
            //paymentLine.Payment_Date__c = tx.Payment_Date__c;
            //paymentLine.Posting_Date__c = tx.Posting_Date__c;
            
            System.debug('-----paymentLine.akritiv__Applied_Amount__c----+'+paymentLine.akritiv__Applied_Amount__c);
            //System.debug('-----tx.Currency_Rate__c----'+tx.Currency_Rate__c);
            // transaction currency rate used to set base balance field
           //paymentLine.Residual_Amount__c = (tx.akritiv__Balance__c - paymentLine.akritiv__Applied_Amount__c).SetScale(2);
           
            //tx.akritiv__Balance__c = tx.akritiv__Balance__c - paymentLine.akritiv__Applied_Amount__c;
             //tx.akritiv__Base_Balance__c = (tx.akritiv__Base_Balance__c - double.valueOf(paymentLine.akritiv__Applied_Amount__c * decimal.ValueOf(tx.Currency_Rate__c))).SetScale(2); 
        
	//================ Already Commented ===============================//   
			/*if(tx.akritiv__Base_Balance__c > 0 && tx.akritiv__Base_Balance__c < SmallAmt ){
                smallAmtTrxList.add(tx);
                //A CashAppUtitlityController.SmallAmountWriteOff(tx,smallAmtAccount);
            }*/
    //================ Already Commented ===============================//   

            System.debug('=====tx.akritiv__Balance__c=========='+tx.akritiv__Balance__c);
            if(tx.akritiv__Balance__c.SetScale(2) > 0 && tx.akritiv__Balance__c < SmallAmt && tx.akritiv__Amount__c > smallAmt){
                 smallAmtTrxList.add(tx);
            }else if(tx.akritiv__Balance__c.SetScale(2) > 0 && tx.akritiv__Amount__c  < smallAmt && tx.akritiv__Balance__c <= tx.akritiv__Amount__c ){
                 smallAmtTrxList.add(tx);
            }
            
            paymentLineToInsert.add(paymentLine);
        }
        system.debug('---smallAmtTrxList----'+smallAmtTrxList); 
	//================ Already Commented ===============================//   
    	/*    if(smallAmtTrxList.size() > 0){
            CashAppUtitlityController.SmallAmountWriteOff(smallAmtTrxList,smallAmtAccount);
        }*/
    //================ Already Commented ===============================//   
  
        if(TrxListToUpdate.size() > 0){
            Update TrxListToUpdate;
        }
        system.debug('---smallPayment----'+smallPayment);
        system.debug('---PaymentLineToInsert----'+PaymentLineToInsert);
        if(PaymentLineToInsert.size() > 0){
       //=====commented on may31==deleted the this class==     checkRecursive.run = true;==//
            insert PaymentLineToInsert;
        }
        
        //=======================================Small Amount Write Back Payment=========================
   // ==commented on may31==deleted this class==    Account WriteBackAccount = CashAppUtitlityController.WriteBackAcc();
        Account WriteBackAccount = new account();
        list<akritiv__Payment__c> AutoWriteBacklist = new list<akritiv__Payment__c>();
      
        Decimal AutoWriteBackAmt = 0;
        //AutoWriteBackAmt = payment.Unapplied_Balance_Calc__c - TotalSelectedAmt;
         payment.Applied_Amount_calc__c =  payment.Applied_Amount_calc__c + TotalSelectedAmt;
        System.debug('===SmallWriteBackAmt==='+SmallWriteBackAmt);
       
        System.debug('===payment.akritiv__Amount__c - payment.Applied_Amount_calc__c set scale==='+(payment.akritiv__Amount__c - payment.Applied_Amount_calc__c).SetScale(2));
        System.debug('===payment.akritiv__Amount__c - payment.Applied_Amount_calc__c==='+(payment.akritiv__Amount__c - payment.Applied_Amount_calc__c));
        if(payment.Payment_Ref__c != null && (payment.akritiv__Amount__c - payment.Applied_Amount_calc__c).SetScale(2) < SmallWriteBackAmt && (payment.akritiv__Amount__c - payment.Applied_Amount_calc__c).SetScale(2) > 0){
               AutoWriteBacklist.add(payment);
        }
        if(AutoWriteBacklist.size() > 0){
      // ==commented on may31==deleted this class== CashAppUtitlityController.AutoWriteBackPayment(AutoWriteBacklist,WriteBackAccount);
        }
        //===============================================================================================
        
        if(payment.Transaction_Code__c == 'Credit note'){
            akritiv__Payment__c paymentObj = new akritiv__Payment__c();
            paymentObj.Send_To_External_Source__c = true;
            paymentObj.Id = payment.Id;
            update paymentObj;
        }
        system.debug('Debtor ==> '+ acc);
        //================ Already Commented ===============================//   
      /*  List<Client_Account__c> Client_account_List = [Select id,IUF_from_Payment__c,IUF_Reserve_Retained__c from Client_Account__c where Id =: payment.Client_Account__c];
        List<Client_Account__c> Update_Client_Account_List = new List<Client_Account__c>();
        if(Client_account_List.size() > 0)
        {
            Client_account_List[0].IUF_Reserve_Retained__c += payment.IUF_Required__c;
            Client_account_List[0].IUF_from_Payment__c = payment.IUF_Required__c;
            Update_Client_Account_List.add(Client_account_List[0]);
            try
            {
                update Update_Client_Account_List;
            }catch(exception e){system.debug('===>e '+ e);}
        }  */
    //================ Already Commented ===============================//   
        return acc;
    } 
  
    public static String generateUniqueKey(Decimal Amount,String AccountId){
        System.debug('######### generateUniqueKey is called');
        System.debug('@@@@@@@@@@@@@ Amount - '+amount+' and Account ID : '+accountId);
        String PaymentName = UserInfo.getUserID().substring(UserInfo.getUserID().length()-3,UserInfo.getUserID().Length());
        datetime myDateTime = datetime.now();
        
        System.debug('********'+(String.valueOf((myDateTime.millisecond() + Amount)) + PaymentName + AccountId.substring(AccountId.length()-6,AccountId.Length())).replace('.',''));
        
        return (String.valueOf((myDateTime.millisecond() + Amount)) + PaymentName + AccountId.substring(AccountId.length()-6,AccountId.Length())).replace('.','');
    }
 
}