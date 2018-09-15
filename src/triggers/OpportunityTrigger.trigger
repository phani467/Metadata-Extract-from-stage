//-----------------------------
// @author: Prachi Bhasin
// @date: 3 July 2017
// @param: Trigger events
// @description: Opportunity trigger 
// @return: NA
//-----------------------------

trigger OpportunityTrigger on Opportunity(before insert, before update, after insert, after update) {
    
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Opportunity.sObjectType);

}