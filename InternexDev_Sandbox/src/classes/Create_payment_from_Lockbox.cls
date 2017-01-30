public class Create_payment_from_Lockbox {
    public void Create_payment(List<WF_PR__c> PR_List)
    {
      //  system.debug('++++++'+PR_List);
        Set<string> Set_Batch_headers = new Set<string>();
        Set<string> PR_ids = new Set<String>();
        set<string> Matching_string_for_Image_mapping_set = new Set<string>();
        for(WF_PR__c WF : PR_List)
        {
            Set_Batch_headers.add(WF.WF_BH__c);
            PR_ids.add(WF.id);
            Matching_string_for_Image_mapping_set.add(WF.Matching_string_for_Image_mapping__c);
        }
       // system.debug('PR ID====='+PR_ids);
        Map<string,WF_BH__c> Map_batch_header = new Map<String,WF_BH__c>([Select id,name,PTH_Payment_source__c,PTH_RDFI_R_T__c,PTH_RDFI_account_number__c,PTH_Lockbox_number__c,LB_Number__c,BH_Batch_number__c,BH_Batch_net_amount__c From WF_BH__c where id in: Set_Batch_headers]);
    //    system.debug('Map_batch_header ==> '+Map_batch_header);
        if(Map_batch_header != NULL)
        {
            //    map<String,WF_BH__c> LockboxNumbermap = new map<String,WF_BH__c>();
            set<string> LockboxNumber_set = new Set<String>();
            for(WF_PR__c WF : PR_List)
            {
                if(Map_batch_header.containsKey(WF.WF_BH__c) != NULL && Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c != NULL)
                {
                    LockboxNumber_set.add(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c);
                    //        LockboxNumbermap.put(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c);
                }
                system.debug('Lockbox set : '+LockboxNumber_set);
            }
            Map<String,LockBox_Account__c> LockBox_Account_Map = new Map<String,LockBox_Account__c>();
            for(LockBox_Account__c CA : [Select id,Name,Client_Account__c,Lockbox_Number__c,Account_Number__c,Routing_Number__c from LockBox_Account__c where Account_Number__c in : LockboxNumber_set])
            {
                system.debug('CA list======'+CA);
                LockBox_Account_Map.put(CA.Account_Number__c,CA);
            }
      //      system.debug('LockBox_Account_Map ==> '+LockBox_Account_Map);
            
            Map<string,WF_PPR__c> PPR_map = new Map<String,WF_PPR__c>();
            set<String> PayeeName_set = new Set<String>();
            for(WF_PPR__c PPR : [Select id,name,Name__C,Postal_code__c,WF_PR__c from WF_PPR__c where WF_PR__c in : PR_ids])
            {
                PPR_map.put(PPR.WF_PR__c,PPR);
                PayeeName_set.add(PPR.Name__C.trim().toUpperCase());
            }
            system.debug('PayeeeName====='+PayeeName_set );

            List<akritiv__Payment__c> Payment_list = new List<akritiv__Payment__c>();
      //      List<WF_PR__c> Update_status_for_LBpaymet = new List<WF_PR__c>();
            Set<string> Client_acount_Set = new Set<String>();
            
            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
            //======= Created the payments ==================//
            for(WF_PR__c WF : PR_List)
            {
                if(WF.Payment_Status__c == 'None' || WF.Payment_Status__c == '' || WF.Payment_Status__c == NULL)
                    	WF.Payment_Status__c = 'Suspense';
                if(WF.Payment__c == NULL)
                {
                    if(LockBox_Account_Map != NULL)
                    {
                        if(Map_batch_header.containsKey(WF.WF_BH__c) != NULL && Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c != NULL)
                        {
                            if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c) != NULL )
                            {
                                if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Account_Number__c == Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c)
                                {
                                    if(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Routing_Number__c == Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_R_T__c)
                                    {
                                        WF.Payment_Status__c = 'Valid';
                                        akritiv__Payment__c pmnt = new akritiv__Payment__c();
                                        
                                        pmnt.Name = WF.Name+' LockBox Account';
                                        pmnt.Client_Account__c = LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Client_Account__c;
                                        Client_acount_Set.add(LockBox_Account_Map.get(Map_batch_header.get(WF.WF_BH__c).PTH_RDFI_account_number__c).Client_Account__c);
                                        pmnt.akritiv__Amount__c = WF.Amount_paid_formula__c;
                                        pmnt.akritiv__Payment_Date__c = WF.Deposit_settlement_date__c;

                                        pmnt.Payment_Status__c = 'Valid';
                                        
                                        Account Acc = [Select id,name from Account where name =: 'Lockbox Account' limit 1];
                                        pmnt.akritiv__Account__c = Acc.id;
                                        
                                        if(WF.Payment_method__c == 'CHK')
                                        {
                                            pmnt.akritiv__Payment_Type__c = 'Check';
                                        }
                                        else if(WF.Payment_method__c == 'FWT' || WF.Payment_method__c == 'SWT' || WF.Payment_method__c == 'CWT')
                                        {
                                            pmnt.akritiv__Payment_Type__c = 'Wire';
                                        }
                                        else
                                        {
                                            pmnt.akritiv__Payment_Type__c = WF.Payment_method__c;
                                        }
                                        
                                        pmnt.WF_Batch_Number__c = Map_batch_header.get(WF.WF_BH__c).BH_Batch_number__c;
                                        pmnt.WF_Batch_net_amount__c = Map_batch_header.get(WF.WF_BH__c).BH_Batch_net_amount__c;
                                        pmnt.Routing_Number__c = WF.ODFI_RTN__c;
                                        pmnt.Source_Bank_Account_No__c = WF.ODFI_account_number_ACH_company_ID_con__c;
                                        pmnt.Credit_Debit__c = WF.Credit_debit_indicator__c;
                                        if(WF.Payment_method__c == 'ACH')
                                            pmnt.Standard_Entry_Class_code__c = WF.Payment_method_type_code__c;
                                        pmnt.Standard_Payment_Reference_No__c = WF.Sender_payment_reference_number__c;
                                        pmnt.Processing_System_Reference_No__c = WF.Processing_system_reference_number__c;
                                        pmnt.Wells_Fargo_reference_number__c = WF.Wells_Fargo_reference_number__c;
                                        pmnt.Deposit_settlement_date__c = WF.Deposit_settlement_date__c;
                                        pmnt.Payment_effective_date__c = WF.Payment_effective_date__c;
                                        pmnt.Transaction_processing_date_time__c = WF.Transaction_processing_date_time__c;
                                        pmnt.Additional_currency_code__c = WF.Additional_currency_code__c;
                                        pmnt.Lockbox_Payment_akritiv_ID__c = WF.id;
                                        
                                        WF.Payment_Status__c = 'Valid';
                                        
                                        Payment_list.add(pmnt);
                                    }
                                }
                            }
                        }                
                    }
                }
            }
       /*     if(Payment_list.size() > 0)
            {
                try{
                    upsert Payment_list;
                }catch(Exception e){system.debug('Excpetion e'+ e);}	
            }*/
            
            List<akritiv__Payment__c> Existing_payment_list = [Select id,Payment_Status__c,Lockbox_Payment_akritiv_ID__c,Debtor__c,Client_Account__c from akritiv__Payment__c 
                                                               where Lockbox_Payment_akritiv_ID__c in : PR_ids and Client_Account__c !=: NULL and Debtor__c =: NULL and Payment_Status__c =: 'Unidentified'];
            for(akritiv__Payment__c pm : Existing_payment_list)
            {
                system.debug('Existing Payment List====='+pm);
                Client_acount_Set.add(pm.Client_Account__c);
            }
            Payment_list.addALL(Existing_payment_list);
        //    system.debug('==> Payment_list -->  ' + Payment_list);
            Map<string,Debtor__c> Debtor_map = new Map<String,Debtor__c>();
            Map<string,DBA_Name__c> DBA_Debtor_map = new Map<String,DBA_Name__c>();
            Set<string> Debtor_id_set = new set<String>();
            List<Debtor__c> Debtorlist = [Select id,name,Counterparty__c,Client_Account__c,Debtor_Name__c from Debtor__c where Debtor_Name__c in: PayeeName_set and Client_Account__c in: Client_acount_Set];
            for(DBA_Name__c DBAname : [Select id,name,DBA_Name__c,Debtor__c,Debtor__r.Client_Account__c from DBA_Name__c where DBA_Name__c in : PayeeName_set])
            {
                DBA_Debtor_map.put(DBAname.Debtor__r.Client_Account__c+DBAname.DBA_Name__c,DBAname);
                Debtor_id_set.add(DBAname.Debtor__c);
            }
            for(Debtor__c deb : Debtorlist)
            {
                Debtor_map.put(deb.Client_Account__c+deb.Debtor_Name__c, deb);
                Debtor_id_set.add(deb.id);
            }
           system.debug('Debtor_map ==> '+Debtor_map);
            
            // ======== Updating the Payment status based on the Debtor =======//
            for(akritiv__Payment__c pmnt : Payment_list)
            {
                pmnt.Payment_Status__c = 'Unidentified';
                If(PPR_map != NULL)
                {
                    if(PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c) != NULL && PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c).Name__C != NULL)
                    {
                        if(Debtor_map != NULL && Debtor_map.get(pmnt.Client_Account__c+PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c).Name__C.trim().toUpperCase()) != NULL)
                        {
                            pmnt.Debtor__c = Debtor_map.get(pmnt.Client_Account__c+PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c).Name__C.trim().toUpperCase()).id;
                            pmnt.Payment_Status__c = 'Unapplied';
                        }
                        else
                        {
                             if(DBA_Debtor_map != NULL && DBA_Debtor_map.get(pmnt.Client_Account__c+PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c).Name__C.trim().toUpperCase()) != NULL)
                             {
                                 pmnt.Debtor__c = DBA_Debtor_map.get(pmnt.Client_Account__c+PPR_map.get(pmnt.Lockbox_Payment_akritiv_ID__c).Name__C.trim().toUpperCase()).Debtor__c;
                                 pmnt.Payment_Status__c = 'Unapplied';
                             }
                        }
                    }
                }
            }
            
            try{
             //   system.debug('Payment_list--> '+  Payment_list);
                 Database.upsert(Payment_list,false);
                 system.debug('Resp--> '+  Payment_list);
             	Update[Select id,Name,Matching_string_for_Image_mapping__c from WF_Transaction_Data__c where Matching_string_for_Image_mapping__c in: Matching_string_for_Image_mapping_set];
                Update[Select id,Name,Matching_string_for_Image_mapping__c from WF_Invoice_Transactions__c where Matching_string_for_Image_mapping__c in: Matching_string_for_Image_mapping_set];
                Update[Select id,Name,Matching_string_for_Image_mapping__c from WF_WP_Transactions__c where Matching_string_for_Image_mapping__c in: Matching_string_for_Image_mapping_set];
                list<Lockbox_Image__c> list_LB = [Select id,Name,Payment__c,WF_PR__c from Lockbox_Image__c where WF_PR__c in: PR_ids and Payment__c =: NULL];
                
                for(WF_PR__c WF : PR_List)
                {
                    for(akritiv__Payment__c pmnt: Payment_list)
                    {
                        if(pmnt.Lockbox_Payment_akritiv_ID__c == WF.id)
                        {
                            WF.Payment__c = pmnt.id;
                        }
                    }
                    for(Lockbox_Image__c Lb : list_LB)
                    {
                        if(Lb.WF_PR__c == WF.id)
                        {
                            Lb.Payment__c =  WF.Payment__c;
                        }
                    } 
                }
                update PR_List;
                if(list_LB.size() > 0)
                	update list_LB; 
                
                set<string> RMH_set = new Set<string>();
                Map<string,PR_and_RMH__c> Jo_map = new Map<string,PR_and_RMH__c>();
                list<PR_and_RMH__c> Jo_List = [Select id,Name,WF_PR__c,WF_RMH__c,WF_PR__r.Reference_1_PR22B__c,WF_PR__r.Payment__c,WF_PR__r.Payment__r.Debtor__c,WF_PR__r.Amount_paid_formula__c,PaymentLineItemCreated__c from PR_and_RMH__c where WF_PR__c in: PR_ids and PaymentLineItemCreated__c =: False];
                for(PR_and_RMH__c JO : Jo_List)
                {
                    RMH_set.add(JO.WF_RMH__c);
                    Jo_map.put(String.valueof(JO.WF_PR__c)+string.valueof(JO.WF_RMH__c),JO);
                }
                            
               	List<WF_REM__c> REM_LIST= [Select id,WF_RMH__c,WF_RMH__r.name,Reference_2__c,Remittance_gross_amount_formula__c,Remittance_net_amount_paid_formula__c,Invoice_Name__c from WF_REM__c where WF_RMH__c in : RMH_set];//,WF_RMH__r.WF_PR__c,WF_RMH__r.WF_PR__r.Payment__r.Debtor__c,WF_RMH__r.WF_PR__r.Payment__c
                //update  REM_LIST;
              
                                         
                map<string,akritiv__Transaction__c> Invoicemap = new map<string,akritiv__Transaction__c>();
                if(REM_list.size() > 0)
                {
                    set<string> Invoice_Names = new set<string>();
                    for(WF_REM__c REM : REM_list)
                    {
                       // string invName = REM.Reference_2__c.remove('_').remove(' ').trim().toUpperCase();
                        Invoice_Names.add(REM.Invoice_Name__c);
                    }
                    system.debug('-->Invoice_Names '+ Invoice_Names);
                    list<akritiv__Transaction__c> invoicelist = [Select id,name,Debtor__c,Balance_Internex__c from akritiv__Transaction__c where Debtor__c in : Debtor_id_set and name in: Invoice_Names and Balance_Internex__c > 0 order by createdDate asc];
                    for(akritiv__Transaction__c inv : invoicelist)
                    {
                        Invoicemap.put(inv.Debtor__c+inv.name,inv);
                    }
                    system.debug('Invoicemap--> '+ Invoicemap);
                    if(Invoicemap != NULL)
                    {
                        List<akritiv__Payment_Line__c> Update_paymentline = new List<akritiv__Payment_Line__c>();
                        for(String PAY : PR_ids)
                        {
                            for(WF_REM__c REM : REM_list)
                            {
                                if(Jo_map.containsKey(Pay+string.valueof(REM.WF_RMH__c)))
                                {
                                    akritiv__Payment_Line__c pl = new akritiv__Payment_Line__c();
                                    if(Invoicemap.containsKey(Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).WF_PR__r.Payment__r.Debtor__c+REM.Invoice_Name__c))
                                    {
                                        pl.akritiv__Applied_Amount__c = REM.Remittance_net_amount_paid_formula__c;
                                        //pl.WF_Applied_Amount__c = Double.valueof(string.valueof(REM.Remittance_net_amount_paid__c).mid(0,string.valueof(REM.Remittance_net_amount_paid__c).length()-2) +'.'+ string.valueof(REM.Remittance_net_amount_paid__c).right(2));
                                        pl.WF_Applied_Amount__c = Invoicemap.get(Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).WF_PR__r.Payment__r.Debtor__c+REM.Invoice_Name__c).Balance_Internex__c;
                                       // system.debug('Invoice--> '+ Invoicemap.get(Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).WF_PR__r.Payment__r.Debtor__c+REM.Invoice_Name__c));
                                        pl.akritiv__Applied_To__c = Invoicemap.get(Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).WF_PR__r.Payment__r.Debtor__c+REM.Invoice_Name__c).id;
                                        pl.akritiv__Payment__c = Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).WF_PR__r.Payment__c;
                                        pl.PR_and_RMH__c = Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).Name;
                                        //   pl.Flag_for_Line_Amount__c = True;
                                        Update_paymentline.add(pl);
                                       Jo_map.get(Pay+string.valueof(REM.WF_RMH__c)).PaymentLineItemCreated__c = True;
                                    }
                                }
                            }
                        }
                        system.debug('Update_paymentline--> '+Update_paymentline);
                        if(Update_paymentline.size() > 0)
                        {
                            insert Update_paymentline;
                        	update Jo_map.values();
                        }
                    }
                }
               
            }catch(Exception e){system.debug('Exception e'+ e);}
        }
    }
}