@istest
public class TestCreate_payment_from_Lockbox 
{
    static testmethod void DrawReqBatch()
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
        
        WF_PR__c TestPR = new WF_PR__c();
        TestPR.CurrencyIsoCode='USD';
        TestPR.WF_BH__c = TestBH.Id;
        TestPR.Payment_method__c = 'ACH';
        TestPR.Item_sequence_number__c = '1';
        // TestPR.Payment_Status__c='None';
        insert TestPR;
        
        List<WF_PR__c> mylist = new List<WF_PR__c>();
        mylist.add(TestPR);
        
        WF_PPR__c TestPPR = new WF_PPR__c();
        TestPPR.WF_PR__c=TestPR.Id;
        // TestPPR.WF_PR__c='a1b61000001YepOAAS';
        
        TestPPR.Name__c='abcd';
        TestPPR.Postal_code__c='ghg3';
        insert TestPPR;
        
        WF_RMH__c RMH = new WF_RMH__c();
        RMH.Remittance_sequence_number__c = 123;
        RMH.WF_PR__c = TestPR.Id;
        insert RMH;
        
        WF_REM__c REM = new WF_REM__c();
        REM.Remittance_net_amount_paid__c = 10;
        REM.Reference_2__c = 'TestInv';
        REm.WF_RMH__c = RMH.id;
        insert REM;
        
        Lockbox_Image__c TestLockbox = new Lockbox_Image__c();
        TestLockbox.Image_Name__c = '20161609.123.tt.10000001C.tif';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        insert TestLockbox;
        
        Account TestAcc = new Account();
        TestAcc.Name ='Lockbox Account';
        TestAcc.AccountNumber = '00qsw';
        TestAcc.akritiv__Account_Key__c = 'key001' ;
        TestAcc.Funding_Limit__c = 100000;
        TestAcc.Email__c = 'abc@gmail.com';
        TestAcc.PAN_TAN__c = '123456789';
        TestAcc.BillingState = 'NY';
        TestAcc.BillingPostalCode = '99999';
        TestAcc.Funding_Limit__c = 100000;
        insert TestAcc;
        
        Account TestAcc1 = new Account();
        TestAcc1.Name ='abcd';
        TestAcc1.AccountNumber = '040qsw';
        TestAcc1.akritiv__Account_Key__c = 'key3001' ;
        TestAcc1.Funding_Limit__c = 500000;
        TestAcc1.Email__c = 'abcd@gmail.com';
        TestAcc1.PAN_TAN__c = '133456789';
        TestAcc1.BillingState = 'NY';
        TestAcc1.BillingPostalCode = '99999';
        TestAcc1.Funding_Limit__c = 300000;
        insert TestAcc1;
        
        
        Product__c testProduct = new Product__c();
        testProduct.Name = 'LOC';
        insert testProduct;
        
        akritiv__Brand__C TestClient = new akritiv__Brand__C();
        TestClient.CounterParty__c = TestAcc.Id;
        TestClient.Name = TestAcc.Name;
        insert TestClient;
        
        Client_Account__c testCA = new Client_Account__c();
        testCA.Client__c = TestClient.Id;
        testCA.Product__c = testProduct.Id;
        testCA.Funding_Limit__c = 100000;
        testCA.Commitment__c = 1000;
        testCA.Commitment_rate__c = 3.5;
        testCA.Index__c = 'WS Prime';
        testCA.Method__c = '360/Actual';
        testCA.Rate_Type__c = 'Fixed';
        testCA.Spread__c = 5;
        testCA.Rate__c = 10;
        testCA.Index_Value__c = 0;
        testCA.Borrowing_Base_Reserve__c = 0;
        testCA.Minimum_Drawal_Fee__c = 100;
        testCA.Minimum_Origination_Fee__c = 100;
        testCA.Drawal_Fee_Percentage__c = 8;
        testCA.Origination_Fee_Percentage__c = 6;
        insert testCA;
        
