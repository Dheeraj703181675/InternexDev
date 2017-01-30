public class SaveAndNew
{
private ApexPages.StandardController con; 
public SaveAndNew(ApexPages.StandardController stdController)
 { 
con = stdController; 
 }
 public PageReference saveNew()
 {
 con.save();
 Schema.DescribeSObjectResult describeResult = con.getRecord().getSObjectType().getDescribe(); 
 PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e'); 
 pr.setRedirect(true);
 return pr; 
 }
 
 }