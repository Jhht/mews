@isTest
public class VerifyDateTest {

    @isTest 
    static void test01(){
        Date d1 = Date.newInstance(1960, 2, 17);
        Date d2 = Date.newInstance(1960, 3, 17);
        Date d3 =Date.newInstance(1960, 2, 19);
        
        VerifyDate.CheckDates(d1,d2);
        VerifyDate.CheckDates(d3,d1);
    }
}