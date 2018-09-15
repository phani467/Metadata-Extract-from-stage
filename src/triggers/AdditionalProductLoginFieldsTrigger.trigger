//-----------------------------
// @author: Uttam Arya
// @date: 13 April 2018
// @param: Trigger events
// @description: Additional Product Login Fields trigger 
// @return: NA
//-----------------------------

trigger AdditionalProductLoginFieldsTrigger on AdditionalProductLoginFields__c (after insert) {
    
    //call trigger factory to create Additional Product Login Fields dispatcher
    TriggerFactory.createTriggerDispatcher(AdditionalProductLoginFields__c.sObjectType);
}