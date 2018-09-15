//-----------------------------
// @author: Mohit Modi
// @date: 4th June 2018
// @param: Trigger events
// @description: AdClaim trigger 
// @return: NA
//-----------------------------
trigger AdClaimTrigger on AdClaim__c (after insert, after update,before insert, before update) {
    TriggerFactory.createTriggerDispatcher(AdClaim__c.sObjectType);
}