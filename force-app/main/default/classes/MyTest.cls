@isTest
public class MyTest {

    @testSetup
    static void setup(){
        List<Account>  testAccs = new List<Account>();
        for(Integer i = 0; i < 2; i++){
            testAccs.add(new Account(Name = 'MytestAc' + i , Phone='333-878'+ i));
        }
        insert testAccs;
    }
    
    @isTest
    static void testMethod1(){
        Account acc = [Select id, phone From Account where name = 'MyTestAc0' Limit 1];
        acc.Phone = '888-1515';
        update acc;
    }
    
    @isTest
    static void testMethod2(){
      Account acc = [Select id, phone From Account where name = 'MyTestAc0' Limit 1];
	  System.debug(acc);
    }
}