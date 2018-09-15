//-----------------------------
// @author Prachi Bhasin
// @date 4 July 2017
// @param: TriggerParameters
// @description:  BeforeUpdate dispatcher event handler class that calls the functions in OpportunityMethods.
// @return: NA
// @Update author : Hemant Shukla
// @description : SFDC1-5436 : Calling an additonal method checkEndUserCertificateAttachment()
// @Update author : Sonam Raju
// @Updated On : 3 JAN 2018
// @description : SFDC1-6245 Calling an additonal method checkChannelManagerRoleonOpptyTeamforStage2andhigher()
// @Last Modified By : Anjani Shukla
// @Last Modified Date: 05 Jun 2018
// @Last Modified Description: SFDC1-8392 : Added Method - "updateOpportunityGAM" Update Account Manager on 
// 							   Opportunity when Account is updated.
// @Last Modified By : Anjani Shukla
// @Last Modified Date: 21 Jun 2018
// @Last Modified Description: SFDC1-8147 : Added Method - "updateOpportunityProductRestriction" Updated to restrict Opportunity Stage 
//                                          change when New Bizz Oppty record type contains product which is Cross Plant Status.
// @Last Modified By : Paras Dhingra
// @Last Modified Date: 21 July 2018
// @Last Modified Description: SFDC1-7059, SFDC1-7060 : Added Method - "opportunityValidations" for auto renewal validations
// @Last Modified By : Jagadesh Kumar
// @Last Modified Date: 31 July 2018
// @Last Modified Description:SFDC1-5228 - Populate Primary Contact Name on Opportunity
//-----------------------------
public class OpportunityBeforeUpdateHandler extends TriggerHandlerBase{
    
  public override void mainEntry(TriggerParameters tp) {
    OpportunityMethods.checkPrimaryContactOnNewBusinessOpportunity(tp);
    OpportunityMethods.checkChannelManagerRoleonOpptyTeamforStage2andhigher(tp);
    OpportunityMethods.updateOpportunityGAM(tp);
    OpportunityMethods.copyBilltoShiptoFromOriginatingContractToRenewalOpportunity(tp);
    OpportunityMethods.updateOpportunityProductRestriction(tp);
    OpportunityMethods.opportunityValidations(tp);
    OpportunityMethods.revisitOpportunityStageChanges(tp);
    OpportunityMethods.setContactRolePrimary(tp);
  }
}