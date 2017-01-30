global class LockboxBatch implements Database.Batchable<sObject> {
global Database.QueryLocator Start(Database.BatchableContext BC)
    {
         string query = 'SELECT Id, Amount_paid_formula__c,IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Record_ID__c, Item_sequence_number__c, ODFI_RTN__c, ODFI_account_number_ACH_company_ID_con__c, Credit_debit_indicator__c, Amount_paid__c, Gross_amount__c,Matching_string_for_Image_mapping__c, ';
            query = query+'Payment_method__c, Payment_method_type_code__c, Sender_payment_reference_number__c, Processing_system_reference_number__c, Wells_Fargo_reference_number__c, Deposit_settlement_date__c, Payment_effective_date__c, Transaction_processing_date_time__c, Currency_entity_identifier_code__c, Currency_code__c, Exchange_rate__c, Additional_entity_identifier_code__c,';
            query = query+'Additional_currency_code__c, Currency_market_exchange_code__c, Reference_1_qualifier_description__c, Reference_1_description__c, Reference_1_PR22B__c, Reference_2_qualifier_description_PR__c, Reference_2_description__c, Reference_2__c, Reference_3_qualifier_description__c, Reference_3__c, Reference_4_qualifier_description__c, Reference_4__c, Reference_5__c,';
            query = query+'Reference_6__c, Custom_Amount_1__c, MCA_Amount_Paid__c, MCA_Gross_Amount__c, Reversal_Reason_Code__c, WF_BH__c, Temp_BH__c, Payment_Status__c, Payment__c FROM WF_PR__c limit 49999';//where (Send_to_Grade__c > 0 or Send_to_Portal__c > 0)
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<WF_PR__c> Scope)
    {
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        cp.Create_payment(Scope);
    }
    global void Finish(Database.BatchableContext BC)
    {
    }
}