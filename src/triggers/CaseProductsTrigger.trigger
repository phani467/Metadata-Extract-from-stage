/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 26 September 2017
* @param: Trigger events
* @description: SFDC1-593. trigger for Case Products 
* @companyname: VERTIBA
*/
trigger CaseProductsTrigger on CaseProducts__c (before insert, before update) {
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(CaseProducts__c.sObjectType);
}