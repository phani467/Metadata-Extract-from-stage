/**
 * @Author Paras Dhingra
 * @Date 15th Sep 2017
 * @Description SFDC1-4275 AfterUpdateHandler class for OpportunityLineItemSchedule object 
 * @company IHS Markit
 * Note : Trigger framework naming standard not used because of 40 character limit
 */
public class OppyLineItemScheduleAfterUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        
        OpportunityLineItemScheduleMethods.rollUpValuesToOppyProduct(tp);
    }
}