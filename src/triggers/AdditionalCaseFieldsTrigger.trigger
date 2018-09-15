//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: Trigger events
// @description: Additional Case Fields trigger 
// @return: NA
// @author: Vishnu vardhan Chowdary andra
// @date: 19 June 2018
// @description: Adding after update to trigger
//-----------------------------
trigger AdditionalCaseFieldsTrigger on AdditionalCaseFields__c (after insert, after update) {
    
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(AdditionalCaseFields__c.sObjectType);
}