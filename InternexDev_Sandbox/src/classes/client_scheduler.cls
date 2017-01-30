global class client_scheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        Clientbatch_Akrtiv_to_Grade_portal CB = new Clientbatch_Akrtiv_to_Grade_portal();
        Database.executeBatch(CB,1);
    }
}