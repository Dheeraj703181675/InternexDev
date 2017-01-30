global class LockboxScheduler {
    global void execute(SchedulableContext ctx) {
        LockboxBatch CB = new LockboxBatch();
        Database.executeBatch(CB,1);
    }
}