//-------------------------------------
//@author: Mohit Modi
//@date: 4th June 2018 
//@description : This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//        on the AdClaim object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//        This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//        to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//        as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//@company : Vertiba
//
//-------------------------------------
public class AdClaimDispatcher extends TriggerDispatcherBase {
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isbeforeInsertProcessing = false;
    private static Boolean isbeforeUpdateProcessing = false;
    
  //-------------------------------------
  // @author: Mohit Modi
  // @date: 4th June 2018
  // @description: Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
  //        existing call running on the same context, the rentrant call will utilize the handler that was created
  //        in the original call.
  // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
  //-------------------------------------
  public virtual override void afterInsert(TriggerParameters tp) {
    if(!isAfterInsertProcessing) {
      isAfterInsertProcessing = true;
      execute(new AdClaimAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isAfterInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
  //-------------------------------------
  // @author: Mohit Modi
  // @date: 4th June 2018
  // @description: Called by the trigger framework to carry out the actions after the record(s) are updated. If there is an
  //        existing call running on the same context, the rentrant call will utilize the handler that was updated
  //        in the original call.
  // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
  //-------------------------------------
  public virtual override void afterUpdate(TriggerParameters tp) {
    if(!isAfterUpdateProcessing) {
      isAfterUpdateProcessing = true;
      execute(new AdClaimAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isAfterUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
  //-------------------------------------
  // @author: Mohit Modi
  // @date: 4th June 2018
  // @description: Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
  //        existing call running on the same context, the rentrant call will utilize the handler that was created
  //        in the original call.
  // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
  //-------------------------------------
  public virtual override void beforeInsert(TriggerParameters tp) {
    if(!isbeforeInsertProcessing) {
      isbeforeInsertProcessing = true;
      execute(new AdClaimbeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isbeforeInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
  //-------------------------------------
  // @author: Mohit Modi
  // @date: 4th June 2018
  // @description: Called by the trigger framework to carry out the actions after the record(s) are updated. If there is an
  //        existing call running on the same context, the rentrant call will utilize the handler that was updated
  //        in the original call.
  // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
  //-------------------------------------
  public virtual override void beforeUpdate(TriggerParameters tp) {
    if(!isbeforeUpdateProcessing ) {
      isbeforeUpdateProcessing = true;
      execute(new AdClaimbeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isbeforeUpdateProcessing  = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
}