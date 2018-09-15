//-----------------------------
// @author: Mohit Modi
// @date: 18 June 2018
// @param: Trigger events
// @description: ChannelProgramContact trigger 
// @return: NA
//-----------------------------
trigger ChannelProgramContactTrigger on ChannelProgramContact__c (before insert, before update) {
    TriggerFactory.createTriggerDispatcher(ChannelProgramContact__c.sObjectType);
}