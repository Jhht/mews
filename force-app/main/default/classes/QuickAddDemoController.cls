public class QuickAddDemoController {
    
    @AuraEnabled
    public static Boolean dummySharingOwnerMethod(ID oppId){
        return true;
    }
    
    @AuraEnabled
    public static Opportunity getOpp(ID oppId){
        System.debug('------- ' + oppId);
        Opportunity opp = [Select id, name from Opportunity where id =: oppId];
        return opp;
    }
    
     @AuraEnabled
    public static Opportunity cloneOpp(ID oppId){
        System.debug('------- ' + oppId);
        //saca todos los valores que necesites clonar
        Opportunity opp = [Select id, name, CloseDate,StageName  from Opportunity where id =: oppId];
        
        //creamos la nueva
        Opportunity cloneOpp = new Opportunity();
		cloneOpp.name = 'TEST PROMISE 7';
        cloneOpp.CloseDate =  opp.CloseDate;
        cloneOpp.StageName = opp.StageName;
        
        //la insertamos
        insert cloneOpp;
        
        return cloneOpp;
    }

}