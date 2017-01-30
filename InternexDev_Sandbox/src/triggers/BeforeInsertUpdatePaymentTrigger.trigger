trigger BeforeInsertUpdatePaymentTrigger on akritiv__Payment__c (before insert,before update,after insert,after update,after delete) {
    try{
         /*   if(akritiv__Trigger_Configuration__c.getOrgDefaults().BeforeInsertUpdatePaymentTrigger__c)
            {      
                if(Trigger.isBefore){
                    
                     Map < String, Double > rateMap = new  Map < String, Double >();
                          String SOQLQuery = 'Select c.IsoCode , c.ConversionRate From CurrencyType c';

                         List < Sobject > currencyTypes = Database.query(SOQLQuery);
                         for ( Sobject currencyType :  currencyTypes ) {

                            rateMap.put( ( String )currencyType.get('IsoCode'), ( Double  )currencyType.get('ConversionRate'));
                         }

 //                       Map<Id,String> AccountCurrencyMap = new Map<Id,String>();
                        Set<Id> AccountIdSet = new Set<Id>();
                        
                        
                        for(akritiv__Payment__c pay : Trigger.New){
                            AccountIdSet.add(pay.akritiv__Account__c);
                        }*/
        //========= Already Commented===========//
 /*                       List<Account> accList = new List<Account>();
                        if(AccountIdSet.size() > 0){
                             accList = [select id, currencyIsocode from Account where id in : AccountIdSet];
                        }
                        for(Account acc : accList){
                            AccountCurrencyMap.put(acc.Id,String.valueOf(acc.get('CurrencyIsoCode')));
                        }*/ 
        //==============end=============//            
                  /*      for(akritiv__Payment__c pay : Trigger.New){ */
                            // pay.CurrencyISOCode = pay.akritiv__Account__r.CurrencyISOCode; 
                          //  system.debug('---rateMap.get'+rateMap.get(String.valueOf(pay.akritiv__Account__r.get('CurrencyISOCode'))));
          //========= Already Commented===========//             
        /*  if(pay.Currency_Rate__c == null || pay.Currency_Rate__c == 0){    
                          
                                  pay.Currency_Rate__c = 1/(rateMap.get(AccountCurrencyMap.get(pay.akritiv__Account__c)));
                             
                          }*/
             //==============end=============//      
             /*                
                          pay.Payment_Amount_in_Billing_Currency__c = pay.akritiv__Amount__c /  pay.Currency_Rate__c;
                          pay.UnApplied_Balance_in_Billing_Currency__c = pay.UnApplied_Balance_calc__c / pay.Currency_Rate__c;
                        }
                        
                   // List<GL_Matrix_Config__c> ListGLMatrix =[ SELECT Bank_GL_Code__c,Profit_Center__c,Account_Type__c,  Customer_Posting_Key__c, Document_Type__c,  Name, Posting_Key__c, Id, Special_GL_Indicator__c FROM GL_Matrix_Config__c  ];
                    List<GL_Matrix_Config__c> ListGLMatrix = GL_Matrix_Config__c.getall().values();
                    if(ListGLMatrix!= null && ListGLMatrix.size()>0)
                    {
                        Map<String, GL_Matrix_Config__c> mapNameGLMatrix = new Map<String, GL_Matrix_Config__c>();
                        
                        for(GL_Matrix_Config__c objGLMatrix : ListGLMatrix){
                            mapNameGLMatrix.put(objGLMatrix.Name,objGLMatrix);      
                        }       
                        for(akritiv__Payment__c pay : Trigger.New){
                           // if(pay.Transaction_Type__c.equalsIgnoreCase('Account to Account Transfer') || pay.Transaction_Type__c.equalsIgnoreCase('Apply Cash')|| pay.Transaction_Type__c.equalsIgnoreCase('Advance') || pay.Transaction_Type__c.equalsIgnoreCase('Small Amount Write Off')|| pay.Transaction_Type__c.equalsIgnoreCase('Write Off')|| pay.Transaction_Type__c.equalsIgnoreCase('Write Back'))
                           // {
                                GL_Matrix_Config__c objGLMatrix = mapNameGLMatrix.get(pay.Transaction_Type__c);
                                if(objGLMatrix!= null)
                                {
                                    pay.Customer_Posting_Key__c = objGLMatrix.Customer_Posting_Key__c;
                                    pay.Document_Type__c = objGLMatrix.Document_Type__c;
                                    pay.Posting_Key__c = objGLMatrix.Posting_Key__c;
                                    //pay.Special_GL_Indicator__c = objGLMatrix.Special_GL_Indicator__c;
                                    pay.Account_Type__c = objGLMatrix.Account_Type__c;
                                    pay.Bank_GL_Code__c = objGLMatrix.Bank_GL_Code__c;
                                    pay.Profit_Center__c = objGLMatrix.Profit_Center__c;
                                }
                                
                           // }
                            
                    }
                    }
                }
        if(Trigger.isAfter){
            Set<Id> AccountId = new Set<Id>();
            if(Trigger.New != null){
                for(akritiv__Payment__c pay : Trigger.New){
                    AccountId.add(pay.akritiv__Account__c);
                }
                Map<Id,Account>  AccountMap = new Map<Id,Account>([select id,Total_Cheques_Bounced__c,Total_Advance__c from Account where id in : AccountId]);
                List<Account> accToUpdate = new List<Account>();
                Account acc = null;
                Map<Id,Account> newActMap = new Map<Id,Account>();
                akritiv__Payment__c LastPayment = null;
                
                for(akritiv__Payment__c pay : Trigger.New){
                    if(Trigger.isInsert){
                        LastPayment = pay;
                        if(acc == null){
                            acc = AccountMap.get(pay.akritiv__Account__c);
                        }
                        acc = AccountMap.get(pay.akritiv__Account__c);
                        
                        if(newActMap.Containskey(acc.Id)){
                            Account tmp = newActMap.get(acc.Id);
                            if(tmp.Total_Advance__c == null)
                                tmp.Total_Advance__c = 0;
                            tmp.Total_Advance__c = tmp.Total_Advance__c + pay.akritiv__Unapplied_Balance__c;
                            newActMap.put(tmp.id,tmp);
                        }else{
                            if(acc.Total_Advance__c == null)
                                acc.Total_Advance__c = 0;
                            acc.Total_Advance__c = acc.Total_Advance__c + pay.akritiv__Unapplied_Balance__c;
                            newActMap.put(acc.id,acc);
                        }
                    
                        if(acc.Total_Advance__c == null)
                            acc.Total_Advance__c = 0;
                   }
                if(Trigger.isUpdate){
                     acc = AccountMap.get(pay.akritiv__Account__c);
                     if(pay.Reason_Code__c == 'Bounced Cheque' && Trigger.OldMap.get(pay.Id).Reason_Code__c !=  'Bounced Cheque' ){
                         system.debug('---acc.Total_Cheques_Bounced__c ----'+acc.Total_Cheques_Bounced__c );
                         if(acc.Total_Cheques_Bounced__c == null){
                             acc.Total_Cheques_Bounced__c = 0;
                         }
                         system.debug('---acc.Total_Cheques_Bounced__c ----'+acc.Total_Cheques_Bounced__c );
                         acc.Total_Cheques_Bounced__c = acc.Total_Cheques_Bounced__c + 1;
                     }
                     akritiv__Payment__c  OldPayment = Trigger.old.get(0);
                     if(newActMap.Containskey(acc.Id)){
                        Account tmp = newActMap.get(acc.Id);
                        if(tmp.Total_Advance__c == null)
                            tmp.Total_Advance__c = 0;
                        if(pay.Reason_Code__c == 'Bounced Cheque' ){
                            if(OldPayment.Reason_Code__c != 'Bounced Cheque')
                                tmp.Total_Advance__c = (tmp.Total_Advance__c - OldPayment.akritiv__Unapplied_Balance__c);
                        }else{     
                            tmp.Total_Advance__c = (tmp.Total_Advance__c - OldPayment.akritiv__Unapplied_Balance__c) + pay.akritiv__Unapplied_Balance__c;
                        }
                        newActMap.put(tmp.id,tmp);
                    }else{
                        if(acc.Total_Advance__c == null)
                            acc.Total_Advance__c = 0;
                            
                        acc.Total_Advance__c = (acc.Total_Advance__c - OldPayment.akritiv__Unapplied_Balance__c) + pay.akritiv__Unapplied_Balance__c;
                        newActMap.put(acc.id,acc);
                    }
                    
                }
                
            
            }
          
            for(Id i : newActMap.keySet()) {
                accToUpdate.add(newActMap.get(i));
            }
            if(accToUpdate.size() > 0){
                update accToUpdate;
            }
            }
             
            
            if(Trigger.Old != null && Trigger.isDelete){
                for(akritiv__Payment__c pay : Trigger.Old){
                    system.debug('----pay.akritiv__Account__c----'+pay.akritiv__Account__c);
                    system.debug('----pay.Id----'+pay.Id);
                    AccountId.add(pay.akritiv__Account__c);
                }
                Map<Id,Account>  AccountMap = new Map<Id,Account>([select id,Total_Advance__c from Account where id in : AccountId]);
                List<Account> accToUpdate = new List<Account>();
                Account acc = null;
                Map<Id,Account> newActMap = new Map<Id,Account>();
               
                for(akritiv__Payment__c pay : Trigger.Old){
 
                if(acc == null){
                    acc = AccountMap.get(pay.akritiv__Account__c);
                }
                if(newActMap.Containskey(acc.Id)){
                        Account tmp = newActMap.get(acc.Id);
                        if(tmp.Total_Advance__c == null)
                            tmp.Total_Advance__c = 0;
                        tmp.Total_Advance__c = tmp.Total_Advance__c - pay.akritiv__Amount__c;
                        newActMap.put(tmp.id,tmp);
                }else{
                      if(acc.Total_Advance__c == null)
                            acc.Total_Advance__c = 0;
                        acc.Total_Advance__c = acc.Total_Advance__c - pay.akritiv__Amount__c;
                        newActMap.put(acc.id,acc);
                }
               
                if(acc.Total_Advance__c == null)
                    acc.Total_Advance__c = 0;
                    
                
                
            
            }
            
            for(Id i : newActMap.keySet()) {
                accToUpdate.add(newActMap.get(i));
            }
                    
             // update ac;
                
            if(accToUpdate.size() > 0){
                update accToUpdate;
            }
            }
        //if(Trigger.isInsert)
        
    }
    
     if(Trigger.isBefore && Trigger.isUpdate)
     {
        System.debug('>>>>>>>Trigger.isBefore Update Called');
        Set<Id> SetPaymentId1 = new Set<Id>();
        Set<Id> SetPaymentId2 = new Set<Id>();
        List<Id> ListPaymentsId = new List<Id>();
        //List<akritiv__Payment__c> ListPaymentsId = new List<akritiv__Payment__c>();
        List<akritiv__Payment__c> ListPaymentsToUpdate = new List<akritiv__Payment__c>();
        Map<Id, String> mapIdToPayRef = new Map<Id, String>();
        
        for (akritiv__Payment__c objPay : Trigger.new) 
        {
            akritiv__Payment__c objPayOld =  Trigger.oldMap.get(objPay.Id);
            
            // Set Original Document# Generated from SAP that required for cheque bounce reverse feed           
            if(objPayOld.Invoice_Key__c==null && objPay.Invoice_Key__c!=null)
            {
                objPay.Original_Document_Number__c = objPay.Payment_Ref__c;               
            }
            
            // Prevent Credit Note to Update if type change to another
            if(objPayOld.Transaction_Code__c=='Credit note' && objPay.Transaction_Code__c!='Credit note')
            {
                objPay.Transaction_Code__c = 'Credit note';
            }
            
            // Prevent updation with null if already confirm from external source available //18112013
             if(objPayOld.Sent_To_External_Source_On__c!=null && objPay.Sent_To_External_Source_On__c==null)
            {
                if(objPay.Confirmed_By_External_Source_On__c!=null)
                {
                    objPay.Sent_To_External_Source_On__c = objPay.Confirmed_By_External_Source_On__c;
                }
            }
            
            if(objPayOld.Confirmed_By_External_Source_On__c==null && objPay.Confirmed_By_External_Source_On__c!=null && objPay.Transaction_Type__c!= null && objPay.Transaction_Type__c.trim() == 'Account to Account Transfer' )
            {
                if(SetPaymentId1.Add(objPay.Id))
                {
                    if(objPay.Transferred_From_Payment__c!=null)
                    {
                        mapIdToPayRef.put(objPay.Transferred_From_Payment__c,objPay.Payment_Ref__c);
                        ListPaymentsId.Add(objPay.Transferred_From_Payment__c);
                    }
                }
            }
        }
        if(ListPaymentsId.size() > 0){
            ListPaymentsToUpdate = [SELECT Id,Payment_Ref__c FROM akritiv__Payment__c WHERE ID IN:ListPaymentsId];
        }
        if(ListPaymentsToUpdate!= null && ListPaymentsToUpdate.size() > 0)
        {
            for(akritiv__Payment__c objPayment :ListPaymentsToUpdate)
            {
                objPayment.Payment_Ref__c = mapIdToPayRef.get(objPayment.Id);
            }
        }
        Update ListPaymentsToUpdate;
    }
    }*/
        if(Trigger.isAfter)
        {
            system.debug('==> Payment After Trigger <===');
            set<Id> ClientAccountSet = new Set<Id>();
            Set<Id> DebtorIDset = new Set<Id>();
            Map<Id, akritiv__Payment__c> PaymentMap= new Map<Id, akritiv__Payment__c>();
            if(Trigger.isUpdate || Trigger.isInsert)
            {
                for(akritiv__Payment__c pay : Trigger.New){
                    ClientAccountSet.add(pay.Client_Account__c);
                    if(pay.Debtor__c != NULL)
                    {
                        DebtorIDset.add(pay.Debtor__c);
                    }
                    if(Pay.Payment_Status__c =='Applied - Processing')
                        PaymentMap.put(Pay.id,Pay);
                }
           //=====Updating the related Tasks when Payment Status is Applied. Addded by Kanakaraju================ 
           // Map<Id, akritiv__Payment__c> PaymentMap= new Map<Id, akritiv__Payment__c>([select id,Payment_Status__c from akritiv__Payment__c where id in:Trigger.newMap.keyset()]);
            
                if(PaymentMap.keySet().size() > 0)
                {
                    Map<Id, Task> taskMap= new Map<Id, Task>([select Whatid,status from task where Whatid in : Trigger.newMap.keyset()]);
                    
                    if(taskMap.size() > 0)
                    {
                        for(Task currentTask : taskMap.values())
                        {
                            if(PaymentMap.get(currentTask.Whatid).Payment_Status__c=='Applied - Processing' )
                            {
                                currentTask.status = 'Completed';
                            }
                        }
                        update taskMap.values();
                    }
                }

            //==============end task logic  
                if(Trigger.isUpdate)
                { //system.debug('==> Payment after update <===');
                    set<String> paymentId_toupdate_paymentlineitem_flag_set = new Set<string>();
                    for(akritiv__Payment__c pay : Trigger.New)
                    {//system.debug('==> 2 <==='+Trigger.oldMap.get(pay.Id).Payment_Status__c);system.debug('==> 3 <==='+pay.Payment_Status__c);
                        if(Trigger.oldMap.get(pay.Id).Payment_Status__c == 'Applied - No Funds' && pay.Payment_Status__c == 'Applied - Processing')
                        {//system.debug('==> 1 <===');                                                                       
                            paymentId_toupdate_paymentlineitem_flag_set.add(pay.id);
                           
                        }
                    }
                    if(paymentId_toupdate_paymentlineitem_flag_set.size() > 0)
                    {
                        system.debug('===>paymentId_toupdate_paymentlineitem_flag_set '+ paymentId_toupdate_paymentlineitem_flag_set.size());
                        List<akritiv__Payment_Line__c> PaymentLineItemList = [Select id,Flag_for_Line_Amount__c,akritiv__Payment__c from akritiv__Payment_Line__c where akritiv__Payment__c in: paymentId_toupdate_paymentlineitem_flag_set];
                        
                        List<akritiv__Payment_Line__c> List_paymentLine_toupdate = new List<akritiv__Payment_Line__c>();
                        for(string paymentid : paymentId_toupdate_paymentlineitem_flag_set)
                        {
                            for(akritiv__Payment_Line__c PLIT : PaymentLineItemList)
                            {
                                if(PLIT.akritiv__Payment__c == paymentid)
                                {
                                    PLIT.Flag_for_Line_Amount__c = False;
                                    List_paymentLine_toupdate.add(PLIT);
                                }
                            }
                        }
                        if(List_paymentLine_toupdate.size() > 0)
                        {
                            update List_paymentLine_toupdate;
                        }
                    }
                    
                }
            }
            // when deleting the payment
            if(Trigger.isDelete)
            {
                for(akritiv__Payment__c pay : Trigger.old){
                    ClientAccountSet.add(pay.Client_Account__c);
                    if(pay.Debtor__c != NULL)
                    {
                        DebtorIDset.add(pay.Debtor__c);
                    }
                }
            }
            Map<String,Double> debtor_paymentamount = new Map<String,Double>();
            Map<string,Double> Paymentcountfor_TransactionGrid = new Map<string,Double>();
            Map<string,Double> Paymentcountfor_PaymentGrid = new Map<string,Double>();
            for(AggregateResult payments : [select COUNT(id) IC,Client_Account__c clientaccount,SUM(Payment_internex__c) Pmnts 
                                            from akritiv__Payment__c where Client_Account__c in : ClientAccountSet and (Transaction_Type__c =: 'Write Off' and Debtor__c =: NULL) and (Payment_Status__c =: 'Applied - Processed' or Payment_Status__c =: 'Partially Applied') group by Client_Account__c])//akritiv__Amount__c
            {//Payment_internex__c
                debtor_paymentamount.put((Id)payments.get('clientaccount'),(Double)payments.get('Pmnts'));
            }
            for(AggregateResult payments : [select COUNT(id) IC,Debtor__c Debtor
                                            from akritiv__Payment__c where Debtor__c in : DebtorIDset and Send_to_Portal_Payment__c =: True group by Debtor__c])
            {
                Paymentcountfor_PaymentGrid.put((Id)payments.get('Debtor'),(Double)payments.get('IC'));
            }
            for(AggregateResult payments : [select COUNT(id) IC,Debtor__c Debtor
                                            from akritiv__Payment__c where Debtor__c in : DebtorIDset and Send_to_Portal_Transactions__c =: True group by Debtor__c])
            {
                Paymentcountfor_TransactionGrid.put((Id)payments.get('Debtor'),(Double)payments.get('IC'));
            }
            
            List<Debtor__c> Debtor_list_toUpdate = new List<Debtor__c>();
            for(Debtor__c Deb : [Select id, Payment_Count_to_send_Transaction_Grid__c,Payment_Count_to_send_Portal_payments__c 
                                 from Debtor__c where id in: DebtorIDset])
            {
                Deb.Payment_Count_to_send_Transaction_Grid__c = Paymentcountfor_TransactionGrid.get(Deb.Id);
                Deb.Payment_Count_to_send_Portal_payments__c = Paymentcountfor_PaymentGrid.get(Deb.Id);
                Debtor_list_toUpdate.add(Deb);
            }
            
            List<Client_Account__c> ClientAccount_list_toUpdate = new List<Client_Account__c>();
            for(Client_Account__c CA : [Select id,name,Payments__c,IUF_Reserve_Retained__c,IUF_from_Payment__c From Client_Account__c where id in : ClientAccountSet])
            {
                CA.Payments__c =  debtor_paymentamount.get(CA.ID);
                ClientAccount_list_toUpdate.add(CA);
            }
            update ClientAccount_list_toUpdate;
            update Debtor_list_toUpdate;
                        
        }
        //=============== Added by Dheeraj ===============//
        if(Trigger.isBefore)
        {
            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
            
            if(Trigger.isUpdate || Trigger.isInsert)
            {
                set<string> Debtor_Set = New Set<String>();
                for(akritiv__Payment__c pay : Trigger.New){
                    if(BsnsTransact != Null && Trigger.isInsert)
                    {
                        Pay.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                    }
                    if(pay.Debtor__c != NULL )
                    {
                        if(Trigger.isInsert || (Trigger.IsUpdate && pay.Client_Account__c == NULL))
                            Debtor_Set.add(pay.Debtor__c); 
                    }

                }
                if(Debtor_Set.size() > 0)
                {
                    map<string,Debtor__c> Debtormap = new map<string,Debtor__c>([Select id,Client_Account__c,Counterparty__c from Debtor__c where id in : Debtor_Set]);
                    if(Debtormap != Null)
                    {
                        for(akritiv__Payment__c pay : Trigger.New)
                        {
                            if(Debtormap.get(pay.Debtor__c) != NULL)
                            {
                                //     if(pay.Client_Account__c == NULL)
                                //     {
                                pay.Client_Account__c = Debtormap.get(pay.Debtor__c).Client_Account__c;
                                if(Trigger.isInsert)
                                    pay.akritiv__Account__c = Debtormap.get(pay.Debtor__c).Counterparty__c;
                                //    }
                            }
                        }
                    }
                }
            }
            if(Trigger.IsUpdate)
            {
           //     profile p = [select id from profile where name = 'Integration Admin'];
           //     system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
           //     if(p.Id != userinfo.getProfileId())
           //     {
                    for(akritiv__Payment__c payment : Trigger.New)
                    {
                        if(payment.Profile_Name__c != 'Integration Admin')
                        {
                            payment.Sync_with_Grade__c = False;
                            payment.Sync_with_Market_Place__c = False;
                            payment.Sync_with_Portal__c = False;
                        }
                    }
        
           //     }
            }
        }
        //=============== End by Dheeraj=========//
//    checkRecursive.run = false;
//  }
    }Catch(Exception ex)
    {
       system.debug('---Error occur in before insert payment----'+ex);
    }
}