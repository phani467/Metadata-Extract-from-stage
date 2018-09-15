//***************************************
// @author : Mohit Modi
// @date : 4th June 2018
// @description : SFDC1-8546: Updating the Logic in Trigger from Process builder
//***************************************
public class AdClaimbeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        AdClaimMethods.PopulateDataValidationCompletedBy(tp);   
    }
}