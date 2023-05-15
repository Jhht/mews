public class AddPrimaryContact implements Queueable {
    
    private Contact c;
    private String stateAbr;
    
    public AddPrimaryContact(Contact c, String stateAbr) {
        this.c = c;
        this.stateAbr = stateAbr;
    }
    public void execute(QueueableContext context) {
       	List<Account> accs = new List<Account>([Select id from Account where Billingstate =: stateAbr LIMIT 200]);
        List<Contact> toInsert = new List<Contact>();

        for(Account acc : accs){
            Contact n = c.clone();
            c.AccountId = acc.id;
            toInsert.add(n);
        }
        insert toInsert;
    }
    
}