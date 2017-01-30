global class Schedule_Interest_calculationBatch implements Schedulable{
    global void execute(SchedulableContext SC)
    {
        InterestcalculationBatch IC = new InterestcalculationBatch();
        database.executeBatch(IC, 1);
    }
}