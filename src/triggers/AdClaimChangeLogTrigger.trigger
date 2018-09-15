//-----------------------------
// @author: Mohit Modi
// @date: 4th June 2018
// @param: Trigger events
// @description: AdClaim Change Log trigger 
// @return: NA
//-----------------------------
trigger AdClaimChangeLogTrigger on AdClaimChangeLog__c (after insert, after update) {
    TriggerFactory.createTriggerDispatcher(AdClaimChangeLog__c.sObjectType);
}