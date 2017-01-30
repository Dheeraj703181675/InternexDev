trigger trgonPPR on WF_PPR__c (after insert,after update) {
    if(Trigger.isAfter)
    {
        set<string> PR_Set = new Set<String>();
        for(WF_PPR__c PPR : Trigger.New)
        {
            if(PPR.WF_PR__c != NULL)
            {
                PR_Set.add(PPR.WF_PR__c);
            }
        }
        List<WF_PR__c> prlist = [SELECT Id, Name, CreatedDate,Record_ID__c, Item_sequence_number__c, ODFI_RTN__c, ODFI_account_number_ACH_company_ID_con__c,Amount_paid_formula__c,Matching_string_for_Image_mapping__c, 
                                 Credit_debit_indicator__c, Amount_paid__c, Gross_amount__c, Payment_method__c, Payment_method_type_code__c, Sender_payment_reference_number__c, 
                                 Processing_system_reference_number__c, Wells_Fargo_reference_number__c, Deposit_settlement_date__c, Payment_effective_date__c, Transaction_processing_date_time__c, 
                                 Currency_entity_identifier_code__c, Currency_code__c, Exchange_rate__c, Additional_entity_identifier_code__c, Additional_currency_code__c, Currency_market_exchange_code__c,
                                 Reference_1_qualifier_description__c, Reference_1_description__c, Reference_1_PR22B__c, Custom_Amount_1__c, MCA_Amount_Paid__c, 
                                 MCA_Gross_Amount__c, Reversal_Reason_Code__c, WF_BH__c, Temp_BH__c, Payment_Status__c, Payment__c FROM WF_PR__c where Id in: PR_Set];
       
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        cp.Create_payment(prlist);
    }
}