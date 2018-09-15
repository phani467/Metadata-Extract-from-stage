//-----------------------------
// @author Prachi Bhasin
// @date 3 July 2017
// @param: TriggerParameters
// @description:  AfterUpdate dispatcher event handler class that calls the functions in OpportunityMethods.
// @return: NA
// @Last Modified By : Mohit Modi
// @Last Modified Date: 28 Mar 2018
// @Last Modified Description: SFDC1-7635 : Added Method 'updateReferredByOnOpportunityTeam' to Update Opportunity Team based on the 'Referred By' field on Opportunity.
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 9th April 2018
// @Last Modified Description: SFDC1-7027- Added method updateContractStartDateAndEndDateOnOpportunityLineItem which updates
// Contract Start Date and End Date on Opportunity Line Items if 'ContractStartDate__c' 
// and 'ContractEndDate__c' field on Opportunity are updated
// @Last Modified By : Anjani Shukla
// @Last Modified Date: 09 Apr 2018
// @Last Modified Description: SFDC1-7667 : Added Method 'updateOpportunityRiskRecordStatus' to update Opportunity Risk Record Status when New Business 
//                                          Opportunity is being set to 6L - Closed Lost and an Opportunity at Risk record exists with the status = "Open - //Pending Resolution", then 
//                                          set the Status field to “Closed - Opportunity Lost”.
// @Last Modified Description: SFM-159 :    Added Method 'changeAdditionalOpportunityFieldsNameWhenOpportunityFieldChanges' to update Opportunity Additional Fields in sync.
//-----------------------------
public class OpportunityAfterUpdateHandler extends TriggerHandlerBase{
    
    public override void mainEntry(TriggerParameters tp) {
        OpportunityMethods.updateOpportunitySplitOnGamChange(tp);
        OpportunityMethods.updateGAMOnOpportunityTeam(tp);
        OpportunityMethods.changeAccountOwnershipOnInsertUpdate(tp);
        OpportunityMethods.updateAccountRelationship(tp);
        OpportunityMethods.updateReferredByOnOpportunityTeam(tp);
        OpportunityMethods.updateContractStartDateAndEndDateOnOpportunityLineItem(tp);
        OpportunityMethods.updateOpportunityRiskRecordStatus(tp);
        OpportunityMethods.createOMCaseOnRenewalOpportunityClosure(tp);
        OpportunityMethods.updateFiscalOnChangeOfCloseDate(tp);
		OpportunityMethods.updateCumulativeContract(tp);
        OpportunityMethods.revisitOpportunityTaskChanges(tp);
        OpportunityMethods.changeAdditionalOpportunityFieldsNameWhenOpportunityFieldChanges(tp);      
    }
}