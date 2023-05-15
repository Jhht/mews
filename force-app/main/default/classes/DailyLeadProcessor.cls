global class DailyLeadProcessor  implements Schedulable{
	global void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, Name, LeadSource 
            FROM Lead 
            WHERE LeadSource = ''];
        
        for(Lead l : leads){
            l.LeadSource = 'Dreamforce';
        }
        
        update leads;
        // Create a task for each opportunity in the list
    }
}