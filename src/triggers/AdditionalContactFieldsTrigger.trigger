//-----------------------------
// @author: Tran-Vu Tran
// @date: 26 Sep 2017
// @param: Trigger events
// @description: SFDC1-2299 Additional Contact Fields trigger 
// @return: NA
//-----------------------------
trigger AdditionalContactFieldsTrigger on AdditionalContactFields__c (after insert) {
    //call trigger factory to create Contact trigger dispatcher
    TriggerFactory.createTriggerDispatcher(AdditionalContactFields__c.sObjectType);
}