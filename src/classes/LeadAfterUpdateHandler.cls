/**
* @author : Anjani Shukla
* @date : 14 May 2018
* @description : SFDC1-6570 : This Method will update Lead Description 
* 			     on opportunity after lead conversion process.
* @companyname : Vertiba
*/

public class LeadAfterUpdateHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        LeadMethods.updateLeadDescriptionOnOpty(tp);
        LeadMethods.campaignFromLeadToOpportunity(tp);
    }
}