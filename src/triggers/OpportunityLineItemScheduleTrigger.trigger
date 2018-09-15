//-----------------------------
// @author Paras Dhingra
// @date 15th Sep 2017
// @description SFDC1-4275  Trigger class for OpportunityLineItemSchedule__c using trigger framework
// @Company IHS Markit
//-----------------------------
trigger OpportunityLineItemScheduleTrigger on OpportunityLineItemSchedule__c(before insert, before update, after insert, after update, after delete) {

    TriggerFactory.createTriggerDispatcher(OpportunityLineItemSchedule__c.sObjectType);
}