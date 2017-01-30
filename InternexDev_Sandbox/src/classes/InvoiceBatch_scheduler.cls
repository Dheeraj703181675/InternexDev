global class InvoiceBatch_scheduler implements Schedulable{
	 global void execute(SchedulableContext ctx) {
        Invoice_Akritiv_to_Portal_Batch IB = new Invoice_Akritiv_to_Portal_Batch();
        Database.executeBatch(IB,1);
    }
}