//-----------------------------
// @author: Mohit Modi
// @date: 17 Jan 2018
// @param: TriggerParameters
// @description: SFDC1-5027 AfterDelete dispatcher Task handler class that calls the functions in TaskMethods.
// @return: NA
//-----------------------------
public class TaskAfterDeleteHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    TaskMethods.updateOpportunityActivityCheckOnTaskDeletion(tp);
  }

}