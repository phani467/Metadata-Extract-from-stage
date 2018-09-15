/**
 * @Author Paras Dhingra
 * @Date 15th Sep 2017
 * @Description SFDC1-4275 AfterInsertHandler class for OpportunityLineItem object 
 * @company IHS Markit
*/
public class OpportunityLineItemAfterInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        OpportunityLineItemMethods.rollupValuesToOpportunity(tp);  
        OpportunityLineItemMethods.rollupProductInfoToOpportunity(tp);
    }
}