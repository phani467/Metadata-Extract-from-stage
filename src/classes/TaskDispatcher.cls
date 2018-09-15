//-----------------------------
// @author : Uttam Arya
// @date : 29th Aug 2017
// @description : This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//              on the Account object. The Task handlers support allowing and prTasking actions for reentrant scenarios. 
//              This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//              to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//              as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//-----------------------------
public class TaskDispatcher extends TriggerDispatcherBase {
    
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;

    //-----------------------------
    // @author : Uttam Arya
    // @date : 29th Aug 2017
    // @description : SFDC1-2243 Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    //              existing call running on the same context, the rentrant call will utilize the handler that was created
    //              in the original call.
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(new TaskAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
    }
    
    //-----------------------------
    // @author : Mohit Modi
    // @date : 17 Jan 2018
    // @description : SFDC1-5027 Called by the trigger framework to carry out the actions after the record(s) are deleted. If there is an
    //              existing call running on the same context, the rentrant call will utilize the handler that was created
    //              in the original call.
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void afterDelete(TriggerParameters tp) {
        if(!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            execute(new TaskAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }
}