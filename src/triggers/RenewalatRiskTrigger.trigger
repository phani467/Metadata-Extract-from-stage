//-----------------------------
// @author: Harshit Singhal
// @date: 19 Jun 2018
// @param: Trigger events
// @description: SFDC1-8545 Opportunity at Risk(RenewalatRisk__c) trigger
//
// @return: NA
//-----------------------------
trigger RenewalatRiskTrigger on RenewalatRisk__c (before insert) {    
	//call trigger factory to create RenewalatRisk trigger dispatcher
    TriggerFactory.createTriggerDispatcher(RenewalatRisk__c.sObjectType);
}