//-----------------------------
// @author: Vishnu vardhan Chowdary Andra
// @date: 19 June 2018
// @param: TriggerParameters
// @description:  After update dispatcher event handler class that calls the functions in AdditionalCaseFieldsMethods.
// @return: NA
//-----------------------------
public class AdditionalCaseFieldsAfterUpdateHandler extends TriggerHandlerBase {
    //-----------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 19 June 2018
    // @description Called by the trigger framework to carry out the actions after the record(s) are updated. If there is an
    //				existing call running on the same context, the rentrant call will utilize the handler that was created
    //				in the original call.
    // @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    //-----------------------------
    public override void mainEntry(TriggerParameters tp) {
        AdditionalCaseFieldsMethods.populateDeliveryQueuesInCase(tp);
    }
}