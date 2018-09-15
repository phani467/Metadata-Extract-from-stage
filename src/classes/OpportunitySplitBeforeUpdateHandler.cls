//--------------------------------
// @author: Jagadesh Kumar
// @date: 20th April 2018
// @description: SFDC1-8019 Handler method for Opportunity Split trigger
// @company: Vertiba
//--------------------------------
public class OpportunitySplitBeforeUpdateHandler extends TriggerHandlerBase{
	public override void mainEntry(TriggerParameters tp) {
        //SFDC1-7578-Due to limitation from SF end commenting this code for now.
        //OpportunitySplitMethods.validateOverlaySplitAmount(tp);
    }
}