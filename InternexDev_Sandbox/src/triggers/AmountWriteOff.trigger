trigger AmountWriteOff on akritiv__Transaction__c (Before insert,Before Update,After update,After insert,After Delete){
    if(Trigger.IsAfter)
    {
        System.debug('##### Amount Write Off After trigger is called...!!');
        //    if(akritiv__Trigger_Configuration__c.getOrgDefaults().Amount_WriteOff__c){
      /*  if(checkRecursive.run){
            IF(Trigger.isUpdate){
                List<akritiv__Payment_Line__c> lstPaymentLines = new List<akritiv__Payment_Line__c>();
                List<ID> lstAccountId = new List<ID>();
                List<Account> objSuspenseAccount = new List<Account>();
                Map<String, ID> paymentAccountMap = new Map<String, ID>();
                List<akritiv__Transaction__c> lstTransactions = new List<akritiv__Transaction__c>();
                List<akritiv__Transaction__c> lstTransactionsUpdate = new List<akritiv__Transaction__c>();
                akritiv__Payment_Line__c objPaymentLine = new akritiv__Payment_Line__c();
                Double difference = akritiv__SysConfig_Singlec__c.getOrgDefaults().Auto_Discount_Range__c;
                Double minor = akritiv__SysConfig_Singlec__c.getOrgDefaults().Auto_Discount_Write_Off__c;
                Double maximum = akritiv__SysConfig_Singlec__c.getOrgDefaults().Auto_Minor_Write_Off__c;
                //            List<GL_Account_Mapping__c> lstOfGLAccountMapping = GL_Account_Mapping__c.getAll().values();
                //            System.debug('-----GL Account Mapping----'+lstOfGLAccountMapping);
                Double remainBal = 0.0;
                akritiv__Transaction__c inv;
                System.debug('### Min Value : '+minor+' and Maximum Percentage : '+maximum+' and difference : '+difference);
                for (akritiv__Transaction__c trans : Trigger.new){
                    //         remainBal = (100-trans.Balance_Remaining__c);
                    inv = new akritiv__Transaction__c(id = trans.id, name = trans.name);
                    remainBal = trans.Balance_Remaining__c;
                    System.debug(' Invoice : '+trans.name+' and remaining balance : '+trans.Balance_Remaining__c+' and old balance :'+Trigger.oldMap.get(trans.id).Akritiv__Balance__c);
                    System.debug('------remainBal ----'+remainBal);
                    System.debug('------maximum----'+maximum);
                    System.debug('------trans.akritiv__Balance__c----'+trans.akritiv__Balance__c);
                    
                    
                    IF((remainBal >= (0-maximum) && remainBal <= maximum && remainBal != 0 ) || (trans.akritiv__Balance__c > -10 && trans.akritiv__Balance__c < 10 && trans.akritiv__Balance__c != 0)){
                        inv.Balance_written_off__c = trans.akritiv__Balance__c;
                        lstTransactions.add(trans);
                        //                   lstTransactionsUpdate.add(inv);
                        lstAccountId.add(trans.Akritiv__Account__c);
                    }
                }
                System.debug('### Invoices List size - '+lstTransactions.size()+' and account list size - '+lstAccountId.size());
          //      WebCash_Load_Batch__c webCashLoadBatch = [Select ID, name from WebCash_Load_Batch__c order by SystemModstamp desc limit 1];
          //      System.debug('---------webCashLoadBatch----- from amount write off trigger >>> '+webCashLoadBatch);
                //       List<Akritiv__Payment__c> lstPayment = [SELECT ID, akritiv__Account__c from Akritiv__Payment__c where akritiv__Account__c IN:lstAccountId];
                List<Akritiv__Payment__c> lstPayment = new List<Akritiv__Payment__c>();
                
           //     String paymentAccountId = '';
                String strSuspenseAccountKey = WebCash_Configuration__c.getOrgDefaults().Suspense_Acccount_Key__c;
                system.debug('==> '+ strSuspenseAccountKey); */
            /*    if(strSuspenseAccountKey!=null && strSuspenseAccountKey!=''){
                    objSuspenseAccount = [SELECT Id,Name FROM Account WHERE akritiv__Account_Key__c=:strSuspenseAccountKey LIMIT 1];
                    paymentAccountId = objSuspenseAccount.get(0).id;
                    //            paymentAccountName = objSuspenseAccount.get(0).Name;
                } */
                
           /*     Akritiv__Payment__c payment = new Akritiv__Payment__c();
                if(lstTransactions.size() > 0){
                    FOR(akritiv__Transaction__c trx :lstTransactions){
                        payment = new Akritiv__Payment__c();
                        payment.name = 'Writeoff'+trx.ID;
                        payment.akritiv__Account__c = trx.Akritiv__Account__c;
                        payment.akritiv__Amount__c = trx.akritiv__Balance__c;
                  //      payment.batch_Number__c = webCashLoadBatch.id;
                        payment.Transaction_Type__c = 'Write Off';
                        lstPayment.add(payment);
                    }
                }
           //     System.debug('### Payment Account ID :'+paymentAccountId);
                IF(lstPayment.size() > 0){ */
                    /*               insert lstPayment;
System.debug('#### Payment List Size : '+lstPayment.size());
FOR(Akritiv__Payment__c pay : lstPayment){
paymentAccountMap.put(pay.name, pay.ID);
}*/
               /*     GL_Account_Mapping__c objGLAccMapping;
                    for(akritiv__Transaction__c trx : lstTransactions){
                        //            remainBal = (100-trx.Balance_Remaining__c);
                        objGLAccMapping = new GL_Account_Mapping__c();
                        remainBal = trx.Balance_Remaining__c;
                        objPaymentLine = new akritiv__Payment_Line__c();
                        objPaymentLine.Transaction_Type__c = 'Write Off';
                        objPaymentLine.akritiv__Applied_To__c = trx.id;
                        //                  objPaymentLine.akritiv__Payment__c = paymentAccountMap.get('Writeoff'+trx.id);
                        objPaymentLine.akritiv__Applied_Amount__c = trx.akritiv__Balance__c;
                        system.debug('########## remainBal : '+remainBal+'\n and Invoice Balance : '+trx.akritiv__Balance__c+'\n Negative Minor - diff '+((-1*minor)-difference)+'\n Minor - Diff : '+(minor-difference)+'\n negative minor + DIff : '+((-1*minor)+difference));
                        if(remainBal >= ((-1*minor)-difference)){
                            system.debug('Remaining balance is greater than negative');
                        }
                        if(remainBal <= (-1*minor)+difference){
                            system.debug('Remaining balance is less than negative');
                        }
                        if(remainBal >= (minor-difference)){
                            system.debug('Remaining balance is greater than positive');
                        }
                        if(remainBal <= (minor+difference)){
                            system.debug('Remaining balance is less than positive');
                        }
                        if((remainBal >= (minor-difference) && remainBal <= (minor+difference)) || (remainBal >= ((-1*minor)-difference) && remainBal <= ((-1*minor)+difference))){
                            System.debug('AUUUUUUUUUUUTO DISCCCOUUUUUUUUUUNT...');
                            objPaymentLine.Reason_Code__c = 'Auto Early Pay Discount';
                            objGLAccMapping = GL_Account_Mapping__c.getValues(objPaymentLine.Reason_Code__c);
                            objPaymentLine.GL_Account_Name__c = objGLAccMapping.Account_Name__c;
                            objPaymentLine.GL_Account_Number__c = objGLAccMapping.Account_Number__c;
                            lstPaymentLines.add(objPaymentLine);
                        }else if((remainBal >= (0-maximum) && remainBal <= maximum && remainBal != 0) && (trx.akritiv__Balance__c > -10 && trx.akritiv__Balance__c < 10 && trx.akritiv__Balance__c != 0)){
                            System.debug('AUTO MINOR Write off');
                            objPaymentLine.Reason_Code__c = 'Auto Minor Write Off';
                            objGLAccMapping = GL_Account_Mapping__c.getValues(objPaymentLine.Reason_Code__c);
                            objPaymentLine.GL_Account_Name__c = objGLAccMapping.Account_Name__c;
                            objPaymentLine.GL_Account_Number__c = objGLAccMapping.Account_Number__c;
                            lstPaymentLines.add(objPaymentLine);
                        }
                    }
                    if(lstPaymentLines.size() > 0){
                     //   insert lstPayment;
                        System.debug('#### Payment List Size : '+lstPayment.size());
                        for(Akritiv__Payment__c pay : lstPayment){
                            paymentAccountMap.put(pay.name, pay.ID);
                        }
                        for(akritiv__Payment_Line__c payLine : lstPaymentLines){
                            payLine.akritiv__Payment__c = paymentAccountMap.get('Writeoff'+payLine.akritiv__Applied_To__c);
                        }
                    //    insert lstPaymentLines;
                    }
                    System.debug('$$$$$ Payment Lines Size - '+lstPaymentLines.size());
                    //               UPDATE lstTransactionsUpdate;
                }
            }
            checkRecursive.run = false;
        }*/
        
        try
        {
            //=============== Adding the logic by Dheeraj to update the rollup summery operation on Clientproductdebtor object ===========//
            //Creating the set of Client_Product_Debtor__c To avoid the duplicate elements
            set<ID> Debtorset = new Set<ID>();
            set<Id> InvoicesId_set = new Set<Id>();
            map<string,akritiv__Transaction__c> batchidsmap = new map<string,akritiv__Transaction__c>();
            //When adding new Invoices or updating existing Invoices
            if(Trigger.isUpdate || Trigger.isInsert)
            {        
                for(akritiv__Transaction__c Invoice : Trigger.new)
                {
                    Debtorset.add(Invoice.Debtor__c);
                    InvoicesId_set.add(Invoice.Id);
                    if(Trigger.isInsert)
                        batchidsmap.put(Invoice.Client_Name_for_email_alert__c+'-'+Invoice.akritiv__Batch_Number__c,Invoice);
                }
                if(batchidsmap.keySet().size() > 0)
                {
                    Map<string,WebCash_Load_Batch__c> LWC = new Map<string,WebCash_Load_Batch__c>();
                    for(WebCash_Load_Batch__c LCE:[select id,Name from WebCash_Load_Batch__c where Name In : batchidsmap.keySet()]){
                        LWC.put(LCE.Name, LCE);
                        
                    }
                    list<WebCash_Load_Batch__c> wC = new list<WebCash_Load_Batch__c>();
                    
                    for(akritiv__Transaction__c Invoice : batchidsmap.values())
                    {
                        if(!LWC.containsKey(Invoice.Client_Name_for_email_alert__c+'-'+Invoice.akritiv__Batch_Number__c))
                        {
                            WebCash_Load_Batch__c LC = new WebCash_Load_Batch__c();
                            LC.Name = Invoice.Client_Name_for_email_alert__c+'-'+Invoice.akritiv__Batch_Number__c;
                            Lc.Client_Account_Name__c=Invoice.Client_Account_Name_for_Email_Alert__c;
                            LC.Client_Name__c=invoice.Client_Name_for_email_alert__c;
                            
                            wC.add(LC);
                        }
                        
                    }
                    if(wC.size()>0)
                    {
                        insert wC;
                    }
                }
            }
            
            // when deleting the Invoices
            if(Trigger.isDelete)
            {
                for(akritiv__Transaction__c Invoice : Trigger.old)
                {
                    Debtorset.add(Invoice.Debtor__c);
                    InvoicesId_set.add(Invoice.Id);
                }
            }

            Map<String,Double> debtormap_InvoiceCount = new Map<string,Double>();
            Map<String,Double> debtormap_Invoiceamnt = new Map<string,Double>();
            Map<String,Double> debtormap_Ineligibleamnt = new Map<string,Double>();
            Map<String,Double> debtormap_Ineligibletype1 = new Map<string,Double>();
            Map<String,Double> debtormap_Ineligibletype2 = new Map<string,Double>();
            Map<String,Double> debtormap_paymentsamnt = new Map<string,Double>();
                
            //Produce a sum of Invoices and add them to the map
            for(AggregateResult INV : [select COUNT(id) IC,Debtor__c Debtor,sum(Balance_Internex__c) amt,SUM(Tran_DT_Gt_90D_Plus_Inv_Date__c) Ineligibletype1,SUM(Tran_DT_Gt_CPD_Plus_Inv_Date__c) Ineligibletype2,
                                       SUM(Ineligibles_Amount__c) Ineligibleamnt,SUM(Sum_of_Payments__c) Payments from akritiv__Transaction__c where Debtor__c IN : Debtorset group by Debtor__c])//akritiv__Amount__c
            {
                debtormap_InvoiceCount.put((Id)INV.get('Debtor'),(Double)INV.get('IC'));
                debtormap_Invoiceamnt.put((Id)INV.get('Debtor'),(Double)INV.get('amt'));
                debtormap_Ineligibleamnt.put((Id)INV.get('Debtor'),(Double)INV.get('Ineligibleamnt'));
                debtormap_Ineligibletype1.put((Id)INV.get('Debtor'),(Double)INV.get('Ineligibletype1'));
                debtormap_Ineligibletype2.put((Id)INV.get('Debtor'),(Double)INV.get('Ineligibletype2'));
                debtormap_paymentsamnt.put((Id)INV.get('Debtor'),(Double)INV.get('Payments'));
            }
          //   system.debug('debtormap_Invoiceamnt==> '+debtormap_Invoiceamnt);
            
            Map<String,Double> debtormap_InvoiceCount_for_sendingportal = new Map<string,Double>();
            for(AggregateResult INV : [select COUNT(id) ICT,Debtor__c Debtor from akritiv__Transaction__c where ( Debtor__c IN : Debtorset and Send_to_Portal__c =: True) group by Debtor__c])
            {
                debtormap_InvoiceCount_for_sendingportal.put((Id)INV.get('Debtor'),(Double)INV.get('ICT'));
            }
            
            List<akritiv__Transaction__c> InvoiceList = [Select id,Due_Days__c,Debtor__c,akritiv__Amount__c,Balance_Internex__c,Invoice_Status_Internex__c,Invoice_Dilution__c,Invoice_Status__c,Closed_Invoice_Age__c from akritiv__Transaction__c where Debtor__c in : Debtorset];//
                                                                                    
            List<Debtor__c> Debtor_list_toUpdate = new List<Debtor__c>();
            //Get the sum value from the map and create a list of Debtorset to update

            for(Debtor__c Debtor : [Select Id, Invoice_Count__c,Invoice_Count_for_Sending_Portal__c,Invoice_Amount__c,Ineligibles_Type1__c,Ineligibles_Type2__c,Ineligibles_Amount__c,Sum_of_Payments__c,
                                    Closed_Invoice_Amounts_12_months__c,Closed_Invoice_Amounts_1_months__c,Closed_Invoice_Amounts_3_months__c,  Closed_Invoice_Amounts_6_months__c, Dilution_Amount_12_Month__c,
                                    Dilution_Amount_1_Month__c,Dilution_Amount_3_Month__c,Dilution_Amount_6_Month__c,Open_Invoice_Dilution_12_Months__c,Open_Invoice_Dilution_1_Months__c,Open_Invoice_Dilution_3_Months__c,
                                    Open_Invoice_Dilution_6_Months__c,Current__c,X1_15__c,X16_30__c,X31_60__c,X61_90__c,X90__c from Debtor__c where Id IN :Debtorset]) 
            {
                Debtor.Invoice_Count__c = debtormap_InvoiceCount.get(Debtor.ID);
                Debtor.Invoice_Count_for_Sending_Portal__c = debtormap_InvoiceCount_for_sendingportal.get(Debtor.ID);
                Debtor.Invoice_Amount__c = debtormap_Invoiceamnt.get(Debtor.Id);
                Debtor.Ineligibles_Amount__c = debtormap_Ineligibleamnt.get(Debtor.Id);
                Debtor.Ineligibles_Type1__c = debtormap_Ineligibletype1.get(Debtor.Id);
                Debtor.Ineligibles_Type2__c = debtormap_Ineligibletype2.get(Debtor.Id);
                Debtor.Sum_of_Payments__c = debtormap_paymentsamnt.get(Debtor.Id);
                Decimal InvoiceTotal_Current = 0.0,InvoiceTotal_1to15 = 0.0,InvoiceTotal_16to30 = 0.0,InvoiceTotal_31to60 = 0.0;
                Decimal InvoiceTotal_61to90 = 0.0,InvoiceTotal_90above = 0.0;
                Decimal ClosedInvoiceTotal_12 = 0.0,ClosedInvoiceTotal_6 = 0.0,ClosedInvoiceTotal_3 = 0.0,ClosedInvoiceTotal_1 = 0.0;
                Decimal OpenInvoiceDilution_12 = 0.0,OpenInvoiceDilution_6 = 0.0,OpenInvoiceDilution_3 = 0.0,OpenInvoiceDilution_1 = 0.0;
                Decimal InvoiceDilution_12 = 0.0,InvoiceDilution_6 = 0.0,InvoiceDilution_3 = 0.0,InvoiceDilution_1 = 0.0;
              //  system.debug('InvoiceList' + InvoiceList);
                for(akritiv__Transaction__c INV : InvoiceList)
                {
                    if(INV.Debtor__c == Debtor.Id)
                    {
                        if(INV.Due_Days__c <= 0)
                        {
                            InvoiceTotal_Current += INV.Balance_Internex__c;
                        }
                        else if(INV.Due_Days__c >= 1 && INV.Due_Days__c <= 15)
                        {
                            InvoiceTotal_1to15 += INV.Balance_Internex__c;
                        }
                        else if(INV.Due_Days__c >= 16 && INV.Due_Days__c <= 30)
                        {
                            InvoiceTotal_16to30 += INV.Balance_Internex__c;
                        }
                        else if(INV.Due_Days__c >= 31 && INV.Due_Days__c <= 60)
                        {
                            InvoiceTotal_31to60 += INV.Balance_Internex__c;
                        }
                        else if(INV.Due_Days__c >= 61 && INV.Due_Days__c <= 90)
                        {
                            InvoiceTotal_61to90 += INV.Balance_Internex__c;
                        }
                        else
                        {
                            InvoiceTotal_90above += INV.Balance_Internex__c;
                        }

                        system.debug('INV.Invoice_Dilution__c' + INV.Invoice_Dilution__c);
                        Decimal InvoiceDilution = 0.0;
                        if(INV.Invoice_Dilution__c != NULL)
                            InvoiceDilution = INV.Invoice_Dilution__c; 
                        if(INV.Closed_Invoice_Age__c <= 365)
                        {
                            InvoiceDilution_12 += InvoiceDilution;
                            if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                                ClosedInvoiceTotal_12 += INV.akritiv__Amount__c;
                            if(INV.Invoice_Status__c == 'Open')
                                OpenInvoiceDilution_12 += InvoiceDilution;
                           // system.debug('INV' + INV);
                        }
                        if(INV.Closed_Invoice_Age__c <= 180)
                        {
                            InvoiceDilution_6 += InvoiceDilution;
                            if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                                ClosedInvoiceTotal_6 += INV.akritiv__Amount__c;
                            if(INV.Invoice_Status__c == 'Open')
                                OpenInvoiceDilution_6 += InvoiceDilution;
                            //system.debug('INV' + INV);
                        }
                        if(INV.Closed_Invoice_Age__c <= 90)
                        {
                            InvoiceDilution_3 += InvoiceDilution;
                            if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                                ClosedInvoiceTotal_3 += INV.akritiv__Amount__c;
                            if(INV.Invoice_Status__c == 'Open')
                                OpenInvoiceDilution_3 += InvoiceDilution;
                            //system.debug('INV' + INV);
                        }
                        if(INV.Closed_Invoice_Age__c <= 30)
                        {
                            InvoiceDilution_1 += InvoiceDilution;
                            if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                                ClosedInvoiceTotal_1 += INV.akritiv__Amount__c;
                            if(INV.Invoice_Status__c == 'Open')
                                OpenInvoiceDilution_1 += InvoiceDilution;
                            //system.debug('INV' + INV);
                        } 
                    }
                }
                Debtor.Current__c = InvoiceTotal_Current;
                Debtor.X1_15__c = InvoiceTotal_1to15;
                Debtor.X16_30__c = InvoiceTotal_16to30;
                Debtor.X31_60__c = InvoiceTotal_31to60;
                Debtor.X61_90__c = InvoiceTotal_61to90;
                Debtor.X90__c = InvoiceTotal_90above;

                Debtor.Closed_Invoice_Amounts_12_months__c = ClosedInvoiceTotal_12;
                Debtor.Closed_Invoice_Amounts_1_months__c = ClosedInvoiceTotal_1;
                Debtor.Closed_Invoice_Amounts_3_months__c = ClosedInvoiceTotal_3;
                Debtor.Closed_Invoice_Amounts_6_months__c = ClosedInvoiceTotal_6;
                Debtor.Dilution_Amount_12_Month__c = InvoiceDilution_12;
                Debtor.Dilution_Amount_1_Month__c = InvoiceDilution_1;
                Debtor.Dilution_Amount_3_Month__c = InvoiceDilution_3;
                Debtor.Dilution_Amount_6_Month__c = InvoiceDilution_6;
                Debtor.Open_Invoice_Dilution_12_Months__c = OpenInvoiceDilution_12;
                Debtor.Open_Invoice_Dilution_1_Months__c = OpenInvoiceDilution_1;
                Debtor.Open_Invoice_Dilution_3_Months__c = OpenInvoiceDilution_3;
                Debtor.Open_Invoice_Dilution_6_Months__c = OpenInvoiceDilution_6;
                
            //    system.debug('Debtor' + Debtor);
                Debtor_list_toUpdate.add(Debtor);

            }
          //  system.debug('Debtor_list_toUpdate==> '+Debtor_list_toUpdate);
            Update Debtor_list_toUpdate;
            update [Select Id, Invoice_Count__c,Invoice_Count_for_Sending_Portal__c,Invoice_Amount__c,Ineligibles_Type1__c,Ineligibles_Type2__c,Ineligibles_Amount__c,Sum_of_Payments__c,
                                    Closed_Invoice_Amounts_12_months__c,Closed_Invoice_Amounts_1_months__c,Closed_Invoice_Amounts_3_months__c,  Closed_Invoice_Amounts_6_months__c, Dilution_Amount_12_Month__c,
                                    Dilution_Amount_1_Month__c,Dilution_Amount_3_Month__c,Dilution_Amount_6_Month__c,Open_Invoice_Dilution_12_Months__c,Open_Invoice_Dilution_1_Months__c,Open_Invoice_Dilution_3_Months__c,
                                    Open_Invoice_Dilution_6_Months__c,Current__c,X1_15__c,X16_30__c,X31_60__c,X61_90__c,X90__c from Debtor__c where Id IN :Debtorset];
            
            //========= End of logic which is added by Dheeraj ===========================================================//
        }
        catch(Exception e){system.debug('exception e '+ e);}
    }
    if(Trigger.IsBefore)
    {
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        set<String> Debtor_ID = new Set<String>();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(akritiv__Transaction__c Inv : Trigger.New)
            {
                if(BsnsTransact != Null && Trigger.isInsert)
                {
                    Inv.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                    if(Inv.akritiv__Batch_Number__c == NULL)
                        Inv.akritiv__Batch_Number__c = String.valueof(BsnsTransact.Business_Transaction_Date__c);
                } 
                if(INV.Invoice_Dilution__c == NULL)
                    INV.Invoice_Dilution__c = 0; 
                if (Inv.Closed_Invoice_with_Balance__c == True && Trigger.oldMap.get(Inv.Id).Closed_Invoice_with_Balance__c != True) //&& (Inv.Invoice_Dilution__c == NULL || Inv.Invoice_Dilution__c == 0.00)
                {
                 system.debug('===> Invoice Balance' +Inv.akritiv__Balance__c);
                    Inv.Invoice_Dilution__c = Inv.Invoice_Dilution__c + Inv.akritiv__Balance__c;
                }
                if(Inv.Sum_of_Writeoff_amount__c > 0 && Trigger.oldMap.get(Inv.Id).Sum_of_Writeoff_amount__c != Inv.Sum_of_Writeoff_amount__c )
                {
                    Inv.Invoice_Dilution__c = Inv.Invoice_Dilution__c + Inv.Sum_of_Writeoff_amount__c;
                }
                system.debug('INV.Invoice_Dilution__c' + INV.Invoice_Dilution__c);
                Inv.akritiv__Balance__c = Inv.Balance_Internex__c;
                if(Inv.Invoice_Status__c == 'Closed' && Inv.Invoice_Status_Internex__c == 'Approved')
                {
                    if(BsnsTransact != Null && Inv.akritiv__Close_Date__c == NULL)
                    {
                        Inv.akritiv__Close_Date__c = BsnsTransact.Business_Transaction_Date__c;
                    }
                }
                if(Trigger.isInsert)
                {
                    Debtor_ID.add(Inv.Debtor__c);
                }
                system.debug('==> AWF '+Debtor_ID);
            }
            if(Trigger.isInsert)
            {
                map<string,Debtor__c> Debtor_map = New map<String,Debtor__c>([Select id,Counterparty__c,Max_Credit_Period__c from Debtor__c where id in : Debtor_ID]);
                 system.debug('==> Debtor_map '+Debtor_map);
                for(akritiv__Transaction__c Inv : Trigger.New)
                {
                    if(Debtor_map != NULL && Debtor_map.containsKey(Inv.Debtor__c))
                    {
                        INV.akritiv__Account__c = Debtor_map.get(Inv.Debtor__c).Counterparty__c;
                        INV.Max_Credit_Period__c = Debtor_map.get(Inv.Debtor__c).Max_Credit_Period__c;
                    }
                }
            }
        }
            if(Trigger.IsUpdate)
            {
          //      profile p = [select id from profile where name = 'Integration Admin'];
          //      system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
          //      if(p.Id != userinfo.getProfileId())
           //     {
                    for(akritiv__Transaction__c Invoice : Trigger.New)
                    {
                        if(Invoice.Profile_Name__c != 'Integration Admin')
                        {
                            Invoice.Sync_with_Grade__c = False;
                            Invoice.Sync_with_Market_Place__c = False;
                            Invoice.Sync_with_Portal__c = False;
                        }
                    }
          //      }
            }
    }
}