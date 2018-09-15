//-----------------------------
// @author Paras Dhingra
// @date 15th Sep 2017
// @description SFDC1-4275  Trigger class for OpportunityLineItem using trigger framework
// @Company IHS Markit
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 10th April 2018
// @Last Modified Description: SFDC1-7027- Added before insert trigger 
// @Last Modified By: Mohit Modi
// @Last Modified Date: 23th April 2018
// @Last Modified Description: SFDC1-5722- Added before delete trigger 
// @Last Modified By: Paras Dhingra
// @Last Modified Date: 25th Jul 2018
// @Last Modified Description: SFDC1-7060- Added befor Update context
//-----------------------------
trigger OpportunityLineItemTrigger on OpportunityLineItem(before insert,before update, after insert, after update, after delete,before delete) {

    TriggerFactory.createTriggerDispatcher(OpportunityLineItem.sObjectType);
}