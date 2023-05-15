@isTest
public  class AccountProcessorTest {

    static testmethod void test01(){
        Account a = new Account();
        a.name = 'AA';
        
        insert a;
        Contact c = new Contact();
        //c.name= 'Test';
        c.AccountId = a.id;
        c.lastname = 'BB';
        insert c;
        
        List<id> accid = new List<id>();
        accid.add(a.id);
        Test.startTest();
        AccountProcessor.countContacts(accid);
        Test.stopTest();
        
    }
}