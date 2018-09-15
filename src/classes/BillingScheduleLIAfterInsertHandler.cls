//-----------------------------
// @author: Mohit Modi
// @date: 16 April 2018
// @description: This Class will hold all the methods related to Billing Schedule Line Items for afterInsert.
// @return: None
// @Updatedescription : added 'CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation' method to create the clone of BSL based on CLI Billing Period value.
//------------------------------
public class BillingScheduleLIAfterInsertHandler extends TriggerHandlerBase {
  
    public override void mainEntry(TriggerParameters tp) {
        BillingScheduleLineItemMethods.CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation(tp);
    }
}