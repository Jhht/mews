@isTest
public class AddPrimaryContactTest {
	  @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add a parent account
        accounts.add(new Account(name='Parent'));
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(
                name='Test Account'+i,
                BillingState = 'NY'	
            ));
        }
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(
                name='Test Account'+i,
                BillingState = 'CA'	
            ));
        }
        insert accounts;
    }
    
    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        List<Account> accounts = [select id, name from account ];
        Contact c = new Contact( Lastname= 'Test');
        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(c, 'NY');
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();        
      
    }
}