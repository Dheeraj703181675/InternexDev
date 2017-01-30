@istest
public class TestclassforTransactionalData {
	static testmethod void method1()
    {
        WF_FH__c TestFH = new  WF_FH__c();
        insert TestFH;
        
        WF_BH__c TestBH = new WF_BH__c();
        TestBH.WF_FH__c = TestFH.Id;
        TestBH.PTH_Lockbox_number__c= 'HLBNo123';
        TestBH.PTH_RDFI_account_number__c='ty5';
        TestBH.PTH_RDFI_R_T__c='hggh4';
        TestBH.BH_Batch_number__c = 'B1';
        // TestBH.LB_Number__c='fgf4';
        insert TestBH;
        
        WF_PR__c TestPR = new WF_PR__c();
        TestPR.CurrencyIsoCode='USD';
        TestPR.WF_BH__c = TestBH.Id;
        TestPR.Payment_method__c = 'ACH';
        TestPR.Item_sequence_number__c = '1';
        TestPR.Reference_1_PR22B__c = 'T123';
        TestPR.Deposit_settlement_date__c = Date.today();
        // TestPR.Payment_Status__c='None';
        insert TestPR;
        
    //    system.assertEquals(TestPR.Matching_string_for_Image_mapping__c,'2016') ;
        
        list<Lockbox_Image__c> Limagelist = new List<Lockbox_Image__c>();
        Lockbox_Image__c TestLockbox = new Lockbox_Image__c();
        TestLockbox.Image_Name__c = 'FRNTIMAGE_test.jpg';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        Limagelist.add(TestLockbox);
        
        Lockbox_Image__c TestLockbox1 = new Lockbox_Image__c();
        TestLockbox1.Image_Name__c = 'REARIMAGE_test.jpg';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        Limagelist.add(TestLockbox1);
        
        Lockbox_Image__c TestLockbox2 = new Lockbox_Image__c();
        TestLockbox2.Image_Name__c = 'INVIMAGE_test.jpg';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        Limagelist.add(TestLockbox2);
        
        Lockbox_Image__c TestLockbox3 = new Lockbox_Image__c();
        TestLockbox3.Image_Name__c = 'WPIMAGE_test.jpg';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        Limagelist.add(TestLockbox3);
        insert Limagelist;
        
        WF_Envelope__c ENV = new WF_Envelope__c();
        ENV.Batch_No__c = 'B1';
        string mont = string.valueof(Date.today().Month()).length() == 1 ? '0'+string.valueof(Date.today().Month()) : string.valueof(Date.today().Month()) ;
        string customdate = string.valueof(Date.today().year())+ mont +string.valueof(Date.today().DAY());
        ENV.Date__c = customdate;
        ENV.LockBox_Account__c = 'LBNo12';
        ENV.Transaction_No__c = '123';
        insert ENV;
        
        WF_Transaction_Data__c WFT = new WF_Transaction_Data__c();
        WFT.Action__c = 'A';
        WFT.Check_Account_Number__c = 'CHK123';
        WFT.Check_Amount__c = '1.50';
        WFT.Check_Date__c = customdate;
        WFT.Check_RTN__c = 'CHKRTN123';
        WFT.Custom_Data__c = 'Custom Data';
        WFT.Deposit_date__c = customdate;
        WFT.Lockbox_no__c = 'LBNo12';
        WFT.Batch__c = 'B1';
        WFT.Transaction_Number__c = '123';
        
        WFT.Depository_Account__c = 'DA123';
        WFT.Front_image_file__c = 'FRNTIMAGE_test.jpg';
        WFT.Rear_Image_File__c = 'REARIMAGE_test.jpg';
        WFT.Invoice_amount__c = '1.50';
        WFT.Invoice_Number__c = 'INV123';
        WFT.Record_Type__c = 'CHK';
        WFT.Remitter_Name__c = 'REMIT123';
        WFT.Sequence_Number__c = '1';
        WFT.Serial_Number__c = 'SL12';
        insert WFT;
        
        WF_Invoice_Transactions__c WFIT = new WF_Invoice_Transactions__c();
        WFIT.Action__c = 'A';
        WFIT.Check_Account_Number__c = 'CHK123';
        WFIT.Check_Amount__c = '1.50';
        WFIT.Check_Date__c = customdate;
        WFIT.Check_RTN__c = 'CHKRTN123';
        WFIT.Custom_Data__c = 'Custom Data';
        WFIT.Deposit_date__c = customdate;
        WFIT.Lockbox_no__c = 'LBNo12';
        WFIT.Batch__c = 'B1';
        WFIT.Transaction_Number__c = '123';
        
        WFIT.Depository_Account__c = 'DA123';
        WFIT.Front_image_file__c = 'INVIMAGE_test.jpg';
        WFIT.Rear_Image_File__c = 'INVIMAGE_test.jpg';
        WFIT.Invoice_amount__c = '1.50';
        WFIT.Invoice_Number__c = 'INV123';
        WFIT.Record_Type__c = 'CHK';
        WFIT.Remitter_Name__c = 'REMIT123';
        WFIT.Sequence_Number__c = '1';
        WFIT.Serial_Number__c = 'SL12';
        insert WFIT;
        
        WF_WP_Transactions__c WFWPT = new WF_WP_Transactions__c();
        WFWPT.Action__c = 'A';
        WFWPT.Check_Account_Number__c = 'CHK123';
        WFWPT.Check_Amount__c = '1.50';
        WFWPT.Check_Date__c = customdate;
        WFWPT.Check_RTN__c = 'CHKRTN123';
        WFWPT.Custom_Data__c = 'Custom Data';
        WFWPT.Deposit_date__c = customdate;
        WFWPT.Lockbox_no__c = 'LBNo12';
        WFWPT.Batch__c = 'B1';
        WFWPT.Transaction_Number__c = '123';
        
        WFWPT.Depository_Account__c = 'DA123';
        WFWPT.Front_image_file__c = 'WPIMAGE_test.jpg';
        WFWPT.Rear_Image_File__c = 'WPIMAGE_test.jpg';
        WFWPT.Invoice_amount__c = '1.50';
        WFWPT.Invoice_Number__c = 'INV123';
        WFWPT.Record_Type__c = 'CHK';
        WFWPT.Remitter_Name__c = 'REMIT123';
        WFWPT.Sequence_Number__c = '1';
        WFWPT.Serial_Number__c = 'SL12';
        insert WFWPT;
  
    }
}