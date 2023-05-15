public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer n, String lastName){
        List<Contact> ret = new List<Contact>();
        Contact c;
        for(Integer i = 0; i < n; i++){
			c = new Contact();
            c.FirstName = 'Test' + i;
			c.LastName = lastName;
			ret.add(c);            
        }
        
        return ret;
    }

}