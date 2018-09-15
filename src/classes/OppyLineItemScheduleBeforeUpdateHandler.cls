//
// @Author Paras Dhingra
// @Date 11th July 2018
// @Description SFDC1-9058 BeforeUpdateHandler class for OpportunityLineItemSchedule object 
// @company IHS Markit
// Note : Trigger framework naming standard not used because of 40 character limit
//
public class OppyLineItemScheduleBeforeUpdateHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {        
        OpportunityLineItemScheduleMethods.populateAnnualizedValues(tp);
    }
}