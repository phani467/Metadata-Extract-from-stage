//-----------------------------
// @author: Uttam Arya
// @date: 22 Aug 2017
// @param: Trigger events
// @description: SFDC1-2103 Additional Account Fields trigger 
// @return: NA
//-----------------------------
trigger AdditionalAccountFieldsTrigger on AdditionalAccountFields__c (after insert) {
    
    //call trigger factory to create Account trigger dispatcher
    TriggerFactory.createTriggerDispatcher(AdditionalAccountFields__c.sObjectType);
}