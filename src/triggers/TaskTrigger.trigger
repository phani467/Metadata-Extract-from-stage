//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: Trigger events
// @description: SFDC1-2243 Task trigger 
// @return: NA
// @Updated by : Mohit Modi - 
// @Updated description : SFDC1 -5027, Added after delete context
// @Updated date : 17 jan 2018
//-----------------------------
trigger TaskTrigger on Task (after insert,after delete) {
    
    //call trigger factory to create Task trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Task.sObjectType);
}