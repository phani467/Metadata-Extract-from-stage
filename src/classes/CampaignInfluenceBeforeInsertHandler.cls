//-----------------------------
// @author: Anjani Shukla
// @date: 06 Feb 2018
// @param: TriggerParameters
// @description: SFDC1-6636 & SFDC1-6657 BeforeInsert dispatcher event 
//				 handler class that calls the functions in Campaign Influence .
// @return: NA
//-----------------------------

public class CampaignInfluenceBeforeInsertHandler extends TriggerHandlerBase {
	//-----------------------------
    // @author: Anjani Shukla
    // @date: 06 Feb 2018
    // @param: TriggerParameters
    // @description:  Before Insert - This will call CampaignInfluenceMethods class 
	//                where record will be verified to diplay relevant error message
	//           	  for duplicate and opportunity close date if over 90 days. 
	//				  SFDC1-6636 & SFDC1-6657 
	//				   
    // @return: NA
    //-----------------------------
    public override void mainEntry(TriggerParameters tp) {
	    CampaignInfluenceMethods.checkDuplicateandOptyCloseDuration(tp);
    }    
}