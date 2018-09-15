//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in CaseMethods.
// @return: NA
// @Modified by : Paras Dhingra
// @Modified date: 30th Jun 2017
// @Modification reason : SFDC1-441 Adding updateCaseMilestone method invocation
// @Modified by : Hemant Shukla
// @Modified date: 18 Jan, 2018
// @Modification reason : SFDC1-6629, added a new method fireCaseAssignmentRule(). To fire the case Assignment rules which are created in Quick Actions
//-----------------------------
public class CaseAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    CaseMethods.setCaseAdditionalFieldsObject(tp);
    CaseMethods.updateCaseMilestones(tp);
    CaseMethods.fireCaseAssignmentRule(tp);
  }
}