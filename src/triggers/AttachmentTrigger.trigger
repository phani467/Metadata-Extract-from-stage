//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: Trigger events
// @description: SFDC1-2243 Attachment trigger 
// @return: NA
//-----------------------------
trigger AttachmentTrigger on Attachment (after insert) {
    
    //call trigger factory to create Attachment trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Attachment.sObjectType);
}