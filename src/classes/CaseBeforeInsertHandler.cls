//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description Re-structuring the trigger methods by using Trigger Handler framework. Org assessment 2016.
// @updated by : Mohit Modi
// @updated description : SFDC1-6009, To set the Contact Name same as Owner, if Contact Exists only for 'Sales Support' Recordtype, Valid for insert and Owner update only with a specified Account stored in Label.
// @updated date : 06 Feb 2018
// @Updated By : Jagadesh Kumar
// @Updated description SFDC1-8014 :Used to populate the Case lookup fields
// @Updated date : 30 May 2018
// @Updated By : Prachi Bhasin
// @Updated description SFDC1-8945 Adding call to populateOMDeliveryHelpDeskCaseFields method
// @Updated date : 12 July 2018
// @Updated by: Tran-Vu Tran
// @Updated description:
//  + SFDC1-8356: adding setCaseProductGroupForOrderManagementDeliveryHelpDesk
//  + SFDC1-8381: combining SFDC1-965 into setInternalCaseAccountAndContact
// @Updated date : 06 June 2018
// @LastModifieddate : 18 July 2018
// @LastModifieby : Mohit Modi
// @LastModifieddescription : SFDC1-9031-Commenting this Method as field ContractOwner__c and OpportunityOwner__c is nomore required.
//***************************************
public class CaseBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        CaseMethods.assignCasesViaTriage(tp);
        CaseMethods.setCaseProductGroupFromProductFamily(tp);
        CaseMethods.setCaseProductGroupForOrderManagementDeliveryHelpDesk(tp);
        CaseMethods.setContactNamefromOwner(tp);
      //CaseMethods.populateCaseLookUpFields(tp);
        CaseMethods.setInternalCaseAccountAndContact(tp);
        CaseMethods.validateCaseContactAndAccountMatch(tp);
        CaseMethods.populateOMDeliveryHelpDeskCaseFields(tp);
    }
}