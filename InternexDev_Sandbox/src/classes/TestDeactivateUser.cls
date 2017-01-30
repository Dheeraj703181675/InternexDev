@istest
public class TestDeactivateUser
{
    static testmethod void deactivate()
    {
        Profile p = [SELECT Id, name FROM Profile WHERE Name='System Administrator'];
         User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
        insert u1;
        
       // DeactivateUser DU = new DeactivateUser();
       // DU.Userdeactivation();
        
         Test.startTest();
        SchedulableContext sc;
        deactivateUsersScheduler IB = new deactivateUsersScheduler();
        IB.execute(sc);
       
        Test.stopTest(); 


        
    }

}