        LockBox_Account__c TestLA = new LockBox_Account__c();
        TestLA.Client_Account__c=testCA.Id;
        TestLA.Lockbox_Number__c='tt';
        TestLA.Account_Number__c='ty5';
        TestLA.Routing_Number__c='hggh4';
        TestLA.Street_Address__c='ghh5';
        TestLA.Zip_Code__c='99999';
        insert TestLA;
        
        
        Debtor__c testdebtor= new Debtor__c();
        //  testdebtor.Debtor_Name__c='FGF3';
        testdebtor.Client_Account__c = testCA.Id;
        testdebtor.Counterparty__c = TestAcc1.Id;
        testdebtor.Dilution__c = 4;
        testdebtor.Funding_Limit__c = 40000;
        testdebtor.Concentration_Limit__c = 40;
        testdebtor.Eligible_AR__c = 2000;
        testdebtor.Borrowing_Base_Reserve__c = 0;
        testdebtor.Max_Credit_Period__c = 80;
        testdebtor.Debtor_Status__c = 'Eligible';
        insert testdebtor;
        
        akritiv__Transaction__c INV = new akritiv__Transaction__c();
        INV.Name = 'TestInv';
        Inv.Debtor__c = testdebtor.id;
        Inv.akritiv__Amount__c = 10000;
        Inv.akritiv__Create_Date__c = date.today();
        Inv.akritiv__Due_Date__c = date.today();
        Inv.Invoice_Status_Internex__c = 'Approved';
        insert Inv;
        
        akritiv__Payment__c testPayment = new akritiv__Payment__c();
        testPayment.Name = 'Ankima Payment';
        testPayment.Debtor__c = testdebtor.Id;
        
        testPayment.Client_Account__c = testCA.Id;
        testPayment.akritiv__Payment_Date__c=Date.today();
        testPayment.akritiv__Amount__c= 15000;
        testPayment.Sync_with_Grade__c= false;
        testPayment.Sync_with_Portal__c=false;
        testPayment.akritiv__Payment_Type__c = 'Manual';
        testPayment.Payment_Status__c='Unidentified';
        testPayment.Lockbox_Payment_akritiv_ID__c= TestPR.Id;
        insert testPayment;
        
