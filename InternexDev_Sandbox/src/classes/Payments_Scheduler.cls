global class Payments_Scheduler implements Schedulable{
	global void execute(SchedulableContext ctx) {
        Payments_Batch PB = new Payments_Batch();
        Database.executeBatch(PB,1);
    }
}