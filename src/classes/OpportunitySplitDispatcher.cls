//-------------------------------------
//@author: Paras Dhingra
//@date: 12th Feb 2018 
//@description : SFDC1-6857 This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//				on the OpportunitySplit object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//				This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//				to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//				as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//@company : IHS Markit
//
//-------------------------------------
public class OpportunitySplitDispatcher extends TriggerDispatcherBase {
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    
    //-------------------------------------
	// @author: Paras Dhingra
	// @date: 12th Feb 2018
	// @description: Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was created
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	//-------------------------------------
	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new OpportunitySplitAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}
	//-------------------------------------
	// @author: Paras Dhingra
	// @date: 13th Feb 2018
	// @description: Called by the trigger framework to carry out the actions after the record(s) are updated. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was updated
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	//-------------------------------------
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new OpportunitySplitAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}
	//-------------------------------------
	// @author: Paras Dhingra
	// @date: 13th Feb 2018
	// @description: Called by the trigger framework to carry out the actions after the record(s) are deleted. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was deleted
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got deleted.
	//-------------------------------------
	public virtual override void afterDelete(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new OpportunitySplitAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}
    //-----------------------------
    // @author Jagadesh Kumar
    // @date 20th April 2018
    // @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    //              existing call running on the same context, the rentrant call will utilize the handler that was created
    //              in the original call.
    // @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public virtual override void beforeUpdate(TriggerParameters tp) {  
        if(!isBeforeUpdateProcessing) {
          isBeforeUpdateProcessing = true;
          execute(new OpportunitySplitBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
          isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
  	}
}