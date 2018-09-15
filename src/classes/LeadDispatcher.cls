/**
* @author : Uttam Arya
* @date : 6th Feb 2017
* @description : This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*               on the Account object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*               This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*               to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*               as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @companyname : IHS Markit
* @modifiedby : Paras Dhingra
* @modifieddate : 08th Aug 2017
* @modifiedby : Mohit Modi
* @modifieddate : 03 Nov 2017
*/

public class LeadDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    private static Boolean isAfterDeleteProcessing = false;
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions before the records are inserted. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
    * @return void
    * @companyname IHS Markit
    * @modifiedby : Mohit Modi
    * @modifieddate : 03 Nov 2017
    * @description : Moved the logic to Before Event
    */
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            // SFDC1-192 : Mohit : Uncommenting as Logic has been moved to Before Events
            execute(new LeadBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
    * @return void
    * @companyname IHS Markit
    * @modifiedby : Mohit Modi
    * @modifieddate : 03 Nov 2017
    * @description : Moved the logic to Before Event
    */
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            // SFDC1-192 : Mohit : Uncommenting as Logic has been moved to Before Events
            execute(new LeadBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
    }
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions before the records are deleted. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
    * @return void
    * @companyname IHS Markit
    * @modifiedby : Mohit Modi
    * @modifieddate : 03 Nov 2017
    * @description : Moved the logic to Before Event
    */
    public virtual override void beforeDelete(TriggerParameters tp) {
        if(!isBeforeDeleteProcessing) {
            isBeforeDeleteProcessing = true;
            //execute(new LeadBeforeDeleteHandler(), tp, TriggerParameters.TriggerEvent.beforeDelete);
            isBeforeDeleteProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeDelete);
    }
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
    * @return void
    * @companyname IHS Markit
    * @modifiedby : Mohit Modi
    * @modifieddate : 14 May 2018
    * @description : Moved the logic to Before Event
    */
        public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
           // SFDC1-192 : Mohit : Commenting as Logic has been moved to Before Events
            //execute(new LeadAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
    }
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
    * @return void
    * @companyname IHS Markit
    * @modifiedby : Mohit Modi
    * @modifieddate : 03 Nov 2017
    * @description : Moved the logic to Before Event
    *              : SFDC1-6570 : Anjani Shukla - This Method will update Lead  
    * 			     Description on opportunity after lead conversion process.
    */
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
           // SFDC1-192 : Mohit : Commenting as Logic has been moved to Before Events
          execute(new LeadAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }
    
    /** 
    * @author Paras Dhingra
    * @date 8th Aug 2017
    * @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
    * @return void
    * @companyname IHS Markit
    */
    public virtual override void afterDelete(TriggerParameters tp) {
        if(!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            //execute(new LeadAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }
    
}