trigger trgonPaymentandFee on Payment_and_Fee__c (before delete,after delete) {
    system.debug('1231');
    if(Trigger.isAfter)
    {
        if(Trigger.isDelete)
        {
            set<string> Fee_Set = new set<String>();
            for(Payment_and_Fee__c PF : Trigger.old)
            {
                Fee_Set.add(PF.Fees__C);
            }
            Map<String,Double> FeeMap_balance = new Map<string,Double>();
            for(AggregateResult PF : [select COUNT(id) IC,Fees__c Fee,sum(Amount__c) amt from Payment_and_Fee__c where Fees__c IN : Fee_Set group by Fees__c])
            {
                FeeMap_balance.put((Id)PF.get('Fee'),(Double)PF.get('amt'));
            }
            list<Fees__c> Feelist_update = new List<Fees__c>();
            for(Fees__c Fee : [select id,Fee_Balance__c from Fees__c where id in : Fee_Set])
            {
                Fee.Fee_Balance__c = FeeMap_balance.get(Fee.id);
                Feelist_update.add(Fee);
            }
            try{update Feelist_update;}catch(Exception e){System.debug('Exception e--> '+e);}
        }
    }
}