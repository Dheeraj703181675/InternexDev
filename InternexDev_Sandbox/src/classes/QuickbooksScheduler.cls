global class QuickbooksScheduler implements Schedulable {
	global void execute(SchedulableContext ctx) {
        QBCustomerandInvoiceBatch CB = new QBCustomerandInvoiceBatch();
        Database.executeBatch(CB,1);
    }
}