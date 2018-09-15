/**************************************************
 * Name - Notification Email
 * Event - After update
 * Description - If the start date or negotiated date 
 *               is different from a PLC, it will automatically
 *               populate the child Job Task with the new start 
 *               and due dates.  These can be edited on 
 *               the job task later if need be Updates Start Date,
 *               Negotiated Date and job status override.  
 * Author - 
 * Created by - Anjani Shukla
 * Date - 29 Sept 2017
 * Version/Modifications - 
 * i. Existing Trigger - UpdateJobTask/After update 
 * ***********************************************/
trigger ChangeLogTrigger on changelog__c(after update, after insert, before update,before insert) {
    //call trigger factory to create Change Log trigger dispatcher
    TriggerFactory.createTriggerDispatcher(ChangeLog__c.sObjectType);
}