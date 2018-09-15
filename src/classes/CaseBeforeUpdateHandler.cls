//***************************************
// @author: Uttam Arya
// @date: 1st Nov 2017
// @description: Trigger Handler Base class for before insert trigger as per Trigger Handler framework.
// @updated by : Mohit Modi
// @updated description : SFDC1-6009, To set the Contact Name same as Owner, if Contact Exists only for 'Sales Support' Recordtype, Valid for insert and Owner update only with a specified Account stored in Label.
// @updated date : 06 Feb 2018
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 21 March 2018
// @Modification reason : SFDC1-7163: adding validateIfOBCaseCanCreateFromImplCase
// @Modified by : Prachi Bhasin
// @Modified date: 3 May 2018
// @Modification reason : SFDC1-7574: adding assignCasesViaTriage
//***************************************
// @Modified by: Tran-Vu Tran
// @Modified description:
// 	+ SFDC1-8356: adding setCaseProductGroupForOrderManagementDeliveryHelpDesk
// 	+ SFDC1-8381: combining SFDC1-965 into setInternalCaseAccountAndContact
// @Modified date : 06 June 2018 
//***************************************

public class CaseBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        System.debug('@@@UA');
        CaseMethods.assignCasesViaTriage(tp);
        CaseMethods.setCaseProductGroupFromProductFamily(tp);
        CaseMethods.setCaseProductGroupForOrderManagementDeliveryHelpDesk(tp);
        CaseMethods.setContactNamefromOwner(tp);
        CaseMethods.validateIfOBCaseCanCreateFromImplCase(tp);
    }
}