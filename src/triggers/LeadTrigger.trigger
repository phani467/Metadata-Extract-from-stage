/**
* @author Paras Dhingra
* @date 08th Aug 2017
* @description SFDC1-1081 Lead trigger to handle lead DML events
*/
trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete) {
    
    TriggerFactory.createTriggerDispatcher(Lead.sObjectType);
}