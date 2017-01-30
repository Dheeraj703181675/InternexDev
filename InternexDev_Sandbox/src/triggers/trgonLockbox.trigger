trigger trgonLockbox on LockBox_Account__c (Before insert,Before Update,After insert,After update,After Delete) {
if(Trigger.IsBefore)
{
    set<string> Account_Routing_Number_set = new set<string>();
    Map<String,LockBox_Account__c> Lb_map = new Map<String, LockBox_Account__c>();
    
     for(LockBox_Account__c LB : Trigger.New)
        Account_Routing_Number_set.add(LB.Account_Number__c + LB.Routing_Number__c);
        
     for(LockBox_Account__c LB : [Select id,name,Account_Number__c,Routing_Number__c from LockBox_Account__c where Account_Routing_Number__c in : Account_Routing_Number_set])
        Lb_map.put(LB.Account_Number__c + LB.Routing_Number__c,LB);
        
     for(LockBox_Account__c LB : Trigger.New)
     {
          If(Trigger.IsInsert)
            {
                if(Lb_map.containsKey(LB.Account_Number__c + LB.Routing_Number__c))
                {
                    LB.addError(
                        'Account and Routing Number combination already exists. ' + 
                     'Refer: <a href=\'/' + 
                     Lb_map.get(LB.Account_Number__c + LB.Routing_Number__c).id + '\'>' + 
                     Lb_map.get(LB.Account_Number__c + LB.Routing_Number__c).name+ '</a>',
                     false
                             );
              }
            }                
            else if(Trigger.IsUpdate)
            {
             if(Lb_map.containsKey(LB.Account_Number__c + LB.Routing_Number__c) && Lb_map.get(LB.Account_Number__c + LB.Routing_Number__c).id != LB.Id)
                 LB.addError(
                        'Account and Routing Number combination already exists. ' + 
                     'Refer: <a href=\'/' + 
                     Lb_map.get(LB.Account_Number__c + LB.Routing_Number__c).id + '\'>' + 
                     Lb_map.get(LB.Account_Number__c + LB.Routing_Number__c).Name+ '</a>',
                     false
                 );
             
            }  
     }   
}
if(Trigger.isAfter)
{
    set<Id> ClientProductId = new Set<Id>();
    if(Trigger.isUpdate || Trigger.isInsert)
    {
        for(LockBox_Account__c LB : Trigger.new)
        {
            ClientProductId.add(LB.Client_Account__c);
        }
    }
    if(Trigger.isDelete)
    {
        for(LockBox_Account__c LB : Trigger.old)
        {
            ClientProductId.add(LB.Client_Account__c);
        }
    }
    Map<String,Double> ClientAccountmap_Totalcount = new Map<string,Double>();
    for(AggregateResult PM : [select count(ID) LBC ,Client_Account__c CP from LockBox_Account__c where Client_Account__c IN : ClientProductId group by Client_Account__c])
    {
        ClientAccountmap_Totalcount.put((Id)PM.get('CP'),(Double)PM.get('LBC'));
    }
    List<Client_Account__c> ClientAccount_list_toUpdate = new List<Client_Account__c>();
    for(Client_Account__c CA : [Select Id,Lockbox_Accounts_count__c from Client_Account__c where Id IN : ClientProductId])
    {
        CA.Lockbox_Accounts_count__c = ClientAccountmap_Totalcount.get(CA.Id);
        ClientAccount_list_toUpdate.add(CA);
    }
    try{
              Update ClientAccount_list_toUpdate;
        }catch(Exception e){system.debug('Exception ==> '+ e);}
}
}