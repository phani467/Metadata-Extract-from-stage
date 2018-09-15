/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 26 September 2017
* @description: SFDC1-593. This class extends the TriggerDispatcherBase to provide the dispatching functionality for the
*        trigger actions on the Case Products object. The event handlers support allowing and preventing actions for 
*        reentrant scenarios. This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables 
*        need to be set to true before invoking the handlers and set to false after the invocation of the handlers. Resetting 
*        is MUST as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @companyname: VERTIBA
*/
public class CaseProductsDispatcher extends TriggerDispatcherBase {

    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    private static Boolean isAfterDeleteProcessing = false;

    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 26 September 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions before the record(s) are inserted. If 
	*        a case has a product and user tries to add same product again to the case then it should not be allowed.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new CaseProductsBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 25 September 2017
	* @description: SFDC1-593. Called by the trigger framework to carry out the actions before the record(s) are Updated. If 
	*        a case has a product and user tries to add same product again to the case then it should not be allowed.
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
	* @companyname: VERTIBA
	* @return: void
	*/
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new CaseProductsBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
}