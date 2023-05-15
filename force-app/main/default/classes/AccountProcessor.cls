public class AccountProcessor {
	
    @future
    public static void countContacts(List<Id> accountIds){
        List<Account> accounts = new List<Account>([Select id, Number_of_contacts__c from Account where id IN :accountIds]);
        List<Account> accToUpdate = new List<Account>();
        for(Account acc : accounts){
            List<AggregateResult> aggr = [Select count(id) from Contact where accountId =: acc.id];
            acc.Number_of_contacts__c = Integer.valueOf(aggr[0].get('expr0'));
       	
            accToUpdate.add(acc);
        }
        
        update accToUpdate;
    }
}