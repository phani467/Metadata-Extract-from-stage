//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: Trigger events
// @description: Case trigger 
// @return: NA
//-----------------------------

trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Case.sObjectType);

}