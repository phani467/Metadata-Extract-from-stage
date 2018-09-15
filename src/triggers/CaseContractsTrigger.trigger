/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 23 August 2017
* @param: Trigger events
* @description: SFDC1-593. trigger for Case Contracts 
* @companyname: VERTIBA
*/
trigger CaseContractsTrigger on CaseContracts__c (before insert, before update, after insert, after delete, after update) {
    //call trigger factory to create case trigger dispatcher
    TriggerFactory.createTriggerDispatcher(CaseContracts__c.sObjectType);
}