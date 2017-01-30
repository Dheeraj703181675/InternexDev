global class SendBusinessTransactionDate_scheduler implements Schedulable{
     // Execute method 
    global void execute(SchedulableContext SC) { 

    // Code to be executed when the schedule class wakes up 
        BusinessTransactionDate_batch CAB = new BusinessTransactionDate_batch();
        Database.executeBatch(CAB,1);

/*
    // this section of code will abort the current schedule job 
    try { 
    system.abortJob(sc.getTriggerId()); 
    } catch (exception e) {system.debug('#### schedule job exception while aborting:' + e);} 


    // reschedule the job 
    system.debug('#### schedule job executing'); 
    scheduleNow(); 
*/
    } 

/*
    global static void scheduleNow() { 

    // this section of code will schedule the next execution 1 minute from now 
    datetime thisTime = system.now().addHours(1); //
    integer minute = thisTime.minute(); 
    integer second = thisTime.second(); 
    integer hour = thisTime.hour(); 
    integer year = thisTime.year(); 
    integer month = thisTime.month(); 
    integer day = thisTime.day(); 

    String timeStamp = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year; 
    string jobName = 'Business Transaction Date'; 

	SendBusinessTransactionDate_scheduler p = new SendBusinessTransactionDate_scheduler(); 
	system.schedule(jobName, timeStamp , p); 
    } */
}