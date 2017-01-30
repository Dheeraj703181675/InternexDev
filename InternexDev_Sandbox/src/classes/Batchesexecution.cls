public with sharing class Batchesexecution {

/*    public PageReference BorrowingBaseCalculations() {
        
        Clientbatch_Akrtiv_to_Grade_portal CAB = new Clientbatch_Akrtiv_to_Grade_portal();
        Database.executeBatch(CAB,1);
        
        return null;
    }
*/

    public Date BussineTransactionDate { get; set; }
    public PageReference InterestCalculation() {
    
        InterestcalculationBatch IC = new InterestcalculationBatch();
        database.executeBatch(IC, 1);
        return null;
    }


}