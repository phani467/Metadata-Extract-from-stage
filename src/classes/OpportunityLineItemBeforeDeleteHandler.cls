//***************************************
// @author : Mohit Modi
// @date : 23 April 2018
// @description : Methods releated to Opportunity Line Item Before Deletion Event
//***************************************
public class OpportunityLineItemBeforeDeleteHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
    OpportunityLineItemMethods.preventOpportunityLineItemDeletion(tp);
  }
}