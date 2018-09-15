//-----------------------------
// @author: Jagadesh Kumar
// @date: 30 May 2018
// @param: Trigger events
// @description: Product Usage Statistics trigger 
// @return: NA
//-----------------------------
trigger ProductUsageStatisticsTrigger on ProductUsageStatistics__c (after insert) {
    
	//call trigger factory to create Product Usage Statistics trigger dispatcher
	TriggerFactory.createTriggerDispatcher(ProductUsageStatistics__c.sObjectType);
    
}