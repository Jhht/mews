@isTest
public class DailyLeadProcessorTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testScheduledJob() {
        // Create some out of date Opportunity records
        List<Lead> opptys = new List<Lead>();
        for (Integer i=0; i<10; i++) {
            Lead o = new Lead(
                Lastname = 'Lead ' + i,
                Company = 'c'
            );
            opptys.add(o);
        }
        insert opptys;
 
    
     Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DailyLeadProcessor());         
       
        // Stopping the test will run the job synchronously
        Test.stopTest();
     }
}