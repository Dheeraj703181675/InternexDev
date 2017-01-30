trigger trgonQbCustomer on QB_Customer__c (After Insert,After Update,After Delete) {
if(Trigger.isAfter)
{
    set<ID> Debtorset = new Set<ID>();
     //When adding new Customer or updating existing Customer
            if(Trigger.isUpdate || Trigger.isInsert)
            {
                for(QB_Customer__c Customer: Trigger.new)
                {
                    Debtorset.add(Customer.Debtor__c);
                }
            }
            // when deleting the Customer
            if(Trigger.isDelete)
            {
                for(QB_Customer__c Customer: Trigger.old)
                {
                    Debtorset.add(Customer.Debtor__c);
                }
            }
        Map<String,String> debtormap_Customer = new Map<string,String>();
        for(QB_Customer__c QC : [select id,Debtor__c from QB_Customer__c where Debtor__c IN : Debtorset])
        {
            debtormap_Customer.put(Qc.Debtor__c , QC.id);
        }
        List<Debtor__c> Debtor_list_toUpdate = new List<Debtor__c>();
        for(Debtor__c Debtor : [Select Id,QB_Customer__c from Debtor__c where Id IN :Debtorset])
        {
             Debtor.QB_Customer__c = debtormap_Customer.get(Debtor.ID);
             Debtor_list_toUpdate.add(Debtor);
        }
        try{Update Debtor_list_toUpdate;}catch(Exception e){system.debug('Exception e ==> '+ e);}
}
}