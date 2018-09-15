//***************************************
// @author : Mohit Modi
// @date : 4th June 2018
// @description : SFDC1-460: Updating the Logic in Trigger from Process builder
//***************************************
public class AdClaimChangeLogAfterInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        AdClaimChangeLogMethods.AdClaimChangeLogStatusChange(tp);
    }
}