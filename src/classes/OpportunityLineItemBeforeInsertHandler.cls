// @Author : Sruti Srivastava
// @Created Date: 10th April 2018
// @Description: SFDC1-7027- BeforeInsert class for OpportunityLineItem object 
// Added method populateContractStartDateAndEndDate which 
// populate Contract Start Date and End Date on Opportunity Line Items form Opportunity
// 
public class OpportunityLineItemBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        OpportunityLineItemMethods.populateContractStartDateAndEndDate(tp);
    }
}