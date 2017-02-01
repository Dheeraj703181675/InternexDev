trigger trgonPricing on Pricing__c (before Insert,after insert) {
    if(Trigger.isBefore)
    {
        set<string> Indexset = new Set<string>();
        for( Pricing__c Pr : Trigger.new)
        {
            pr.Active__c = true;
            Indexset.add(Pr.Index__c);
        }
         List<Pricing__c> Pricelist_update = new List<Pricing__c>();
        List<Pricing__c> Pricelist = [Select id,name,Index__c,Date__c,End_Date__c,Active__c,Rate__c,Month__c,Year__c,Business_Transaction_Date__c from Pricing__c where Index__c in : Indexset order By Date__c desc];
        for( Pricing__c Pr : Trigger.new)
        {
            for(Pricing__c Price : Pricelist)
            {
                if(pr.Index__c == Price.Index__c && Price.Date__c < Pr.Date__c)
                {
                    Price.Active__c = false;
                    Price.End_Date__c = Pr.Date__c - 1;
                    Pricelist_update.add(Price);
                }
            }
        }
        try{
            if(Pricelist_update.size() > 0)
            {
                update Pricelist_update;
            }
        }Catch(exception e){system.debug('Exception ==> '+ e);}
    }
}