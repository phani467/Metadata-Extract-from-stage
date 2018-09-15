//-----------------------------
// @author: Mohit Modi
// @date: 16 April 2018
// @description: This Class will hold all the methods related to Billing Schedule Line Items for beforeInsert.
// @return: None
// @Updatedescription : added 'CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation' method to prevent the creation of BSL based on CLI Billing Period value.
//------------------------------
public class BillingScheduleLIBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        BillingScheduleLineItemMethods.CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation(tp);
    }
}