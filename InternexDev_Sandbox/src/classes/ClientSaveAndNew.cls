public class ClientSaveAndNew
{
private ApexPages.StandardController con; 
//public akritiv__Brand__c con{get;set;}
public ClientSaveAndNew(ApexPages.StandardController stdController)
 { 
//con = (akritiv__Brand__c)stdController.getRecord();
con = stdController;
 }
 public PageReference saveAndNew()
 {
 try{
 con.save();
 //insert con;
 Schema.DescribeSObjectResult describeResult = con.getRecord().getSObjectType().getDescribe(); 
 PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e'); 
 pr.setRedirect(true);
 return pr; 
 }catch(exception e){system.debug('Exception--> '+ e);return null;}
 }

 
 }