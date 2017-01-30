global class PaymentsandFundingAllocation_Scheduler implements Schedulable{
	global void execute(SchedulableContext ctx) {
        Payments_ToP5_Batch PB = new Payments_ToP5_Batch();
        Database.executeBatch(PB,1); 
     /*   Paymentstoportal_1 PB = new Paymentstoportal_1();
        Database.executeBatch(PB,1);*/
    }
}