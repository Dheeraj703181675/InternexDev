global class InterestBatchScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        InterestcalculationBatch IB = new InterestcalculationBatch();
        Database.executeBatch(IB,1);
    }
}