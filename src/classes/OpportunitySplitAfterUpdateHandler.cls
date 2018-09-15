//--------------------------------
// @author: Paras Dhingra
// @date: 13th Feb 2018
// @description: SFDC1-6856 Handler method for Opportunity Split trigger
// @company: IHS Markit
//--------------------------------
public class OpportunitySplitAfterUpdateHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
	    
	    OpportunitySplitMethods.postChatterFeedItem(tp);
	    
	}
}