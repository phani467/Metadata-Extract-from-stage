//-----------------------------
// @author: Jagadesh Kumar
// @date: 06 June 2018
// @param: Trigger events
// @description: Internal Approval trigger 
// @return: NA
//-----------------------------
trigger InternalApprovalTrigger on InternalApproval__c (before insert) {

    //call trigger factory to create Internal Approval trigger dispatcher
	TriggerFactory.createTriggerDispatcher(InternalApproval__c.sObjectType);
    
}