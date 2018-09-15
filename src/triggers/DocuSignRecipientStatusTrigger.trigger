//-----------------------------
// @author: Ankita Singh
// @date: 10 April 2018
// @param: Trigger events
// @description:SFDC1-7213- DocuSign Recipient Status trigger 
// @return: NA
//-----------------------------

trigger DocuSignRecipientStatusTrigger on dsfs__DocuSign_Recipient_Status__c (after insert, after update) {
    
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(dsfs__DocuSign_Recipient_Status__c.sObjectType);
}