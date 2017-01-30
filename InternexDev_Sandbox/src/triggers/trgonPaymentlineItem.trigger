trigger trgonPaymentlineItem on akritiv__Payment_Line__c (before Insert,before update,after Insert,After Update,After Delete) {
    Map<String,Double> MapFIU= new Map<String,Double>();
    if(Trigger.isBefore)
    {    
        system.debug('==> Payment Line Items Before Trigger <===');
        set<string> InvoicePortalExternalId = new Set<String>();
        set<string> PaymentPortalExternalId = new Set<String>();
        set<String> PaymentIDS = new Set<String>();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(akritiv__Payment_Line__c PLit : Trigger.New)
            {
                if(PLit.Invoice_Portal_External_ID__c != NULL)
                {
                    InvoicePortalExternalId.add(PLit.Invoice_Portal_External_ID__c);
                }
                if(PLit.Payment_Portal_External_ID__c != NULL)
                {
                    PaymentPortalExternalId.add(PLit.Payment_Portal_External_ID__c );
                }
                PaymentIDS.add(Plit.akritiv__Payment__c);
                
                BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
                if(BsnsTransact != Null && Trigger.isInsert)
                {
                    Plit.akritiv__Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
            }
 
            if(Trigger.isUpdate)
            {
                set<String> lineitem_ids_set = new Set<String>();
                for(akritiv__Payment_Line__c PLIT : Trigger.New)
                {
                    if(Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c == 0 && (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c != Trigger.newMap.get(PLIT.Id).akritiv__Applied_Amount__c))
                        lineitem_ids_set.add(PLIT.Id);
                    system.debug('LINE ITEM ID SET--------'+lineitem_ids_set);
                }
                if(lineitem_ids_set.size() > 0)
                {
                    list<FIU_Report__c> FIUreport_list = [Select Id,Transaction_Name__c,Reference__c,Opening_FIU_Balance__c from FIU_Report__c where Reference__c in : lineitem_ids_set]; 
                    for(FIU_Report__c FIUR : FIUreport_list)
                    {
                        if(FIUR.Transaction_Name__c == 'Payment Line Item')
                            MapFIU.put(FIUR.Reference__c,FIUR.Opening_FIU_Balance__c);
                    }
                    
                    Try{
                     Delete [Select Id from IUF__c where Payment_Line_Item__c in : lineitem_ids_set];
                     Delete FIUreport_list;   
                    }catch(Exception e){system.debug('Exception ==> '+e);}
                }
            }
            
            map<string,akritiv__Payment__c> MapofPayments = new map<String,akritiv__Payment__c>();
            map<string,akritiv__Payment__c> MapofPayments_IUF = new map<String,akritiv__Payment__c>();
            set<string> clientAccountIds = new Set<String>();
            for(akritiv__Payment__c pmnt : [Select id,Client_Account__c,Portal_External_Id__c,IUF_Required__c,Payment_Status__c from akritiv__Payment__c where (Portal_External_Id__c in : PaymentPortalExternalId or id in : PaymentIDS)])
            {
                MapofPayments.put(pmnt.Portal_External_Id__c,pmnt);
                MapofPayments_IUF.put(pmnt.id,pmnt);
                clientAccountIds.add(pmnt.Client_Account__c);
            }
            Map<string,Client_Account__c> Client_account_map = new Map<string,Client_Account__c>([Select id,IUF_Reserve_Retained__c,Interest_Due__c,UL_Fee_Due__c,Interest_Due_Since__c,UL_Fee_Due_Since__c from Client_Account__c where id in: clientAccountIds]);
            Map<string,List<Fees__c>> FeeMap = new Map<string,List<Fees__c>>();
            list<Fees__c>Feelist = [Select Id,Client_Account__c,Fee_Amount__c,Fee_Balance__c,Fee_Date__c,Fee_description__c,Fee_status__c,Fee_type__c From Fees__c where Client_Account__c in: clientAccountIds and Fee_status__c =: 'UNPAID' order by Fee_Date__c asc];
            for(String CA : clientAccountIds)
            {
                list<Fees__c> tempFeelist = new list<Fees__c>();
                for(Fees__c Fee : Feelist)
                {
                    if(Fee.Client_Account__c == CA)
                    {
                        tempFeelist.add(Fee);
                    }
                    FeeMap.put(CA,tempFeelist);
                }
            }
            
            List<Payment_and_Fee__c> PF_List = new List<Payment_and_Fee__c>();
            system.debug('FeeMap ==> '+ FeeMap);
            if(Trigger.isInsert)
            {
                map<string,akritiv__Transaction__c> MapofInvoices = new map<String,akritiv__Transaction__c>();
                for(akritiv__Transaction__c Trns : [Select id,Portal_External_Id__c from akritiv__Transaction__c where Portal_External_Id__c in : InvoicePortalExternalId])
                {
                    MapofInvoices.put(Trns.Portal_External_Id__c,Trns);
                }
                
                if(MapofPayments != NULL && MapofInvoices != NULL)
                {
                    for(akritiv__Payment_Line__c PLit : Trigger.New)
                    {
                        if(MapofPayments.get(PLit.Payment_Portal_External_ID__c) != NULL && PLit.akritiv__Payment__c == NULL)
                        {
                            PLit.akritiv__Payment__c = MapofPayments.get(PLit.Payment_Portal_External_ID__c).Id;
                        
                        }
                        if(MapofInvoices.get(PLit.Invoice_Portal_External_ID__c) != NULL && PLit.akritiv__Applied_To__c  == NULL)
                        {
                            PLit.akritiv__Applied_To__c = MapofInvoices.get(PLit.Invoice_Portal_External_ID__c).ID;
                        }
                    }
                }
            }
            system.debug('==> 1'+ MapofPayments_IUF);
            if(MapofPayments_IUF != NULL)
            {
                Map<string,Double> UpdatePaymentIUF = new Map<string,Double>();
                List<Fees__c> Update_Fee_List = new List<Fees__c>();
                for(akritiv__Payment_Line__c PLit : Trigger.New)
                {
                    if(MapofPayments_IUF.get(PLit.akritiv__Payment__c) != NULL)
                    {
                        if(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Payment_Status__c == 'Applied - No Funds')
                        {
                            PLit.Flag_for_Line_Amount__c = True;
                        }
                        if(Trigger.IsInsert || (Trigger.isUpdate && (Trigger.oldMap.get(PLIT.Id).Flag_for_Line_Amount__c == True || (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c == 0 && (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c != Trigger.newMap.get(PLIT.Id).akritiv__Applied_Amount__c)))))
                        {
                            if(PLIT.Portal_Transaction_Id__c == NULL)
                            {
                                if(PLit.Flag_for_Line_Amount__c == False)
                                {
                                    Double FeeAmount = 0;
                                    Double InterestDue = 0,ULFeeDue = 0,AppliedAmount = 0;
                                    AppliedAmount = Plit.akritiv__Applied_Amount__c;
                                    if(Client_account_map != NULL)
                                    {
                                        if(Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).Interest_Due__c != NULL)
                                            InterestDue = Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).Interest_Due__c;
                                        if(Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).UL_Fee_Due__c != NULL)
                                            ULFeeDue = Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).UL_Fee_Due__c;

                                        if(FeeMap != NULL && FeeMap.containsKey(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c))
                                        {
                                            String FeePaidInformation = '';
                                            for(Fees__c Fee : FeeMap.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c))
                                            {
                                                if(Fee.Fee_type__c == 'Servicer Fee')
                                                {
                                                    if(AppliedAmount > Fee.Fee_Balance__c)
                                                    {
                                                        AppliedAmount = AppliedAmount - Fee.Fee_Balance__c;
                                                        FeePaidInformation = FeePaidInformation + ',' + string.valueof(Fee.Id) +'-'+ string.valueof(Fee.Fee_Balance__c);
                                                        Fee.Fee_Balance__c = 0;
                                                        Fee.Fee_status__c = 'PAID';
                                                        Update_Fee_List.add(Fee);
                                                    }
                                                    else if(AppliedAmount <= Fee.Fee_Balance__c && AppliedAmount != 0)
                                                    {
                                                        Fee.Fee_Balance__c = Fee.Fee_Balance__c - AppliedAmount;
                                                        FeePaidInformation = FeePaidInformation + ',' + string.valueof(Fee.Id) +'-'+ string.valueof(AppliedAmount);
                                                        AppliedAmount = 0;
                                                        Update_Fee_List.add(Fee);
                                                        break;
                                                    }
                                                }
                                            }
                                            for(Fees__c Fee : FeeMap.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c))
                                            {
                                                if(Fee.Fee_type__c == 'Lender Expense')
                                                {
                                                    if(AppliedAmount > Fee.Fee_Balance__c)
                                                    {
                                                        AppliedAmount = AppliedAmount - Fee.Fee_Balance__c;
                                                        FeePaidInformation = FeePaidInformation + ',' + string.valueof(Fee.Id) +'-'+ string.valueof(Fee.Fee_Balance__c);
                                                        Fee.Fee_Balance__c = 0;
                                                        Fee.Fee_status__c = 'PAID';
                                                        Update_Fee_List.add(Fee);
                                                    }
                                                    else if(AppliedAmount <= Fee.Fee_Balance__c && AppliedAmount != 0)
                                                    {
                                                        Fee.Fee_Balance__c = Fee.Fee_Balance__c - AppliedAmount;
                                                        FeePaidInformation = FeePaidInformation + ',' + string.valueof(Fee.Id) +'-'+ string.valueof(AppliedAmount);
                                                        AppliedAmount = 0;
                                                        Update_Fee_List.add(Fee);
                                                          break;
                                                    }
                                                }
                                            }
                                            if(FeePaidInformation != '' )
                                                PLIT.Fee_Paid_Information__c = FeePaidInformation;
                                                PLIT.Applied_Fee__c = Plit.akritiv__Applied_Amount__c - AppliedAmount;
                                        }
                                        system.debug('Fee Paid Information --> '+ PLIT.Fee_Paid_Information__c);
                                        system.debug('InterestDue-> '+ InterestDue);system.debug('ULFeeDue-> '+ ULFeeDue);
                                        if(InterestDue > 0)
                                        {
                                            if(AppliedAmount >= InterestDue)
                                            {
                                                Plit.Interest_Due_Recovered__c = InterestDue;
                                                AppliedAmount = AppliedAmount - InterestDue;
                                                InterestDue = 0;
                                                Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).Interest_Due_Since__c = NULL;
                                                if(ULFeeDue > 0)
                                                {
                                                    if(AppliedAmount >= ULFeeDue)
                                                    {
                                                        plit.UL_Fee_Due_Recovered__c = ULFeeDue;
                                                        AppliedAmount = AppliedAmount - ULFeeDue;
                                                        ULFeeDue = 0;
                                                        Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                    }
                                                    else
                                                    {
                                                        plit.UL_Fee_Due_Recovered__c = AppliedAmount;
                                                        ULFeeDue = ULFeeDue - AppliedAmount;
                                                        AppliedAmount = 0;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                Plit.Interest_Due_Recovered__c = AppliedAmount;
                                                InterestDue = InterestDue - AppliedAmount;
                                                AppliedAmount = 0;
                                            }
                                        }
                                        else
                                        {
                                            if(ULFeeDue > 0)
                                            {
                                                if(AppliedAmount >= ULFeeDue)
                                                {
                                                    plit.UL_Fee_Due_Recovered__c = ULFeeDue;
                                                    AppliedAmount = AppliedAmount - ULFeeDue;
                                                    ULFeeDue = 0;
                                                    Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                }
                                                else
                                                {
                                                    plit.UL_Fee_Due_Recovered__c = AppliedAmount;
                                                    ULFeeDue = ULFeeDue - AppliedAmount;
                                                    AppliedAmount = 0;
                                                }
                                            }
                                        }
                                        
                                        Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).Interest_Due__c = InterestDue;
                                        Client_account_map.get(MapofPayments_IUF.get(PLit.akritiv__Payment__c).Client_Account__c).UL_Fee_Due__c = ULFeeDue;
                                    }
                                    system.debug('UpdatePaymentIUF => '+UpdatePaymentIUF);
                                    if(UpdatePaymentIUF.containsKey(PLIT.akritiv__Payment__c))
                                    {
                                        system.debug('--->2 '+ UpdatePaymentIUF.get(PLIT.akritiv__Payment__c));
                                        PLit.Actual_IUF_Required__c = math.min(AppliedAmount,UpdatePaymentIUF.get(PLIT.akritiv__Payment__c));
                                        system.debug('---> '+ PLit.Actual_IUF_Required__c);
                                        UpdatePaymentIUF.put(PLIT.akritiv__Payment__c,UpdatePaymentIUF.get(PLIT.akritiv__Payment__c)-PLit.Actual_IUF_Required__c);
                                    }
                                    else
                                    {
                                        PLit.Actual_IUF_Required__c = math.min(AppliedAmount,MapofPayments_IUF.get(PLit.akritiv__Payment__c).IUF_Required__c);
                                        system.debug('---> '+ math.min(Plit.akritiv__Applied_Amount__c,MapofPayments_IUF.get(PLit.akritiv__Payment__c).IUF_Required__c));
                                        UpdatePaymentIUF.put(PLIT.akritiv__Payment__c,MapofPayments_IUF.get(PLit.akritiv__Payment__c).IUF_Required__c - PLit.Actual_IUF_Required__c);
                                    }
                                    If((Trigger.IsInsert && PLit.Portal_External_ID__c != NULL) || Trigger.isUpdate)
                                        PLit.Applied_Date_and_Time__c = system.now();
                                }
                            }
                        }
                    }
                 }
                try
                {
                    update Client_account_map.values();
                    system.debug('Update_Fee_List -> '+Update_Fee_List);
                    if(Update_Fee_List.size() > 0)
                        update Update_Fee_List;
                }catch(Exception e){system.debug('Exception ==> '+ e);}
            }
        }
    }
    if(Trigger.isAfter)
    {
        system.debug('==> Payment Line Items After Trigger <===');
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            set<string> PaymentID_Set = new set<String>();
            Map<string,Map<string,string>> Paymentline_FeeMap = new Map<string,Map<string,string>>();
            List<Payment_and_Fee__c> PF_List = new List<Payment_and_Fee__c>();
            for(akritiv__Payment_Line__c PLIT : Trigger.New)
            {
                PaymentID_Set.add(PLIT.akritiv__Payment__c);
            }
 
            map<String,akritiv__Payment__c> payment_map = new map<String,akritiv__Payment__c>([Select id,FIU_Prior_Value__c,Client_Account__c,Payment_Status__c,Client_Account__r.IUF_Reserve_Retained__c from akritiv__Payment__c where Id in : PaymentID_Set]);
  
            List<IUF__c> IFUList = new List<IUF__c>();
            List<FIU_Report__c> FIU_Report_list = new List<FIU_Report__c>();
            FIU_Report__c FR;
            Double Opening_IUF_value = 0.0,FIU_Prior_Value = 0.0;
            for(akritiv__Payment_Line__c PLIT : Trigger.New)
            { //system.debug('PLIT.Flag_for_Line_Amount__c' + PLIT.Flag_for_Line_Amount__c);
                if(Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c == 0 && (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c != Trigger.newMap.get(PLIT.Id).akritiv__Applied_Amount__c)) || (Trigger.oldMap.get(PLIT.Id).Flag_for_Line_Amount__c == True && (Trigger.oldMap.get(PLIT.Id).akritiv__Applied_Amount__c == Trigger.newMap.get(PLIT.Id).akritiv__Applied_Amount__c))))//&& PLIT.IUF_Required__c != 0
                {
                    if(PLIT.Flag_for_Line_Amount__c == False)
                    {
                        if(PLIT.Fee_Paid_Information__c != NULL && PLIT.Fee_Paid_Information__c != '')
                        {
                            for(String str : PLIT.Fee_Paid_Information__c.split(','))
                            {
                                if(str != '')
                                {
                                    Payment_and_Fee__c PF = new Payment_and_Fee__c();
                                    PF.Payment_Line__c = PLIT.id;
                                    PF.Applied_Date_Time__c = system.now();
                                    PF.Fees__c = str.split('-')[0];
                                    PF.Amount__c = DOuble.valueof(str.split('-')[1]);
                                    PF_List.add(PF);
                                }
                            }
                        }
                        system.debug('PF_List --> ' + PF_List);
                        
                        //       PLIT.Actual_IUF_Required__c = PLIT.IUF_Required__c;
                        system.debug('===> '+ payment_map.get(PLIT.akritiv__Payment__c).FIU_Prior_Value__c);
                        FIU_Prior_Value = payment_map.get(PLIT.akritiv__Payment__c).FIU_Prior_Value__c;
                        Opening_IUF_value = PLIT.Current_IUF_Retained__c;
                        system.debug('Interest Due Re--> '+ PLIT.Interest_Due_Recovered__c);
                        system.debug('UL Due Re--> '+ PLIT.UL_Fee_Due_Recovered__c);
                        system.debug('IFUList--> '+ IFUList);
                        if(IFUList.size() > 0)
                        {
                           Opening_IUF_value = 0.0;
                           for(IUF__c IUF_temp : IFUList)
                           {
                               if(IUF_temp.Payments__c == PLIT.akritiv__Payment__c)
                               {
                                 //  if(IUF_temp.Opening_IUF_Retained__c != 0)
                                 //  {
                                 //      if(Opening_IUF_value < IUF_temp.Opening_IUF_Retained__c + IUF_temp.IUF_Retained__c)
                                 //      {
                                           Opening_IUF_value = IUF_temp.Opening_IUF_Retained__c + IUF_temp.IUF_Retained__c;
                                 //      }
                                 //  }
                               }
                            } 
                           /* if(PLIT.Actual_IUF_Required__c != NULL)
                            {
                                Opening_IUF_value = Opening_IUF_value + PLIT.Actual_IUF_Required__c;
                            } 
                            if(PLIT.Actual_IUF_Required__c == 0)
                            {
                                Opening_IUF_value = Opening_IUF_value;
                            }*/
                        }
                        system.debug('PLIT.Actual_IUF_Required__c--> '+ PLIT.Actual_IUF_Required__c);
                        IUF__c IUF = new IUF__c();
                        IUF.Date__c = PLIT.akritiv__Transaction_Date__c;
                        IUF.IUF_Retained__c = PLIT.Actual_IUF_Required__c ;// + PLIT.Interest_Due_Recovered__c + PLIT.UL_Fee_Due_Recovered__c;
                        IUF.Applied_Fee__c = PLIT.Applied_Fee__c;
                        IUF.Interest_Due_Recovered__c = PLIT.Interest_Due_Recovered__c;
                        IUF.UL_Fee_Due_Recovered__c = PLIT.UL_Fee_Due_Recovered__c;
                        IUF.Opening_IUF_Retained__c = Opening_IUF_value;//PLIT.Current_IUF_Retained__c;
                        IUF.IUF_used__c = 0;
                        IUF.Payment_Line_Item__c = PLIT.id;
                        IUF.Payment_Line__c = PLIT.id;
                        IUF.Payments__c = PLIT.akritiv__Payment__c;
                        IUF.Client_Account__c = PLIT.Client_Account__c;
                        IUF.Type__c = 'System';
                        IFUList.add(IUF);
                        
                        if(FIU_Report_list.size() > 0)
                        {
                            for(FIU_Report__c FIU : FIU_Report_list)
                            {
                                if(FIU.PaymentID__c == PLIT.akritiv__Payment__c)
                                    FIU_Prior_Value = FIU.Closing_FIU_Balance__c;
                            }
                        }
                       
                        FR = new FIU_Report__c();
                        FR.Transaction_Name__c = 'Cash applied';
                        FR.Transaction_ID__c = PLIT.Name;
                        FR.Date__c = PLIT.akritiv__Transaction_Date__c;
                        FR.Created_Time__c = system.now();
                        FR.Payments__c = PLIT.akritiv__Applied_Amount__c;
                        FR.Reference__c = PLIT.id;
                        if(payment_map != NULL && payment_map.get(PLIT.akritiv__Payment__c) != NULL)
                        {   
                            FR.PaymentID__c = payment_map.get(PLIT.akritiv__Payment__c).id;
                            FR.Client_Account__c = payment_map.get(PLIT.akritiv__Payment__c).Client_Account__c;
                            FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                            FR.Closing_FIU_Balance__c = FIU_Prior_Value - PLIT.akritiv__Applied_Amount__c;
                            FIU_Prior_Value = FIU_Prior_Value - PLIT.akritiv__Applied_Amount__c;
                        }
                        FIU_Report_list.add(FR);
                        
                        FR = new FIU_Report__c();
                        FR.Transaction_Name__c = 'IUF recovered';
                        FR.Transaction_ID__c = PLIT.Name;
                        FR.Date__c = PLIT.akritiv__Transaction_Date__c;
                        FR.Created_Time__c = system.now();
                        FR.Funding__c = PLIT.Actual_IUF_Required__c + PLIT.Interest_Due_Recovered__c + PLIT.UL_Fee_Due_Recovered__c;
                        FR.Reference__c = PLIT.id;
                        if(payment_map != NULL && payment_map.get(PLIT.akritiv__Payment__c) != NULL)
                        {   
                            FR.PaymentID__c = payment_map.get(PLIT.akritiv__Payment__c).id;
                            FR.Client_Account__c = payment_map.get(PLIT.akritiv__Payment__c).Client_Account__c;
                            FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                            Double ClosingFIU = FIU_Prior_Value + PLIT.Actual_IUF_Required__c + PLIT.Interest_Due_Recovered__c + PLIT.UL_Fee_Due_Recovered__c;
                            FR.Closing_FIU_Balance__c = (ClosingFIU == -0.00 ? math.abs(ClosingFIU):ClosingFIU); 
                        }
                        FIU_Report_list.add(FR);
                        system.debug('FIU_Report_list ==> '+ FIU_Report_list);
                    }
                }
                if(payment_map != NULL && payment_map.get(PLIT.akritiv__Payment__c) != NULL)
                {
                    if(payment_map.get(PLIT.akritiv__Payment__c).Payment_Status__c == 'Applied - Processing')
                    {
                        payment_map.get(PLIT.akritiv__Payment__c).Payment_Status__c = 'Applied - Processed';
                    }
                    if(payment_map.get(PLIT.akritiv__Payment__c).Payment_Status__c == 'Partially Applied - Processing')
                    {                                                                  
                        payment_map.get(PLIT.akritiv__Payment__c).Payment_Status__c = 'Partially Applied';
                    }
                }
            }
            try{
                insert IFUList;insert FIU_Report_list; update payment_map.values();
               if(PF_List.size() > 0)
               {
                   insert PF_List;
               }
               }Catch(Exception e){System.debug('Exception '+e);}
        }
        if(Trigger.isDelete)
        {
            set<String> set_of_lineitem_ids = new Set<String>();
            for(akritiv__Payment_Line__c PLIT : Trigger.Old)
            {
                set_of_lineitem_ids.add(PLIT.Id);
            }
            Try{
                Delete [Select Id from IUF__c where Payment_Line_Item__c in : set_of_lineitem_ids];
                Delete [Select Id from FIU_Report__c where Reference__c in : set_of_lineitem_ids];
                Delete [Select Id from Payment_and_Fee__c where Payment_Line__c in : set_of_lineitem_ids];
            }catch(Exception e){system.debug('Exception ==> '+e);}
        }
    } 
}