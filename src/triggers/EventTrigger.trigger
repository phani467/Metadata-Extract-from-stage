//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: Trigger events
// @description: SFDC1-2243 Event trigger
// 
// @updated by: Harshit Singhal
// @updated date: 18 Jun 2018
// @update description: SFDC1-8541 Added 'before insert' and 'before update' trigger events
// 
// @return: NA
//-----------------------------
trigger EventTrigger on Event (before insert, before update, after insert) {
    
    //call trigger factory to create Event trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Event.sObjectType);
}