/**
* @author Uttam Arya
* @date 22nd July 2017
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*				on the LiveChatTranscript object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*				This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*				to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*				as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
*/
public class LiveChatTranscriptDispatcher extends TriggerDispatcherBase {
	
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    
	
	/**  
	* @author Uttam Arya
	* @date 22nd July 2017
	* @description Called by the trigger framework to carry out the actions before the records are inserted. If there is an
	*				existing call running on the same context, the rentrant call will utilize the handler that was created
	*				in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
	*/
	public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new LiveChatTranscriptBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}
    
    /** 
	* @author: Uttam Arya
	* @date: 13 Nov 2017
	* @description: SFDC1-5540. Called by the trigger framework to carry out the actions before the record(s) are Updated. 
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
	* @companyname: IHS Markit 
	* @return: void
	*/
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new LiveChatTranscriptBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }

	
	/** 
	* @author Uttam Arya
	* @date 22nd July 2017
	* @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
	*				existing call running on the same context, the rentrant call will utilize the handler that was created
	*				in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	*/
	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new LiveChatTranscriptAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}
    
    /** 
	* @author: Uttam Arya
	* @date: 13 Nov 2017
	* @description: SFDC1-5540. Called by the trigger framework to carry out the actions after the record(s) are Updated. 
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated .
	* @companyname: IHS Markit 
	* @return: void
	*/
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new LiveChatTranscriptAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        } 
    }
    
}