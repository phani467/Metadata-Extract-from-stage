//-----------------------------
// @author: Tran-Vu Tran
// @date: 16 July 2018
// @param: NA
// @description:This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//              on the Case object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//              This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//              to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//              as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
// @return: NA
//-----------------------------
public class dsfsDocuSignStatusDispatcher extends TriggerDispatcherBase {
    
    private static Boolean isBeforeInsertProcessing = false;
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 16 July 2018
    // @description: SFDC1-7947 Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    //              existing call running on the same context, the rentrant call will utilize the handler that was created in the original call.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void beforeInsert(TriggerParameters tp) {
        if (!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new DocuSignStatusBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }

}