//-----------------------------
// @author: Anjani Shukla
// @date: 06 July 2018
// @param: TriggerParameters
// @description: SFDC1-8326 -Update Campaign Influence to Work with OoB Lead Conversion and for Equal Attribution
// @return: NA
//-----------------------------

public class CampaignInfluenceAfterInsertHandler extends TriggerHandlerBase {
	//-----------------------------
    // @author: Anjani Shukla
    // @date: 06 July 2018
    // @param: TriggerParameters
    // @description: SFDC1-8326 -Update Campaign Influence to Work with OoB Lead Conversion and for Equal Attribution
    // @return: NA
    //-----------------------------
    public override void mainEntry(TriggerParameters tp) {   
    	CampaignInfluenceMethods.updateCampaignInfluencePercent(tp);
    }

}