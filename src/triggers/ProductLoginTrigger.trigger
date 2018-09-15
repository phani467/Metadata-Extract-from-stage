//-----------------------------
// @author: Uttam Arya
// @date: 13 April 2018
// @param: Trigger events
// @description: Product Login trigger 
// @return: NA
//-----------------------------

trigger ProductLoginTrigger on ProductLogin__c (after insert, after update) {
    
    //call trigger factory to create Product Login trigger dispatcher
    TriggerFactory.createTriggerDispatcher(ProductLogin__c.sObjectType);
}