@isTest
public class TestRestrictContactByName {

    @isTest
    static void test01(){
        //Testa data setup
        Contact c = new Contact();
		c.LastName = 'INVALIDNAME';
        
        Test.startTest();
        Database.SaveResult result = Database.insert(c, false);
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
    
        Test.stopTest();
    }
}