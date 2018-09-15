//-----------------------------
// @author: Harshit Singhal
// @date: 11 Aug 2018
// @param: Trigger events
// @description: SFDC1-9773 Solution trigger 
// @return: NA
//-----------------------------
trigger SolutionTrigger on Solution (after insert, after update)  {
    TriggerFactory.createTriggerDispatcher(Solution.sObjectType);    
}