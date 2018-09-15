//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: Trigger events
// @description: SFDC1-834 ChatSurveyTrigger
// @return: NA
//-----------------------------

trigger ChatSurveyTrigger on ChatSurvey__c (before insert, before update, after insert, after update) {
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(ChatSurvey__c.sObjectType);

}