/**
 * @Author Paras Dhingra
 * @Date 15th Sep 2017
 * @Description SFDC1-4275 AfterDeleteHandler class for OpportunityLineItem object 
 * @company IHS Markit
 * 
 */
public class OpportunityLineItemAfterDeleteHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        
        OpportunityLineItemMethods.rollupValuesToOpportunity(tp);
        OpportunityLineItemMethods.deleteChildOpportunityLineItemSchedules(tp);
        OpportunityLineItemMethods.rollupProductInfoToOpportunity(tp);
    }
}