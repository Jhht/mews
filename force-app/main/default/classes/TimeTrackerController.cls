public class TimeTrackerController {
	public static ID userId = UserInfo.getUserId();       
    
    @AuraEnabled
	public static User getActualUser(){
		return [SELECT id, Name,FirstName, LastName, Phone,Email,SmallPhotoUrl,FullPhotoUrl  FROM User where id=:userid limit 1 ];       
	}
    
    public List<SelectOption> actividadesDisponibles{
        get{
           actividadesDisponibles = new List<SelectOption>();
           actividadesDisponibles.add(new SelectOption('Atención al cliente','Atención al cliente'));
           actividadesDisponibles.add(new SelectOption('Gestión de pólizas','Gestión de pólizas'));
           actividadesDisponibles.add(new SelectOption('Prestaciones','Prestaciones'));
           actividadesDisponibles.add(new SelectOption('Reclamaciones','Reclamaciones'));
            
           return actividadesDisponibles;
        }
        
        set;
    }
    
	public static List<Actividad_semanal__c> allUserActivities{
		get{
			if(allUserActivities==null){
				allUserActivities = new List<Actividad_semanal__c> ([SELECT Id, name, ACTSEM_SEL_TipoActividad__c,ACTSEM_LK_Usuario__c, 
					ACTSEM_DT_Inicio_semana__c, ACTSEM_DT_Fin_Semana__c,ACTSEM_NUM_Horas_semanales__c, 
					ACTSEM_NUM_Horas_Lunes__c, ACTSEM_NUM_Horas_Martes__c, ACTSEM_NUM_Horas_Miercoles__c, 
					ACTSEM_NUM_Horas_Jueves__c, ACTSEM_NUM_Horas_Viernes__c,ACTSEM_NUM_Horas_Sabado__c, 
					ACTSEM_NUM_Horas_Domingo__c FROM Actividad_semanal__c 
					WHERE ACTSEM_LK_Usuario__c=:userId ORDER BY createdDate ASC]);
            }
            return allUserActivities;
        }
        set;
	}
	public static Map<Date,List<Actividad_semanal__c>> weeklyActivitiesByDate{
		get{
			if(weeklyActivitiesByDate==null){
				weeklyActivitiesByDate=new Map<Date,List<Actividad_semanal__c>>();
				if(!allUserActivities.isEmpty()){
					for(Actividad_semanal__c act:allUserActivities){
						//Search date
                		List<Actividad_semanal__c> weeklyAct=weeklyActivitiesByDate.get(act.ACTSEM_DT_Inicio_semana__c);
						if(weeklyAct==null){//If doesn't exist, create list
                			weeklyAct=new List<Actividad_semanal__c>();
                			weeklyAct.add(act);
                			weeklyActivitiesByDate.put(act.ACTSEM_DT_Inicio_semana__c, weeklyAct);
                		}else{//If exists, get the list and add activity to it
                			weeklyAct.add(act);
                			weeklyActivitiesByDate.put(act.ACTSEM_DT_Inicio_semana__c, weeklyAct);
                		}
            		}
				}
            }
            return weeklyActivitiesByDate;
        }
        set;
	}
    
	@AuraEnabled
	public static Date stringToDate(String monday){
       String[] myDateOnly = monday.split(' ');
       String[] strDate = myDateOnly[0].split('-');
       Integer myIntDate = integer.valueOf(strDate[2]);
       Integer myIntMonth = integer.valueOf(strDate[1]);
       Integer myIntYear = integer.valueOf(strDate[0]);
       return Date.newInstance(myIntYear, myIntMonth, myIntDate);
   }
       
  	@AuraEnabled
    public static Map<Date,List<Actividad_semanal__c>> getAllWeeklyActivities(){
        return weeklyActivitiesByDate;
    }
    
    @AuraEnabled
	public static List<Actividad_semanal__c> getWeeklyActivities(String selectedDay){
       Date startofWeek=stringToDate(selectedDay).toStartofWeek();
       List<Actividad_semanal__c> activities=  weeklyActivitiesByDate.get(startofweek);
       if(activities==null){
           activities=new List<Actividad_semanal__c>();           
       }else{
           System.debug('getWeeklyActivities###'+weeklyActivitiesByDate.size());
       }
       return activities;
   }
	@AuraEnabled
	public static Decimal getTotalHoursPerDay(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
           total+=act.ACTSEM_NUM_Horas_Lunes__c+ act.ACTSEM_NUM_Horas_Martes__c + act.ACTSEM_NUM_Horas_Miercoles__c+ 
               act.ACTSEM_NUM_Horas_Jueves__c +act.ACTSEM_NUM_Horas_Viernes__c +
               act.ACTSEM_NUM_Horas_Sabado__c+act.ACTSEM_NUM_Horas_Domingo__c;
       }
       return total;
	}
	@AuraEnabled
	public static Decimal getTotalHoursMonday(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Lunes__c;
		}
		return total;
	}
  	@AuraEnabled
	public static Decimal getTotalHoursTuesday(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Martes__c;
		}
		return total;
	}
  	@AuraEnabled
	public static Decimal getTotalHoursWednesday(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Miercoles__c;
		}
		return total;
	}
  	@AuraEnabled
	public static Decimal getTotalHoursThursday(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Jueves__c;
       	}
       	return total;
	}
  	@AuraEnabled
	public static Decimal getTotalHoursFriday(String selectedDay) {
		Decimal total=0;
       	for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Viernes__c;
		}
		return total;
  }
  	@AuraEnabled
	public static Decimal getTotalHoursSaturday(String selectedDay){
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Sabado__c;
		}
		return total;
	}
  	@AuraEnabled
	public static Decimal getTotalHoursSunday(String selectedDay) {
		Decimal total=0;
		for(Actividad_semanal__c act:getWeeklyActivities(selectedDay)){
			total+=act.ACTSEM_NUM_Horas_Domingo__c;
		}
		return total;
	}    
  

    @AuraEnabled
	public static List<Actividad_semanal__c> saveCurrentWeek(String currentWeek, String json){
        List<Actividad_semanal__c> activitiesToUpsert = new List<Actividad_semanal__c>();
        List<Actividad_semanal__c> activitiesToDelete = new List<Actividad_semanal__c>();
        Date activitiesStartDate = stringToDate(currentWeek);
        System.debug('param -> '+ json);
		JSONParser parser = System.JSON.createParser(json);

        if(parser.getCurrentToken() == null){
            parser.nextToken();
  		}
		if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
			System.debug('START_ARRAY -> '+ parser.getCurrentToken());
			while(parser.nextToken() != null) {
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					// Read entire invoice object, including its array of line items.
					Actividad_semanal__c acti = (Actividad_semanal__c)parser.readValueAs(Actividad_semanal__c.class);
					activitiesToUpsert.add(acti);
                    //system.debug('Acti date: ' + acti.ACTSEM_DT_Inicio_semana__c);
					system.debug('Invoice number: ' + acti);
					// For debugging purposes, serialize again to verify what was parsed.
					String s = System.JSON.serialize(acti);
					system.debug('Serialized invoice: ' + s);
					// Skip the child start array and start object markers.
					parser.skipChildren();
				}
			}
		}
        
        
        System.debug(activitiesStartDate);
        System.debug(weeklyActivitiesByDate.get(activitiesStartDate));
        List<Actividad_semanal__c> activitiesToCheck= weeklyActivitiesByDate.get(activitiesStartDate);
        
        if(activitiesToCheck!=null){
            for(Actividad_semanal__c existingActivity:activitiesToCheck){
                Boolean existToUpsert=false;
                  for(Actividad_semanal__c activityToUpsert:activitiesToUpsert){
                      if(activityToUpsert.Id== existingActivity.Id){
                          existToUpsert=true;
                      }
                  }
                if(!existToUpsert){
                    activitiesToDelete.add(existingActivity);
                }
            }    
        }
        
        
        
        
    	// Perform isUpdateable() check here
    	delete activitiesToDelete;
    	upsert activitiesToUpsert;
    	return activitiesToUpsert;
	}
    //
