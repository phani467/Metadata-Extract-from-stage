// @Author : Paras Dhingra
// @Created Date: 23rd July 2018
// @Description: SFDC1-7059, SFDC1-7060 BeforeUpdate class for OpportunityLineItem object 
// added call for Opportunity product validations for auto-renewal opportunities
// 
public class OpportunityLineItemBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        OpportunityLineItemMethods.oppyProductValidations(tp);
    }
}