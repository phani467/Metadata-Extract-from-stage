//-----------------------------
// @author: Ankita Singh
// @date: 19 June 2018
// @param: Trigger events
// @description: ContractAttachment__c trigger 
// @return: NA
//-----------------------------

trigger ContractAttachmentTrigger on ContractAttachment__c (after insert, after delete ) {
    
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(ContractAttachment__c.sObjectType);

}