//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: Trigger events
// @description: SFDC1-834 LiveChatTranscript trigger 
// @return: NA
//-----------------------------
trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert, before update, after insert, after update) {
    //call trigger factory to create case trigger dispatcher 
    TriggerFactory.createTriggerDispatcher(LiveChatTranscript.sObjectType);
}