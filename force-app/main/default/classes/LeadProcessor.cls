global class LeadProcessor implements Database.Batchable<sObject>{
	
   List<Lead> leadlist = new List<Lead>();
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('Select id, leadSource from Lead');
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   
       for(Sobject l : scope){
           Lead le = (Lead)l;
               le.leadSource = 'Dreamforce';
           leadlist.add(le);
       }
       
   }
   

global void finish(Database.BatchableContext BC){
   
    update leadlist;
   
   }
}