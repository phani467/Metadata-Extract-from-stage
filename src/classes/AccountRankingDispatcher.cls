/**
* @author Uttam Arya
* @date 6th Feb 2017
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*				on the AccountRanking object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*				This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*				to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*				as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @updated: 02 April 2018
* @updated by: Tran-Vu Tran
* @update reason: SFDC1-7592 Account Ranking Lift & Shift from Legacy Markit
*/
public class AccountRankingDispatcher extends TriggerDispatcherBase {
	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false; 
	
	/** 
	* @author Uttam Arya
	* @date 6th Feb 2017
	* @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
	*				existing call running on the same context, the rentrant call will utilize the handler that was created
	*				in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	*/
	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new AccountRankingAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

	/** 
	* @author Uttam Arya
	* @date 6th Feb 2017
	* @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
	*				existing call running on the same context, the rentrant call will utilize the handler that was created
	*				in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	*/	
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new AccountRankingAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
}