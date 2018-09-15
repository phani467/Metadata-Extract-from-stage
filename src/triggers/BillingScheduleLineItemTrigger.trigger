trigger BillingScheduleLineItemTrigger on BillingScheduleLineItem__c(before insert, after insert) {

    TriggerFactory.createTriggerDispatcher(BillingScheduleLineItem__c.sObjectType);
}