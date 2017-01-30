/* 
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   :   Test class for BatchPCAgingCalculations.
 */
    @isTest
    public class TestUpdateMaxCreditLimitOnParentAccount{
        
        static testMethod void testCase1(){
            akritiv__Trigger_Configuration__c triggerConf = akritiv__Trigger_Configuration__c.getOrgDefaults();  
            triggerConf.ManageUpdateMaxCreditLimitOnParentAccoun__c = true; 
            // triggerConf.ManageUpdateMaxCreditLimitOnParentAccoun__c= true; 
            upsert triggerConf;
            
            List<Account> childAccList1 = new List<Account>();
            Account tempParentAcc1 = new Account();
            tempParentAcc1 = insertParentAccount1();
            system.assertEquals(tempParentAcc1.name,'testParentAccount');
            
            Account tempChildAcc1 = new Account();
            childAccList1.addAll(insertChildAccount1(5));
            For(Account acc : childAccList1){
                acc.parentId = tempParentAcc1.id;
            }
            
            update childAccList1;
            
            tempParentAcc1.Risk_type__c = 'Add Account Notes';
            update tempParentAcc1;
        }

        static Account insertParentAccount1(){
            //create an Parent Account
            Account accObj11 = new Account(Name='testParentAccount');
            accObj11.Akritiv__Account_Key__c =''+(Math.random()* 1000000).intValue() + (Math.random()* 1000000).intValue();
            accObj11.ownerId = UserInfo.getUserId();
           	accObj11.Funding_Limit__c = 1000;
            accObj11.Email__c = (Math.random()* 1000000).intValue() + (Math.random()* 1000000).intValue()+'@testing.com';
            accObj11.PAN_TAN__c = '123456789';
            accObj11.BillingState = 'NY';
            accObj11.BillingPostalCode = '99999';
            accObj11.akritiv__credit_limit__c = 20000 ;
           
            insert accObj11;
            return accObj11;
        }
        
        static List<Account> insertChildAccount1(Integer count){
            //create an Child Account
            Account accObj11 = new Account();
            List<Account> lstOfAccounts11 = new List<Account>();
            for(Integer i = 0; i<5;i++){
                accObj11 = new Account();
                accObj11.Name='testChildAccount'+i;
                accObj11.Akritiv__Account_Key__c =''+(Math.random()* 1000000).intValue() + (Math.random()* 1000000).intValue();
                accObj11.ownerId = UserInfo.getUserId();
                
                accObj11.Funding_Limit__c = 1000;
                accObj11.Email__c = (Math.random()* 1000000).intValue() + (Math.random()* 1000000).intValue()+'@testing.com';
                accObj11.PAN_TAN__c = '123456789';
                accObj11.BillingState = 'NY';
                accObj11.BillingPostalCode = '99999';
                
                accObj11.akritiv__credit_limit__c = 20000 ;

                lstOfAccounts11.add(accObj11);
            }
            
            insert lstOfAccounts11;
            return lstOfAccounts11;
        }
}