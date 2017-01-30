global class deactivateUsersScheduler implements Schedulable{
 global void execute(SchedulableContext sc) 
 {
     DeactivateUser DAU = new DeactivateUser();
     DAU.Userdeactivation();
  try { 
    system.abortJob(sc.getTriggerId()); 
    } catch (exception e) {system.debug('#### schedule job exception while aborting:' + e);} 


    // reschedule the job 
    system.debug('#### schedule job executing'); 
    scheduleNow(); 

    } 


    global static void scheduleNow() { 

    // this section of code will schedule the next execution 1 minute from now 
    datetime thisTime = system.now().addHours(24); 
    integer minute = thisTime.minute(); 
    integer second = thisTime.second(); 
    integer hour = thisTime.hour(); 
    integer year = thisTime.year(); 
    integer month = thisTime.month(); 
    integer day = thisTime.day(); 

    String timeStamp = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year; 
    string jobName = 'Deactivate the user'; 
	if(!test.isRunningTest())
    {
        deactivateUsersScheduler p = new deactivateUsersScheduler(); 
        system.schedule(jobName, timeStamp , p);
    }
 
    }
}