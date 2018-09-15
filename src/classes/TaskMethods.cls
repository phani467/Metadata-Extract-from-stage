//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: NA
// @description: SFDC1-2243 Class to hold Task trigger methods 
// @return: NA
//-----------------------------
public class TaskMethods {

    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 Aug 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-2243 Whenever an Task is added to an opportunity,  
    //                  MISActivityAdded field is auto populated with the current timestamp. 
    //                  This is used for MIS pipeline reporting.
    // @return: None
    // @Update by : Mohit Modi
    // @Updated date : 17 Jan 2018
    // @updated description : Updated list to Map for removing the Duplicate Error in TestClass
    // 
    // @Update by : Harshit Singhal
    // @Updated date : 15 Jun 2018
    // @Updated description : SFDC1-8540 Convert Process Builder flow "Activity Created On Opportunity" on Task object created in SFDC1-547(When the Activity gets created on Opportunity Checkbox will be Checked) to a trigger
    // 						  Added code to set Activity Created field=true on related Opportunity
    //------------------------------
    public static void populateTaskAddedInOpportunityWhenTaskIsInserted(TriggerParameters tp) {
    
        //Set of Opportunity that needs to be updated    
        Map<id,Opportunity > OpportunityToUpdate = new Map<id,Opportunity>(); 
        
        for(Task Task: (List <Task>) tp.newList) {
            if(Task.WhatId != null && String.valueOf(Task.WhatId).startsWith('006')) {
                OpportunityToUpdate.put(Task.WhatId,new Opportunity(Id = Task.WhatId, MISActivityAdded__c = Datetime.now(), ActivityCreated__c=true));                
            }
        }        
        //update if list has any records
        if(OpportunityToUpdate != null && OpportunityToUpdate.size() > 0) {
            update OpportunityToUpdate.values();
        }
    }
    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 17 Jan 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-5027 Whenever an Task is deleted to an opportunity, ActivityCreated__c field should be set to FALSE
    //                   if this is the last task on the Opportunity, else don't update on Opportunity.
    //
    // @return: None
    //------------------------------
    public static void updateOpportunityActivityCheckOnTaskDeletion(TriggerParameters tp) {
        
        set<id> setDeletedTaskOppId = new set<id>();
        set<id> setRemainingTaskOppId = new set<id>();
        list<Opportunity> listopptoUpdate = new List<Opportunity>();
        
        for(Task Task: (List <Task>) tp.oldList) {
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete
             && Task.WhatId != null && String.valueOf(Task.WhatId).startsWith('006')) {
                 setDeletedTaskOppId.add(Task.WhatId);
            }
        }
        
        if(!setDeletedTaskOppId.isEmpty()) {
            // Query for remaining tasks on the Opportunity
            for(Task remainingTask : [select id,WhatId from Task where WhatId in :setDeletedTaskOppId]) {
                setRemainingTaskOppId.add(remainingTask.WhatId );
            }
            // Removing the Task's opportunity to get the list of opportunity where another tasks are remaining.
            if(!setRemainingTaskOppId.isEmpty()) {
                setDeletedTaskOppId.removeAll(setRemainingTaskOppId);
            }
            // Checking if any Opportunity available for whcih no tasks are left.If no task left, update the Opportunity.
            if(!setDeletedTaskOppId.isEmpty()) {
                for(ID oppId:setDeletedTaskOppId) {
                    Opportunity oppToUpdate = new Opportunity(id = oppId );
                    oppToUpdate.ActivityCreated__c = false;
                    listopptoUpdate.add(oppToUpdate);
                }
            }
            
            if(!listopptoUpdate.isEmpty()) {
                update listopptoUpdate;
            }
        }
    }
    
}