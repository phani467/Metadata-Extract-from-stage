//-----------------------------
// @author: Uttam Arya
// @date: 29th Aug 2017
// @param: TriggerParameters
// @description: SFDC1-2243 AfterInsert dispatcher Task handler class that calls the functions in TaskMethods.
// @return: NA
//-----------------------------
public class TaskAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    TaskMethods.populateTaskAddedInOpportunityWhenTaskIsInserted(tp);
  }

}