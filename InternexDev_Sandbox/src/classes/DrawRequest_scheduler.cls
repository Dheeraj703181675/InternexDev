global class DrawRequest_scheduler implements Schedulable{
	global void execute(SchedulableContext ctx)
    {
        DrawRequestBatch_AkritivtoGrade_Portal DBA = new DrawRequestBatch_AkritivtoGrade_Portal();
        Database.executeBatch(DBA,1);
    }
}