public with sharing class ClientController {

public akritiv__Brand__c Client{get;set;}
Public string CounterPartyId{get;set;}
Public Boolean Exc{get;set;}
    public ClientController(ApexPages.StandardController controller) {
    
        Client = (akritiv__Brand__c)controller.getRecord();
        if(Client.CounterParty__c != NULL)
        {
             Client.Name = [Select id,name from Account where ID =: Client.CounterParty__c Limit 1].Name;
        }
        Exc = False;
    }
    Public void FillClientName()
    {
        system.debug('===> '+CounterPartyId);
        Client.Name = CounterPartyId;
    }
    Public PageReference SaveClient()
    {
        try
        {
            Insert Client;
            return new pagereference('/'+Client.Id);
        }Catch(Exception e){system.debug('Exception => '+ e);
        Exc = True;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
            
        }
        return Null;
    }
    Public PageReference SaveandNew()
    {
        try
        {
            Insert Client;
            PageReference pageRef = new PageReference('/apex/ClientNewpage');
            pageRef.setRedirect(true);
            return pageRef;
            
        }Catch(Exception e){system.debug('Exception => '+ e);
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,string.valueof(e.getMessage())));
                           }
        return Null;
    }
    Public PageReference Cancel()
    {
         Schema.DescribeSObjectResult result =akritiv__Brand__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
             
            pageRef.setRedirect(true);
            return pageRef;
    }
}