/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   : Avoid Duplicate Entries.
 * Usage   : updating the flags to know the integration status
 * Usage   : Stamp the Business Transaction Date from customsettings.
*/ 
trigger trgonproduct on Product__c (Before Insert,Before Update) {

    if(Trigger.isBefore)
    {
        // =============== Stamp the Business Transaction Date from customsettings ==========//
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(Product__c Prod : Trigger.New)
            {
                if(BsnsTransact != Null && Trigger.isInsert)
                {
                    Prod.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
            }
        }
        //============== To avoid Duplicate Entries ==========================//
        Map<String, Id> Productmap = new Map<String, Id>();

        Set<String> product_set = new Set<String>();
       for(Product__c product: Trigger.New)
            product_set.add(Product.Name);

        for(Product__c prod :[SELECT Id, Name FROM Product__c WHERE Name IN : product_set])
            Productmap.put(Prod.name, prod.Id);

        for(Product__c product: Trigger.New)
        {
            If(Trigger.IsInsert)
            {
                if(Productmap.containsKey(Product.name))
                    Product.addError(
                        'Product already exists. ' + 
                     'Refer: <a href=\'/' + 
                     Productmap.get(Product.Name) + '\'>' + 
                     Product.Name+ '</a>',
                     false
                             );
            }                
            else if(Trigger.IsUpdate)
            {
             if(Productmap.containsKey(Product.name) && Productmap.get(Product.name) != product.Id)
                 Product.addError(
                     'Product already exists.    ' + 
                     'Refer: <a href=\'/' + 
                     Productmap.get(Product.Name) + '\'>' + 
                     Product.Name+ '</a>',
                     false
                 );
             
            }  
        }
        //=========== updating the flags =====================//
        if(Trigger.IsUpdate)
        {
       //     profile p = [select id from profile where name = 'Integration Admin'];
       //     system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
       //     if(p.Id != userinfo.getProfileId())
       //     {
                for(Product__c Prod : Trigger.New)
                {
                    if(Prod.Profile_Name__c != 'Integration Admin')
                    {
                        Prod.Sync_with_Grade__c = False;
                        Prod.Sync_with_Market_Place__c = False;
                        Prod.Sync_with_Portal__c = False;
                    }
                }
        //    }
        }
   }
}