/*
    @AuraEnabled
	public static Actividad_semanal__c saveCurrentActivity(Actividad_semanal__c activity){
    	upsert activity;
    	return activity;
	}    */
    /*@AuraEnabled
	public static List<Actividad_semanal__c> cloneActivities(String weekToBeCloned,String weekToClone,Integer numberWeeks){
		List<Actividad_semanal__c> clonedActivities=new List<Actividad_semanal__c>();
		System.debug('CLONEWEEK###Start');
		Date selectedWeekToBeCloned=stringToDate(weekToBeCloned).toStartofWeek();
		Date selectedWeekToClone=stringToDate(weekToClone).toStartofWeek();
       
		if(!selectedWeekToBeCloned.isSameDay(selectedWeekToClone)){
			//Get activities to clone
			List<Actividad_semanal__c> activitiesToClone = new List<Actividad_semanal__c> ([SELECT Id, name, ACTSEM_SEL_TipoActividad__c,
						ACTSEM_LK_Usuario__c, ACTSEM_DT_Inicio_semana__c, ACTSEM_DT_Fin_Semana__c,ACTSEM_NUM_Horas_semanales__c, 
                        ACTSEM_NUM_Horas_Lunes__c, ACTSEM_NUM_Horas_Martes__c, ACTSEM_NUM_Horas_Miercoles__c, 
                        ACTSEM_NUM_Horas_Jueves__c, ACTSEM_NUM_Horas_Viernes__c,ACTSEM_NUM_Horas_Sabado__c, 
                        ACTSEM_NUM_Horas_Domingo__c FROM Actividad_semanal__c 
                        WHERE ACTSEM_LK_Usuario__c=:userId AND ACTSEM_DT_Inicio_semana__c=:selectedWeekToBeCloned ORDER BY createdDate ASC]);
			//Get dates where to clone activities
			Date actualWeek = selectedWeekToClone;

			Map<Date,Date> weeksToClone=new Map<Date,Date>();
			System.debug('CLONEWEEK###GetDatesArray: '+numberWeeks+' week(s)');
			for(Integer i=0;i<numberWeeks;i++){
				weeksToClone.put(actualWeek,actualWeek);
				actualWeek=actualWeek.addDays(7);
			}

			//Delete existing activities at the period to be clones
			List<Actividad_semanal__c> existingActivities = new List<Actividad_semanal__c> ([SELECT Id, name, ACTSEM_SEL_TipoActividad__c,
						ACTSEM_LK_Usuario__c, ACTSEM_DT_Inicio_semana__c, ACTSEM_DT_Fin_Semana__c,ACTSEM_NUM_Horas_semanales__c
                        FROM Actividad_semanal__c 
                        WHERE ACTSEM_LK_Usuario__c=:userId AND ACTSEM_DT_Inicio_semana__c =:selectedWeekToClone]);           

			delete existingActivities;
			//Clone each activity for each selected week
			for(Actividad_semanal__c act: activitiesToClone){
                Actividad_semanal__c newAct = act.clone(false,true, false,false);
                newAct.ACTSEM_DT_Inicio_semana__c=selectedWeekToClone;
                clonedActivities.add(newAct);
			}
			upsert clonedActivities;
		}
		System.debug('CLONEWEEK###End');
		return clonedActivities;
	}*/
}