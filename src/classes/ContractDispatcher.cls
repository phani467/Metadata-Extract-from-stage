/**
* @author: Mohit Modi
* @date: 27 September 2017
* @description: SFDC1-4363. This class extends the TriggerDispatcherBase to provide the dispatching functionality for the
*        trigger actions on the Contract object. The event handlers support allowing and preventing actions for 
*        reentrant scenarios. This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables 
*        need to be set to true before invoking the handlers and set to false after the invocation of the handlers. Resetting 
*        is MUST as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @companyname: VERTIBA
* @LastModifiedby: Prachi Bhasin
* @ModifiedDate: 26 Feb 2018
* @description: SFDC1-4739: Adding beforeDelete method
* @LastModifiedby: Vishnu Vardhan Chowdary
* @ModifiedDate: 12 Mar 2018
* @description: SFDC1-4324, 4702, 7204: Adding After Update method
*/
public class ContractDispatcher extends TriggerDispatcherBase {

    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    private static Boolean isAfterDeleteProcessing = false;

    /** 
  * @author: Mohit Modi
  * @date: 27 September 2017
  * @description: SFDC1-4363. Called by the trigger framework to carry out the actions before the record(s) are inserted. If 
  *        a Contract is Created, then Copy the Primary Contact Values to Contract Record.
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
  * @companyname: VERTIBA
  * @return: void
  */
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new ContractBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    /** 
  * @author: Mohit Modi
  * @date: 27 September 2017
  * @description: SFDC1-4363. Called by the trigger framework to carry out the actions before the record(s) are Updated. If 
  *        Contract is updated with new Opportunity, then update the Updated Primary Contact values to Contract
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
  * @companyname: VERTIBA
  * @return: void
  */
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new ContractBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
  /** 
  * @author: Prachi Bhasin
  * @date: 26 Feb 2018
  * @description: SFDC1-4739. Called by the trigger framework to carry out the actions before the record(s) are Updated. If 
  *        Contract is updated with new Opportunity, then update the Updated Primary Contact values to Contract
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got insertes.
  * @companyname: VERTIBA
  * @return: void
  */
    public virtual override void beforeDelete(TriggerParameters tp) {
        if(!isBeforeDeleteProcessing) {
            isBeforeDeleteProcessing = true;
            execute(new ContractBeforeDeleteHandler(), tp, TriggerParameters.TriggerEvent.beforeDelete);
            isBeforeDeleteProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeDelete);
    }

    //-----------------------------
    // @author: Ankita Singh, Vishnu Vardhan Chowdary
    // @date: 06 March 2018
    // @description: SFDC1-4702. Called by the trigger framework to carry out the actions after the record(s) are Updated. If 
    //              Contract is updated and conditions are met then case record gets created.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @companyname: VERTIBA
    // @return: void
    //-----------------------------
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new ContractAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }
}