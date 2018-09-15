//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: NA
// @description: SFDC1-2243 Class to hold Event trigger methods 
// @return: NA
//-----------------------------
public class EventMethods {

//-----------------------------
// @author: Uttam Arya
// @date: 22 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2243 Whenever an Event is added to an opportunity,  
//					MISActivityAdded field is auto populated with the current timestamp. 
//					This is used for MIS pipeline reporting.
//
// @return: None
//------------------------------
    public static void populateEventAddedInOpportunityWhenEventIsInserted(TriggerParameters tp) {
    
        //List of Opportunity that needs to be updated    
        List <Opportunity > OpportunityToUpdate = new List <Opportunity>(); 
        
        for(Event Event: (List <Event>) tp.newList) {
            if(Event.WhatId != null && String.valueOf(Event.WhatId).startsWith('006')) {
                OpportunityToUpdate.add(new Opportunity(Id = Event.WhatId, MISActivityAdded__c = Datetime.now()));
            }
        }
        
        //update if list has any records
        if(OpportunityToUpdate != null && OpportunityToUpdate.size() > 0) {
            update OpportunityToUpdate;
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 15 Jun 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8541 Convert Process Builder flow "Event-Copy Activity Type from Standard Type" on Event object created in SFDC1-6039(Create Time Tracking Record) to a trigger
    // 				 This methods sets Activity Type field from standard Type field on Event object during before insert and update transactions.
    // 
    // @return: None
    //------------------------------
    public static void setActivityTypeFromType(TriggerParameters tp) {        
        for(Event newEvt: (List<Event>)tp.newList) {
            //Before Insert
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {                
                newEvt.ActivityType__c = newEvt.Type;
            }
            //Before update
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {                
                Event oldEvt = (Event)tp.oldMap.get(newEvt.Id);
                if(newEvt.Type!=oldEvt.Type) {                    
                    newEvt.ActivityType__c = newEvt.Type;
                }                	
            }
        }        
    }
}