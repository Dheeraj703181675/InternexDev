@istest
public class TestLockBox
{
    static testmethod void lockbox()
    {
        
         WF_FH__c TestFH = new  WF_FH__c();
        insert TestFH;
        
        WF_BH__c TestBH = new WF_BH__c();
        TestBH.WF_FH__c = TestFH.Id;
        TestBH.PTH_Lockbox_number__c='5tt';
        TestBH.PTH_RDFI_account_number__c='ty5';
        TestBH.PTH_RDFI_R_T__c='hggh4';
        TestBH.BH_Batch_number__c = '1000';
        // TestBH.LB_Number__c='fgf4';
        insert TestBH;
        
        WF_PR__c wf = new WF_PR__c();
        wf.Amount_paid__c =100;
        wf.WF_BH__c = TestBH.Id;
        
       // wf.IsDeleted = false;
      //  wf.Name = 'abc';
        wf.CurrencyIsoCode ='INR';
       // wf.SystemModstamp = system.now();
        wf.Record_ID__c= 'rec';
        wf.Item_sequence_number__c = 'seq';
        wf.ODFI_RTN__c ='rtn';
        wf.ODFI_account_number_ACH_company_ID_con__c='acc';
        wf.Credit_debit_indicator__c='creditDebit';
        wf.Amount_paid__c=100;
        wf.Gross_amount__c=200;
        wf.Payment_method__c='ACH';
        wf.Payment_method_type_code__c='D';
        wf.Sender_payment_reference_number__c='num';
        wf.Processing_system_reference_number__c='pro';
        wf.Wells_Fargo_reference_number__c='wells';
        wf.Deposit_settlement_date__c=date.today();
        wf.Payment_effective_date__c=date.today();
        wf.Transaction_processing_date_time__c=system.now();
        wf.Currency_entity_identifier_code__c='code';
        wf.Currency_code__c='INR';
        wf.Exchange_rate__c=10;
        wf.Additional_entity_identifier_code__c='add';
        wf.Additional_currency_code__c='currency';
        wf.Currency_market_exchange_code__c='mar';
        wf.Reference_1_qualifier_description__c='des';
        wf.Reference_1_description__c='reff';
        wf.Reference_1_PR22B__c='Account Number';
        wf.Reference_2_qualifier_description_PR__c='pr';
        wf.Reference_2_description__c='desc';
        wf.Reference_2__c='Batch ID';
        wf.Reference_3_qualifier_description__c='abbbvvd';
        wf.Reference_3__c='ddd';
        wf.Reference_4_qualifier_description__c='fff';
        wf.Reference_4__c='jjj';
        wf.Reference_5__c='fibe';
        wf.Reference_6__c ='ref';
        wf.Custom_Amount_1__c=10;
        wf.MCA_Amount_Paid__c=100;
        wf.Gross_amount__c=200;
        wf.Reversal_Reason_Code__c='rev';
        wf.Temp_BH__c='temp';
        wf.Payment_Status__c='valid'; 
        insert wf;
        
         Test.startTest();
        SchedulableContext ctx;
        LockboxScheduler IB = new LockboxScheduler();
        IB.execute(ctx);
       
        Test.stopTest(); 
        
        
        
    }

}