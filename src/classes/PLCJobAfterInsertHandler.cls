//-----------------------------
// @author Anjani Shukla
// @date 29 Sept 2017
// @param: TriggerParameters
// @description:  This Class is used in POLK WRF.
// @return: NA
//-----------------------------

public class PLCJobAfterInsertHandler extends TriggerHandlerBase {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public override void mainEntry(TriggerParameters tp) {
        // call PLCJobMethods class for specific functions.
        PLCJobMethods.createDeliveryTaskOnJobInsert(tp);
    }
}