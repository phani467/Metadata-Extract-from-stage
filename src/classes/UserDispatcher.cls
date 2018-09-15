//-----------------------------
// @author Tran-Vu Tran
// @date 24th April 2018
// @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//      on the User object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//      This is controlled by the flag isBeforeXxxxx and isBeforeXxxxx member variables. These variables need to be set
//      to true before invoking the handlers and set to false before the invocation of the handlers. Resetting is MUST
//      as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//-----------------------------
public class UserDispatcher extends TriggerDispatcherBase {
    
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false; 
    
    
    //-----------------------------
    // @author Tran-Vu Tran
    // @date 24th April 2018
    // @description Called by the trigger framework to carry out the actions before the record(s) are created. If there is an
    //      existing call running on the same context, the re-entrant call will utilize the handler that was created
    //      in the original call.
    // @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new UserBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    //-----------------------------
    // @author Tran-Vu Tran
    // @date 24th April 2018
    // @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
    //      existing call running on the same context, the re-entrant call will utilize the handler that was created
    //      in the original call.
    // @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    //-----------------------------  
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new UserBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
    }
}