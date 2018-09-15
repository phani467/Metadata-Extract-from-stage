//-----------------------------
// @author: Sonam Raju adapted from Uttam's code
// @date: 8 Mar 2018
// @param: Trigger events
// @description: SFDC1-6937 Additional Opportunity Fields trigger 
// @return: NA
//-----------------------------
trigger AdditionalOpportunityFieldsTrigger on AdditionalOpportunityFields__c (after insert) {
    
    //call trigger factory to create Opportunity trigger dispatcher
    TriggerFactory.createTriggerDispatcher(AdditionalOpportunityFields__c.sObjectType);
}