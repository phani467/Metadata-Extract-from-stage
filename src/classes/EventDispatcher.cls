//-----------------------------
// @author Uttam Arya
// @date 29th Aug 2017
// @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//				on the Event object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//				This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//				to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//				as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//	
//	@Updated By: Harshit Singhal
//	@Updated Date: SFDC1-8541 Added beforeInsert() and beforeUpdate() methods
//-----------------------------
public class EventDispatcher extends TriggerDispatcherBase {
    
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;

    //-----------------------------
    // @author Uttam Arya
    // @date 29th Aug 2017
    // @description SFDC1-2243 Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    //				existing call running on the same context, the rentrant call will utilize the handler that was created
    //				in the original call.
    // @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(new EventAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
    }
    
    //-----------------------------
    // @author Harshit Singhal
    // @date 15th Jun 2018
    // @description SFDC1-8541 Called by the trigger framework to carry out the actions before the record(s) are created. If there is an
    //				existing call running on the same context, the rentrant call will utilize the handler that was created
    //				in the original call.
    // @param TriggerParameters Contains the trigger parameters which include the record(s) that got created.
    //-----------------------------
    public virtual override void beforeInsert(TriggerParameters tp) {        
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new EventBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);        
    }
    
    //-----------------------------
    // @author Harshit Singhal
    // @date 15th Jun 2018
    // @description SFDC1-8541 Called by the trigger framework to carry out the actions before the record(s) are updated. If there is an
    //				existing call running on the same context, the rentrant call will utilize the handler that was created
    //				in the original call.
    // @param TriggerParameters Contains the trigger parameters which include the record(s) that got updated.
    //-----------------------------
    public virtual override void beforeUpdate(TriggerParameters tp) {        
        if(!isBeforeUpdateProcessing) {            
            isBeforeUpdateProcessing = true;            
            execute(new EventBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;            
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);        
    }
    
}