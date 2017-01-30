global class DBAName_Scheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        DBAName_Batch DBABatch = new DBAName_Batch();
        Database.executeBatch(DBABatch,1);
    }
}