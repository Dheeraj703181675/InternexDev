global class ClientAccount_scheduler implements Schedulable{
	global void execute(SchedulableContext ctx) {
        ClientAccountBatch_AkritivtoGradePortal CAB = new ClientAccountBatch_AkritivtoGradePortal();
        Database.executeBatch(CAB,1);
    }
}