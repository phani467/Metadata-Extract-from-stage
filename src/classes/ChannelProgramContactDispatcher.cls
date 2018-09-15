//-------------------------------------
//@author: Mohit Modi
//@date: 18 June 2018 
//@description : This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//        on the ChannelProgramContact object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//        This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//        to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//        as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//@company : Vertiba
//
//-------------------------------------
public class ChannelProgramContactDispatcher extends TriggerDispatcherBase {

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
  public virtual override void beforeInsert(TriggerParameters tp) {
    if(!isbeforeInsertProcessing) {
      isbeforeInsertProcessing= true;
      execute(new ChannelProgramContactbeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isbeforeInsertProcessing= false;
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
    if(!isbeforeUpdateProcessing) {
      isbeforeUpdateProcessing= true;
      execute(new ChannelProgramContactbeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isbeforeUpdateProcessing= false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
}