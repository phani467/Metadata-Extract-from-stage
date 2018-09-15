//-----------------------------
// @author: Sonam Raju
// @date: 8 Mar 2018
// @param: TriggerParameters
// @description: SFDC1-6937 AfterInsert dispatcher event handler class that calls the functions in AdditionalOpportunityFieldsMethods.
//                          Function is named as AdditionalOpptyFieldsAfterInsertHandler instead of AdditionalOpportunityFieldsAfterInsertHandler 
//                          Due to character limit on class name
// @return: NA
//-----------------------------
public class AdditionalOpptyFieldsAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    AdditionalOpportunityFieldsMethods.populateAdditionalFieldsLookupInOpportunity(tp);
  }
}