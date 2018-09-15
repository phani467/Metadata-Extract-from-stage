//-----------------------------
// @author Anjani Shukla
// @date 29 Sept 2017
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in OpportunityMethods.
// @return: NA
//-----------------------------

public class ChangeLogAfterInsertHandler extends TriggerHandlerBase {
    //-----------------------------
    // @author Anjani Shukla
    // @date 29 Sept 2017
    // @param: TriggerParameters
    // @description:  AfterInsert dispatcher event handler class that calls the functions in ChangeLogMethods.
    // @return: NA
    //-----------------------------
    public override void mainEntry(TriggerParameters tp) {
        // call PLCJobMethods class for specific functions.
        //ChangeLogMethods.notificationEmail(tp);
    }
}