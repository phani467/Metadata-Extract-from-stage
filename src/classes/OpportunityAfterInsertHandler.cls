//-----------------------------
// @author Prachi Bhasin
// @date 3 July 2017
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in OpportunityMethods.
// @return: NA
// @Modification : exemption for sys admin and sales ops profile removed as per SFDC1-5782 and SFDC1-5029
// @Modified by : Ankita Singh on 4th December,2017
// @Last Modified By : Sonam Raju
// @Last Modified Date: 12 Mar 2018
// @Last Modified Description: SFDC1-6937 Added setOpportunityAdditionalFieldsObject to create Additional Opportunity Field record when a 'New Business' Opportunity is created
// @Last Modified By : Mohit Modi
// @Last Modified Date: 28 Mar 2018
// @Last Modified Description: SFDC1-7635 : Added Method 'updateReferredByOnOpportunityTeam' to Update Opportunity Team based on the 'Referred By' field on Opportunity.
//-----------------------------
public class OpportunityAfterInsertHandler extends TriggerHandlerBase{
    
  public override void mainEntry(TriggerParameters tp) {
    OpportunityMethods.updateOpportunitySplitOnGamChange(tp);
    OpportunityMethods.updateGAMOnOpportunityTeam(tp);
    OpportunityMethods.changeAccountOwnershipOnInsertUpdate(tp);
    OpportunityMethods.updateAccountRelationship(tp);
    OpportunityMethods.setOpportunityAdditionalFieldsObject(tp);
    OpportunityMethods.updateReferredByOnOpportunityTeam(tp);
  }
}