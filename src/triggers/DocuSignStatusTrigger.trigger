//-----------------------------
// @author: Tran-Vu Tran
// @date: 16 July 2018
// @param: Trigger events
// @description: SFDC1-7947 DocuSign Status trigger 
// @return: NA
//-----------------------------

trigger DocuSignStatusTrigger on dsfs__DocuSign_Status__c (before insert) {
    
    TriggerFactory.createTriggerDispatcher(dsfs__DocuSign_Status__c.sObjectType);
    
}