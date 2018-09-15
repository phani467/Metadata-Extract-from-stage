//-----------------------------
// @author: Uttam Arya
// @date: 29th Aug 2017
// @param: TriggerParameters
// @description: SFDC1-2243 AfterInsert dispatcher event handler class that calls the functions in EventMethods.
// @return: NA
//-----------------------------
public class EventAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    EventMethods.populateEventAddedInOpportunityWhenEventIsInserted(tp);
  }

}