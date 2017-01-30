trigger trgonDBANames on DBA_Name__c (after Insert,after Update,after delete) {
    if(Trigger.isAfter)
    {
        system.debug('==> DBA After Trigger Start<===');
        Set<Id> DebtorIDset = new Set<Id>();
        if(Trigger.isUpdate || Trigger.isInsert)
        {
            for(DBA_Name__c DBA : Trigger.New){
                if(DBA.Debtor__c != NULL)
                {
                    DebtorIDset.add(DBA.Debtor__c);
                }
            }
        }
        if(Trigger.isDelete)
        {
            for(DBA_Name__c DBA : Trigger.old){
                if(DBA.Debtor__c != NULL)
                {
                    DebtorIDset.add(DBA.Debtor__c);
                }
            }
        }
        Map<string,Double> DBAcountfor_Grade = new Map<string,Double>();
        Map<string,Double> DBAcountfor_Portal = new Map<string,Double>();
        for(AggregateResult DBANames : [select COUNT(id) IC,Debtor__c Debtor from DBA_Name__c where Debtor__c in : DebtorIDset and Grade_External_ID__c =: NULL group by Debtor__c])
        {
            DBAcountfor_Grade.put((Id)DBANames.get('Debtor'),(Double)DBANames.get('IC'));
        }
        for(AggregateResult DBANames : [select COUNT(id) IC,Debtor__c Debtor from DBA_Name__c where Debtor__c in : DebtorIDset and Portal_External_ID__c =: NULL group by Debtor__c])
        {
            DBAcountfor_Portal.put((Id)DBANames.get('Debtor'),(Double)DBANames.get('IC'));
        }
        List<Debtor__c> Debtor_list_toUpdate = new List<Debtor__c>();
        for(Debtor__c Deb : [Select id, DBA_Count_for_Grade__c,DBA_Count_for_Portal__c from Debtor__c where id in: DebtorIDset])
        {
            Deb.DBA_Count_for_Grade__c = DBAcountfor_Grade.get(Deb.Id);
            Deb.DBA_Count_for_Portal__c = DBAcountfor_Portal.get(Deb.Id);
            Debtor_list_toUpdate.add(Deb);
        }
        try
        {
            update Debtor_list_toUpdate;
        }Catch(Exception e){System.debug('Exception e==> '+ e);}
        system.debug('==> DBA After Trigger End<===');
    }
}