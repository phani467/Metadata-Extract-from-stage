//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: Trigger events
// @description: SFDC1-2243 ContentDocumentLink trigger 
// @return: NA
//-----------------------------
trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    //call trigger factory to create ContentDocumentLink trigger dispatcher
    TriggerFactory.createTriggerDispatcher(ContentDocumentLink.sObjectType); 
}