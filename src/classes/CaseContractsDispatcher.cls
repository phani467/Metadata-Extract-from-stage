/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 23 August 2017
* @description: SFDC1-593. This class extends the TriggerDispatcherBase to provide the dispatching functionality for the
*        trigger actions on the Case Contracts object. The event handlers support allowing and preventing actions for 
*        reentrant scenarios. This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables 
*        need to be set to true before invoking the handlers and set to false after the invocation of the handlers. Resetting 
*        is MUST as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @companyname: VERTIBA
*/
public class CaseContractsDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    private static Boolean isAfterDeleteProcessing = false;
  
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 23 August 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions after the record(s) are inserted. If 
	*        there is an existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void afterInsert(TriggerParameters tp) {
        if (!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(new CaseContractsAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        }
    }

    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 23 August 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions after the record(s) are updated. If 
	*        there is an existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new CaseContractsAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        }
    }
  
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 23 August 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions after the record(s) are deleted. If 
	*        there is an existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got deleted.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void afterDelete(TriggerParameters tp) {
        if(!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            execute(new CaseContractsAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
        }
    }
    
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 25 September 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions before the record(s) are inserted. If 
	*        a case has a contract and user tries to add same contract again to the case then it should not be allowed.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new CaseContractsBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 25 September 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions before the record(s) are Updated. If 
	*        a case has a contract and user tries to add same contract again to the case then it should not be allowed.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new CaseContractsBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
}