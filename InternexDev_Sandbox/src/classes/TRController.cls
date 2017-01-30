/**
 * An apex page controller that exposes the save functionality
 */
public with sharing class TRController {
    public string InvoiceId{get;set;}
    Public string strmsg{get;set;}
    public akritiv__Transaction__c  TR;
    public TRController(ApexPages.StandardController stdController) {
              this.TR = (akritiv__Transaction__c)stdController.getRecord();
      }
    
     public void SaveTR()
     {
        TR.Closed_Invoice_with_Balance__c =True;
        InvoiceId = TR.id;
        try{
            update TR;
           // Pagereference pf = new Pagereference ('/'+TR.id);
           // Return pf; 
            strmsg='T';
            }
            catch(exception ex)
            {
          //  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
          //  ApexPages.addMessage(myMsg);
            system.debug('exception '+ ex);
            strmsg='S';
         //   return null;
            }
//       
        
    }    
}