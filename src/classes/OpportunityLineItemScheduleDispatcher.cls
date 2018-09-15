//
// @Author Paras Dhingra
// @Date 15th Sep 2017
// @Description SFDC1-4275 TriggerDispatcher class for OpportunityLineItemSchedule object 
// @company IHS Markit
//
public class OpportunityLineItemScheduleDispatcher extends TriggerDispatcherBase {

    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;

    //
    // @Author Paras Dhingra
    // @Date 15th Sep 2017
    // @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are created. 
    //          If there is an   existing call running on the same context, 
    //          the rentrant call will utilize the handler that was createdin the original call.
    // @company IHS Markit
    // @Param TriggerParameters
    // @Return void
    //
    public virtual override void afterInsert(TriggerParameters tp) {
            if (!isAfterInsertProcessing) {
                isAfterInsertProcessing = true;
                execute(new OppyLineItemScheduleAfterInsertHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
                isAfterInsertProcessing = false;
            } else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        }
    //
    // @Author Paras Dhingra
    // @Date 15th Sep 2017
    // @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are updated. 
    //          If there is an   existing call running on the same context, 
    //          the rentrant call will utilize the handler that was createdin the original call.
    // @company IHS Markit
    // @Param TriggerParameters
    // @Return void
    //
    public virtual override void afterUpdate(TriggerParameters tp) {
        if (!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new OppyLineItemScheduleAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }
    //
    // @Author Paras Dhingra
    // @Date 15th Sep 2017
    // @Description SFDC1-4275 Called by the trigger framework to carry out the actions after the record(s) are deleted. 
    //          If there is an   existing call running on the same context, 
    //          the rentrant call will utilize the handler that was createdin the original call.
    // @company IHS Markit
    // @Param TriggerParameters
    // @Return void
    //
    public virtual override void afterDelete(TriggerParameters tp) {
        if (!isAfterDeleteProcessing) {
            isAfterDeleteProcessing = true;
            execute(new OppyLineItemScheduleAfterDeleteHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
            isAfterDeleteProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
    }
    //
    // @Author Paras Dhingra
    // @Date 11th July 2018
    // @Description SFDC1-9058 Called by the trigger framework to carry out the actions after the record(s) are deleted. 
    //          If there is an   existing call running on the same context, 
    //          the rentrant call will utilize the handler that was createdin the original call.
    // @company IHS Markit
    // @Param TriggerParameters
    // @Return void
    //
    public virtual override void beforeInsert(TriggerParameters tp) {
        if (!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new OppyLineItemScheduleBeforeInsertHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    //
    // @Author Paras Dhingra
    // @Date 11th July 2018
    // @Description SFDC1-9058 Called by the trigger framework to carry out the actions after the record(s) are deleted. 
    //          If there is an   existing call running on the same context, 
    //          the rentrant call will utilize the handler that was createdin the original call.
    // @company IHS Markit
    // @Param TriggerParameters
    // @Return void
    //
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if (!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new OppyLineItemScheduleBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        } else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
    }
}