        test.startTest();
        List<WF_PR__c> mylist_new = new List<WF_PR__c>();
         mylist_new = [SELECT Id, Name, CreatedDate,Record_ID__c, Item_sequence_number__c, ODFI_RTN__c, ODFI_account_number_ACH_company_ID_con__c,Amount_paid_formula__c,Matching_string_for_Image_mapping__c, 
                                 Credit_debit_indicator__c, Amount_paid__c, Gross_amount__c, Payment_method__c, Payment_method_type_code__c, Sender_payment_reference_number__c, 
                                 Processing_system_reference_number__c, Wells_Fargo_reference_number__c, Deposit_settlement_date__c, Payment_effective_date__c, Transaction_processing_date_time__c, 
                                 Currency_entity_identifier_code__c, Currency_code__c, Exchange_rate__c, Additional_entity_identifier_code__c, Additional_currency_code__c, Currency_market_exchange_code__c,
                                 Reference_1_qualifier_description__c, Reference_1_description__c, Reference_1_PR22B__c, Custom_Amount_1__c, MCA_Amount_Paid__c, 
                                 MCA_Gross_Amount__c, Reversal_Reason_Code__c, WF_BH__c, Temp_BH__c, Payment_Status__c, Payment__c FROM WF_PR__c where Id =: TestPR.id];
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        CP.Create_payment(mylist_new);
        test.stopTest();
    }
    static testmethod void DrawreqBatch2()
    {
         test.startTest();
        Account TestAcc = new Account();
        TestAcc.Name ='Lockbox Account';
        TestAcc.AccountNumber = '00qsw';
        TestAcc.akritiv__Account_Key__c = 'key001' ;
        TestAcc.Funding_Limit__c = 100000;
        TestAcc.Email__c = 'abc@gmail.com';
        TestAcc.PAN_TAN__c = '123456789';
        TestAcc.BillingState = 'NY';
        TestAcc.BillingPostalCode = '99999';
        TestAcc.Funding_Limit__c = 100000;
        insert TestAcc;
        
        Account TestAcc1 = new Account();
        TestAcc1.Name ='abcd';
        TestAcc1.AccountNumber = '040qsw';
        TestAcc1.akritiv__Account_Key__c = 'key3001' ;
        TestAcc1.Funding_Limit__c = 500000;
        TestAcc1.Email__c = 'abcd@gmail.com';
        TestAcc1.PAN_TAN__c = '133456789';
        TestAcc1.BillingState = 'NY';
        TestAcc1.BillingPostalCode = '99999';
        TestAcc1.Funding_Limit__c = 300000;
        insert TestAcc1;
        
        
        Product__c testProduct = new Product__c();
        testProduct.Name = 'LOC';
        insert testProduct;
        
        akritiv__Brand__C TestClient = new akritiv__Brand__C();
        TestClient.CounterParty__c = TestAcc.Id;
        TestClient.Name = TestAcc.Name;
        insert TestClient;
        
        Client_Account__c testCA = new Client_Account__c();
        testCA.Client__c = TestClient.Id;
        testCA.Product__c = testProduct.Id;
        testCA.Funding_Limit__c = 100000;
        testCA.Commitment__c = 1000;
        testCA.Commitment_rate__c = 3.5;
        testCA.Index__c = 'WS Prime';
        testCA.Method__c = '360/Actual';
        testCA.Rate_Type__c = 'Fixed';
        testCA.Spread__c = 5;
        testCA.Rate__c = 10;
        testCA.Index_Value__c = 0;
        testCA.Borrowing_Base_Reserve__c = 0;
        testCA.Minimum_Drawal_Fee__c = 100;
        testCA.Minimum_Origination_Fee__c = 100;
        testCA.Drawal_Fee_Percentage__c = 8;
        testCA.Origination_Fee_Percentage__c = 6;
        insert testCA;
        
        LockBox_Account__c TestLA = new LockBox_Account__c();
        TestLA.Client_Account__c=testCA.Id;
        TestLA.Lockbox_Number__c='tt';
        TestLA.Account_Number__c='ty5';
        TestLA.Routing_Number__c='hggh4';
        TestLA.Street_Address__c='ghh5';
        TestLA.Zip_Code__c='99999';
        insert TestLA;
        
        
        Debtor__c testdebtor= new Debtor__c();
        //  testdebtor.Debtor_Name__c='FGF3';
        testdebtor.Client_Account__c = testCA.Id;
        testdebtor.Counterparty__c = TestAcc1.Id;
        testdebtor.Dilution__c = 4;
        testdebtor.Funding_Limit__c = 40000;
        testdebtor.Concentration_Limit__c = 40;
        testdebtor.Eligible_AR__c = 2000;
        testdebtor.Borrowing_Base_Reserve__c = 0;
        testdebtor.Max_Credit_Period__c = 80;
        testdebtor.Debtor_Status__c = 'Eligible';
        insert testdebtor;
        
        akritiv__Transaction__c INV = new akritiv__Transaction__c();
        INV.Name = 'TestInv';
        Inv.Debtor__c = testdebtor.id;
        Inv.akritiv__Amount__c = 10000;
        Inv.akritiv__Create_Date__c = date.today();
        Inv.akritiv__Due_Date__c = date.today();
        Inv.Invoice_Status_Internex__c = 'Approved';
        insert Inv;
        
        akritiv__Payment__c testPayment = new akritiv__Payment__c();
        testPayment.Name = 'Ankima Payment';
        testPayment.Debtor__c = testdebtor.Id;
        
        testPayment.Client_Account__c = testCA.Id;
        testPayment.akritiv__Payment_Date__c=Date.today();
        testPayment.akritiv__Amount__c= 15000;
        testPayment.Sync_with_Grade__c= false;
        testPayment.Sync_with_Portal__c=false;
        testPayment.akritiv__Payment_Type__c = 'Manual';
        testPayment.Payment_Status__c='Unidentified';
      //  testPayment.Lockbox_Payment_akritiv_ID__c= TestPR.Id;
        insert testPayment;
        
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
        
        WF_PR__c TestPR = new WF_PR__c();
        TestPR.CurrencyIsoCode='USD';
        TestPR.WF_BH__c = TestBH.Id;
        TestPR.Payment_method__c = 'ACH';
        TestPR.Item_sequence_number__c = '1';
        TestPR.Payment__c = testPayment.id;
        // TestPR.Payment_Status__c='None';
        insert TestPR;
        
        List<WF_PR__c> mylist = new List<WF_PR__c>();
        mylist.add(TestPR);
        
        WF_PPR__c TestPPR = new WF_PPR__c();
        TestPPR.WF_PR__c=TestPR.Id;
        // TestPPR.WF_PR__c='a1b61000001YepOAAS';
        
        TestPPR.Name__c='abcd';
        TestPPR.Postal_code__c='ghg3';
        insert TestPPR;
        
        WF_RMH__c RMH = new WF_RMH__c();
        RMH.Remittance_sequence_number__c = 123;
        RMH.WF_PR__c = TestPR.Id;
        insert RMH;
        
        WF_REM__c REM = new WF_REM__c();
        REM.Remittance_net_amount_paid__c = 10;
        REM.Reference_2__c = 'TestInv';
        REm.WF_RMH__c = RMH.id;
        insert REM;
        test.stopTest();
       
    }
    static testmethod void DrawReqBatch3()
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
        
        WF_PR__c TestPR = new WF_PR__c();
        TestPR.CurrencyIsoCode='USD';
        TestPR.WF_BH__c = TestBH.Id;
        
        TestPR.Payment_method__c = 'CHK';
        TestPR.Item_sequence_number__c = '1';
        // TestPR.Payment_Status__c='None';
        insert TestPR;
        
        List<WF_PR__c> mylist = new List<WF_PR__c>();
        mylist.add(TestPR);
        
        WF_PPR__c TestPPR = new WF_PPR__c();
        TestPPR.WF_PR__c=TestPR.Id;
        // TestPPR.WF_PR__c='a1b61000001YepOAAS';
        
        TestPPR.Name__c='abcd';
        TestPPR.Postal_code__c='ghg3';
        insert TestPPR;
        
        WF_RMH__c RMH = new WF_RMH__c();
        RMH.Remittance_sequence_number__c = 123;
        RMH.WF_PR__c = TestPR.Id;
        insert RMH;
        
        WF_REM__c REM = new WF_REM__c();
        REM.Remittance_net_amount_paid__c = 10;
        REM.Reference_2__c = 'TestInv';
        REm.WF_RMH__c = RMH.id;
        insert REM;
        
        Lockbox_Image__c TestLockbox = new Lockbox_Image__c();
        TestLockbox.Image_Name__c = '20161609.123.tt.10000001C.tif';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        insert TestLockbox;
        
        Account TestAcc = new Account();
        TestAcc.Name ='Lockbox Account';
        TestAcc.AccountNumber = '00qsw';
        TestAcc.akritiv__Account_Key__c = 'key001' ;
        TestAcc.Funding_Limit__c = 100000;
        TestAcc.Email__c = 'abc@gmail.com';
        TestAcc.PAN_TAN__c = '123456789';
        TestAcc.BillingState = 'NY';
        TestAcc.BillingPostalCode = '99999';
        TestAcc.Funding_Limit__c = 100000;
        insert TestAcc;
        
        Account TestAcc1 = new Account();
        TestAcc1.Name ='acc';
        TestAcc1.AccountNumber = '040qsw';
        TestAcc1.akritiv__Account_Key__c = 'key3001' ;
        TestAcc1.Funding_Limit__c = 500000;
        TestAcc1.Email__c = 'abcd@gmail.com';
        TestAcc1.PAN_TAN__c = '133456789';
        TestAcc1.BillingState = 'NY';
        TestAcc1.BillingPostalCode = '99999';
        TestAcc1.Funding_Limit__c = 300000;
        insert TestAcc1;
        
        
        Product__c testProduct = new Product__c();
        testProduct.Name = 'LOC';
        insert testProduct;
        
        akritiv__Brand__C TestClient = new akritiv__Brand__C();
        TestClient.CounterParty__c = TestAcc.Id;
        TestClient.Name = TestAcc.Name;
        insert TestClient;
        
        Client_Account__c testCA = new Client_Account__c();
        testCA.Client__c = TestClient.Id;
        testCA.Product__c = testProduct.Id;
        testCA.Funding_Limit__c = 100000;
        testCA.Commitment__c = 1000;
        testCA.Commitment_rate__c = 3.5;
        testCA.Index__c = 'WS Prime';
        testCA.Method__c = '360/Actual';
        testCA.Rate_Type__c = 'Fixed';
        testCA.Spread__c = 5;
        testCA.Rate__c = 10;
        testCA.Index_Value__c = 0;
        testCA.Borrowing_Base_Reserve__c = 0;
        testCA.Minimum_Drawal_Fee__c = 100;
        testCA.Minimum_Origination_Fee__c = 100;
        testCA.Drawal_Fee_Percentage__c = 8;
        testCA.Origination_Fee_Percentage__c = 6;
        insert testCA;
        
        LockBox_Account__c TestLA = new LockBox_Account__c();
        TestLA.Client_Account__c=testCA.Id;
        TestLA.Lockbox_Number__c='tt';
        TestLA.Account_Number__c='ty5';
        TestLA.Routing_Number__c='hggh4';
        TestLA.Street_Address__c='ghh5';
        TestLA.Zip_Code__c='99999';
        insert TestLA;
        
        
        Debtor__c testdebtor= new Debtor__c();
        //  testdebtor.Debtor_Name__c='FGF3';
        testdebtor.Client_Account__c = testCA.Id;
        testdebtor.Counterparty__c = TestAcc1.Id;
        testdebtor.Dilution__c = 4;
        testdebtor.Funding_Limit__c = 40000;
        testdebtor.Concentration_Limit__c = 40;
        testdebtor.Eligible_AR__c = 2000;
        testdebtor.Borrowing_Base_Reserve__c = 0;
        testdebtor.Max_Credit_Period__c = 80;
        testdebtor.Debtor_Status__c = 'Eligible';
        insert testdebtor;
        
        akritiv__Transaction__c INV = new akritiv__Transaction__c();
        INV.Name = 'TestInv';
        Inv.Debtor__c = testdebtor.id;
        Inv.akritiv__Amount__c = 10000;
        Inv.akritiv__Create_Date__c = date.today();
        Inv.akritiv__Due_Date__c = date.today();
        Inv.Invoice_Status_Internex__c = 'Approved';
        insert Inv;
        
        akritiv__Payment__c testPayment = new akritiv__Payment__c();
        testPayment.Name = 'Ankima Payment';
        testPayment.Debtor__c = testdebtor.Id;
        
        testPayment.Client_Account__c = testCA.Id;
        testPayment.akritiv__Payment_Date__c=Date.today();
        testPayment.akritiv__Amount__c= 15000;
        testPayment.Sync_with_Grade__c= false;
        testPayment.Sync_with_Portal__c=false;
        testPayment.akritiv__Payment_Type__c = 'Manual';
        testPayment.Payment_Status__c='Unidentified';
        testPayment.Lockbox_Payment_akritiv_ID__c= TestPR.Id;
        insert testPayment;
        
        test.startTest();
         List<WF_PR__c> mylist_new = new List<WF_PR__c>();
         mylist_new = [SELECT Id, Name, CreatedDate,Record_ID__c, Item_sequence_number__c, ODFI_RTN__c, ODFI_account_number_ACH_company_ID_con__c,Amount_paid_formula__c,Matching_string_for_Image_mapping__c, 
                                 Credit_debit_indicator__c, Amount_paid__c, Gross_amount__c, Payment_method__c, Payment_method_type_code__c, Sender_payment_reference_number__c, 
                                 Processing_system_reference_number__c, Wells_Fargo_reference_number__c, Deposit_settlement_date__c, Payment_effective_date__c, Transaction_processing_date_time__c, 
                                 Currency_entity_identifier_code__c, Currency_code__c, Exchange_rate__c, Additional_entity_identifier_code__c, Additional_currency_code__c, Currency_market_exchange_code__c,
                                 Reference_1_qualifier_description__c, Reference_1_description__c, Reference_1_PR22B__c, Custom_Amount_1__c, MCA_Amount_Paid__c, 
                                 MCA_Gross_Amount__c, Reversal_Reason_Code__c, WF_BH__c, Temp_BH__c, Payment_Status__c, Payment__c FROM WF_PR__c where Id =: TestPR.id];
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        CP.Create_payment(mylist_new);

        test.stopTest();
    } 
    static testmethod void DrawReqBatch4()
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
        
        WF_PR__c TestPR = new WF_PR__c();
        TestPR.CurrencyIsoCode='USD';
        TestPR.WF_BH__c = TestBH.Id;
        
        TestPR.Payment_method__c = 'FWT';
        TestPR.Item_sequence_number__c = '1';
        // TestPR.Payment_Status__c='None';
        insert TestPR;
        
        List<WF_PR__c> mylist = new List<WF_PR__c>();
        mylist.add(TestPR);
        
        WF_PPR__c TestPPR = new WF_PPR__c();
        TestPPR.WF_PR__c=TestPR.Id;
        // TestPPR.WF_PR__c='a1b61000001YepOAAS';
        
        TestPPR.Name__c='abcd';
        TestPPR.Postal_code__c='ghg3';
        insert TestPPR;
        
        WF_RMH__c RMH = new WF_RMH__c();
        RMH.Remittance_sequence_number__c = 123;
        RMH.WF_PR__c = TestPR.Id;
        insert RMH;
        
        WF_REM__c REM = new WF_REM__c();
        REM.Remittance_net_amount_paid__c = 10;
        REM.Reference_2__c = 'TestInv';
        REm.WF_RMH__c = RMH.id;
        insert REM;
        
        Lockbox_Image__c TestLockbox = new Lockbox_Image__c();
        TestLockbox.Image_Name__c = '20161609.123.tt.10000001C.tif';
        //TestLockbox.Payment__c=testPayment.Id;
        //TestLockbox.WF_PR__c=TestPR.Id;
        // TestLockbox.Name='abc';
        insert TestLockbox;
        
        Account TestAcc = new Account();
        TestAcc.Name ='Lockbox Account';
        TestAcc.AccountNumber = '00qsw';
        TestAcc.akritiv__Account_Key__c = 'key001' ;
        TestAcc.Funding_Limit__c = 100000;
        TestAcc.Email__c = 'abc@gmail.com';
        TestAcc.PAN_TAN__c = '123456789';
        TestAcc.BillingState = 'NY';
        TestAcc.BillingPostalCode = '99999';
        TestAcc.Funding_Limit__c = 100000;
        insert TestAcc;
        
        Account TestAcc1 = new Account();
        TestAcc1.Name ='acc';
        TestAcc1.AccountNumber = '040qsw';
        TestAcc1.akritiv__Account_Key__c = 'key3001' ;
        TestAcc1.Funding_Limit__c = 500000;
        TestAcc1.Email__c = 'abcd@gmail.com';
        TestAcc1.PAN_TAN__c = '133456789';
        TestAcc1.BillingState = 'NY';
        TestAcc1.BillingPostalCode = '99999';
        TestAcc1.Funding_Limit__c = 300000;
        insert TestAcc1;
        
        
        Product__c testProduct = new Product__c();
        testProduct.Name = 'LOC';
        insert testProduct;
        
        akritiv__Brand__C TestClient = new akritiv__Brand__C();
        TestClient.CounterParty__c = TestAcc.Id;
        TestClient.Name = TestAcc.Name;
        insert TestClient;
        
        Client_Account__c testCA = new Client_Account__c();
        testCA.Client__c = TestClient.Id;
        testCA.Product__c = testProduct.Id;
        testCA.Funding_Limit__c = 100000;
        testCA.Commitment__c = 1000;
        testCA.Commitment_rate__c = 3.5;
        testCA.Index__c = 'WS Prime';
        testCA.Method__c = '360/Actual';
        testCA.Rate_Type__c = 'Fixed';
        testCA.Spread__c = 5;
        testCA.Rate__c = 10;
        testCA.Index_Value__c = 0;
        testCA.Borrowing_Base_Reserve__c = 0;
        testCA.Minimum_Drawal_Fee__c = 100;
        testCA.Minimum_Origination_Fee__c = 100;
        testCA.Drawal_Fee_Percentage__c = 8;
        testCA.Origination_Fee_Percentage__c = 6;
        insert testCA;
        
        
        
        LockBox_Account__c TestLA = new LockBox_Account__c();
        TestLA.Client_Account__c=testCA.Id;
        TestLA.Lockbox_Number__c='tt';
        TestLA.Account_Number__c='ty5';
        TestLA.Routing_Number__c='hggh4';
        TestLA.Street_Address__c='ghh5';
        TestLA.Zip_Code__c='99999';
        insert TestLA;
        
        
        Debtor__c testdebtor= new Debtor__c();
        //  testdebtor.Debtor_Name__c='FGF3';
        testdebtor.Client_Account__c = testCA.Id;
        testdebtor.Counterparty__c = TestAcc1.Id;
        testdebtor.Dilution__c = 4;
        testdebtor.Funding_Limit__c = 40000;
        testdebtor.Concentration_Limit__c = 40;
        testdebtor.Eligible_AR__c = 2000;
        testdebtor.Borrowing_Base_Reserve__c = 0;
        testdebtor.Max_Credit_Period__c = 80;
        testdebtor.Debtor_Status__c = 'Eligible';
        insert testdebtor;
        
        akritiv__Transaction__c INV = new akritiv__Transaction__c();
        INV.Name = 'TestInv';
        Inv.Debtor__c = testdebtor.id;
        Inv.akritiv__Amount__c = 10000;
        Inv.akritiv__Create_Date__c = date.today();
        Inv.akritiv__Due_Date__c = date.today();
        Inv.Invoice_Status_Internex__c = 'Approved';
        insert Inv;
        
        akritiv__Payment__c testPayment = new akritiv__Payment__c();
        testPayment.Name = 'Ankima Payment';
        testPayment.Debtor__c = testdebtor.Id;
        
        testPayment.Client_Account__c = testCA.Id;
        testPayment.akritiv__Payment_Date__c=Date.today();
        testPayment.akritiv__Amount__c= 15000;
        testPayment.Sync_with_Grade__c= false;
        testPayment.Sync_with_Portal__c=false;
        testPayment.akritiv__Payment_Type__c = 'Manual';
        testPayment.Payment_Status__c='Unidentified';
        testPayment.Lockbox_Payment_akritiv_ID__c= TestPR.Id;
        insert testPayment;
        
        test.startTest();
        List<WF_PR__c> mylist_new = new List<WF_PR__c>();
         mylist_new = [SELECT Id, Name, CreatedDate,Record_ID__c, Item_sequence_number__c, ODFI_RTN__c, ODFI_account_number_ACH_company_ID_con__c,Amount_paid_formula__c,Matching_string_for_Image_mapping__c, 
                                 Credit_debit_indicator__c, Amount_paid__c, Gross_amount__c, Payment_method__c, Payment_method_type_code__c, Sender_payment_reference_number__c, 
                                 Processing_system_reference_number__c, Wells_Fargo_reference_number__c, Deposit_settlement_date__c, Payment_effective_date__c, Transaction_processing_date_time__c, 
                                 Currency_entity_identifier_code__c, Currency_code__c, Exchange_rate__c, Additional_entity_identifier_code__c, Additional_currency_code__c, Currency_market_exchange_code__c,
                                 Reference_1_qualifier_description__c, Reference_1_description__c, Reference_1_PR22B__c, Custom_Amount_1__c, MCA_Amount_Paid__c, 
                                 MCA_Gross_Amount__c, Reversal_Reason_Code__c, WF_BH__c, Temp_BH__c, Payment_Status__c, Payment__c FROM WF_PR__c where Id =: TestPR.id];
        Create_payment_from_Lockbox CP = new Create_payment_from_Lockbox();
        CP.Create_payment(mylist_new);

        test.stopTest();
    } 
}