//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters
// @description:  AfterUpdate dispatcher event handler class that calls the functions in CaseMethods.
// @return: NA
// @Modified by : Paras Dhingra
// @Modified date: 30th Jun 2017
// @Modification reason : SFDC1-441 Adding updateCaseMilestone method invocation
// @Modified by : Ankita Singh
// @Modified date: 13 March 2018
// @Modification reason : SFDC1-7182,7184: Adding validateImplementationCaseClose method invocation &&
// SFDC1-7183/7185: Adding afterAllCaseClosedOnContract method invocation
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 20 March 2018
// @Modification reason : SFDC1-7163: adding upsertOnboardingCaseFromImplementationCase
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 13 April 2018
// @Modification reason : SFDC1-7826: Removing Code written for 7182,7183,7184,7185.
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 16 May 2018
// @Modification reason : SFDC1-7183: adding afterAllCaseClosedOnContract
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 18 May 2018
// @Modification reason : SFDC1-7740: adding updateContractWhenOMCaseIsValidated
// @Modified by : Vishnu Vardhan Chowdary Andra
// @Modified date: 21 May 2018
// @Modification reason : SFDC1-8120: adding updateContractWhenOMCaseIsRejected
//-----------------------------
public class CaseAfterUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        
        CaseMethods.setCaseAdditionalFieldsObject(tp);
        CaseMethods.updateCaseMilestones(tp);
        CaseMethods.updateContractWhenOMCaseIsValidated(tp);
        CaseMethods.updateContractWhenOMCaseIsRejected(tp);
        CaseMethods.afterAllCaseClosedOnContract(tp);
        CaseMethods.upsertOnboardingCaseFromImplementationCase(tp);
    }
}