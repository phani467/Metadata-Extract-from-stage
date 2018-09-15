/**
* @author: Ankita Singh
* @date: 18th June 2018
* @description: SFDC1-8559. This class extends the TriggerDispatcherBase to provide the dispatching functionality for the
*        trigger actions on the ContractAttachment object. The event handlers support allowing and preventing actions for 
*        reentrant scenarios. This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables 
*        need to be set to true before invoking the handlers and set to false after the invocation of the handlers. Resetting 
*        is MUST as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
* @companyname: VERTIBA
*/ 
public class ContractAttachmentDispatcher extends TriggerDispatcherBase {

    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;
    
  /** 
  * @author: Ankita Singh
  * @date: 18 June 2018
  * @description: SFDC1-8559. Called by the trigger framework to carry out the actions after the record(s) are deleted. 
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got deleted.
  * @companyname: VERTIBA
  * @return: void
  */ 
    public virtual override void afterDelete(TriggerParameters tp) {
        if(!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            execute(new ContractAttachmentAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }

    //-----------------------------
    // @author: Ankita Singh
    // @date: 18 June 2018
    // @description: SFDC1-8559. Called by the trigger framework to carry out the actions after the record(s) are Inserted.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got inserted.
    // @companyname: VERTIBA
    // @return: void
    //-----------------------------
    public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing ) {
            isAfterInsertProcessing = true;
            execute(new ContractAttachmentAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
    }
}