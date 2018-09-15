/**
 * @Author Paras Dhingra
 * @Date 15th Sep 2017
 * @Description SFDC1-4275 TriggerDispatcher class for OpportunityLineItem object 
 * @company IHS Markit
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 11th April 2018
// @Last Modified Description: SFDC1-7027- Added before insert trigger
*/
public class OpportunityLineItemDispatcher extends TriggerDispatcherBase {

    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    
    
    /**
     * @Author Paras Dhingra
     * @Date 15th Sep 2017
     * @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are created. 
     *          If there is an   existing call running on the same context, 
     *          the rentrant call will utilize the handler that was createdin the original call.
     * @company IHS Markit
     * @Param TriggerParameters
     * @Return void
     */
    public virtual override void afterInsert(TriggerParameters tp) {
            if (!isAfterInsertProcessing) {
                isAfterInsertProcessing = true;
                execute(new OpportunityLineItemAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
                isAfterInsertProcessing = false;
            } else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        }
    /**
     * @Author Paras Dhingra
     * @Date 15th Sep 2017
     * @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are updated. 
     *          If there is an   existing call running on the same context, 
     *          the rentrant call will utilize the handler that was createdin the original call.
     * @company IHS Markit
     * @Param TriggerParameters
     * @Return void
     */
    public virtual override void afterUpdate(TriggerParameters tp) {
        if (!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new OpportunityLineItemAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }
    /**
     * @Author Paras Dhingra
     * @Date 15th Sep 2017
     * @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are deleted. 
     *          If there is an   existing call running on the same context, 
     *          the rentrant call will utilize the handler that was createdin the original call.
     * @company IHS Markit
     * @Param TriggerParameters
     * @Return void
     */
    public virtual override void afterDelete(TriggerParameters tp) {
        if (!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            execute(new OpportunityLineItemAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }
    
    /**
     * @Author : Mohit Modi
     * @Date : 23 April 2018
     * @Description : Called by the trigger framework to carry out the actions before the record(s) are deleted. 
     *          If there is an   existing call running on the same context, 
     *          the rentrant call will utilize the handler that was createdin the original call.
     * @company Vertiba
     * @Param TriggerParameters
     * @Return void
     */
    public virtual override void beforeDelete(TriggerParameters tp) {
        if (!isBeforeDeleteProcessing) {
            isBeforeDeleteProcessing = true;
            execute(new OpportunityLineItemBeforeDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isBeforeDeleteProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }
    
    /**
     * @Author Sruti Srivastava
     * @Date 9th April 2018
     * @Description SFDC1-7027 Called by the trigger framework to carry out the actions before the record(s) are created. 
     *  If there is an  existing call running on the same context, 
     *  the rentrant call will utilize the handler that was createdin the original call.
     * @company Vertiba
     * @Param TriggerParameters
     * @Return void
     */
    public virtual override void beforeInsert(TriggerParameters tp) {
        if (!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new OpportunityLineItemBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 21st July 2018
    // @param: TriggerParameters
    // @description: SFDC1-7059, SFDC1-7060 - Called by the trigger framework to carry out the actions before the record(s) are created. 
    // If there is an  existing call running on the same context, 
    //  the rentrant call will utilize the handler that was createdin the original call.
    // @param TriggerParameters
    // @return: void
    //------------------------------
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new OpportunityLineItemBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
    }
}