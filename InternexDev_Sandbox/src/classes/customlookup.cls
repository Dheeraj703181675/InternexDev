public with sharing class customlookup {
 public List<debtor__C> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string clientaccountid;
    
  public customlookup() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    clientaccountid = System.currentPageReference().getParameters().get('CAID');
    system.debug('clientaccountid-->'+clientaccountid  );
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<debtor__C> performSearch(string searchString) {

 if(clientaccountid!= '' && clientaccountid!= null)
 {
      String queryFields = '';
     for(Schema.FieldSetMember f : SObjectType.debtor__C.FieldSets.Debtor_FieldSets.getFields()) {
            if(queryFields.length() > 0) {
                queryFields += ', ';
            }
            queryFields += f.getFieldPath();
        }
 
     String soql = 'select id,Name,'+ queryFields+' from debtor__C';
    if(clientaccountid!= '' && clientaccountid!= null)
     soql = soql + ' where Client_Account__c = \''+clientaccountid+'\'';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and name LIKE \'%' + searchString +'%\'';
    
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 
 }

return null;
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}