//-----------------------------
// @author: Anjani Shukla
// @date: 06 Feb 2018
// @description: This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
//              on the Opportunity object. The event handlers support allowing and preventing actions for reentrant scenarios. 
//              This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
//              to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
//              as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
//-----------------------------
public class CampaignInfluenceDispatcher  extends TriggerDispatcherBase {
	private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isBeforeDeleteProcessing = false;
	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false; 
	private static Boolean isAfterDeleteProcessing = false;
	
	//-----------------------------
	// @author: Anjani Shukla
	// @date: 7th Feb 2018
	// @description: Called by the trigger framework to carry out the actions before the records are inserted. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was created
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
	//-----------------------------
	public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new CampaignInfluenceBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}	
    
    //-----------------------------
	// @author: Anjani Shukla
	// @date: 7th Feb 2018
	// @description: Called by the trigger framework to carry out the actions before the records are inserted. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was created
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
	//-----------------------------
	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new CampaignInfluenceAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.AfterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.AfterInsert);
	}	
    
    
    
    //-----------------------------
	// @author: Anjani Shukla
	// @date: 7th Feb 2018
	// @description: Called by the trigger framework to carry out the actions before the records are inserted. If there is an
	//				existing call running on the same context, the rentrant call will utilize the handler that was created
	//				in the original call.
	// @param: TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
	//-----------------------------
	 public virtual override void afterDelete(TriggerParameters tp) {
		if(!isAfterDeleteProcessing) {
			isAfterDeleteProcessing = true;
			execute(new CampaignInfluenceAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.AfterDelete);
			isAfterDeleteProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.AfterDelete);
	}  
    
		
}