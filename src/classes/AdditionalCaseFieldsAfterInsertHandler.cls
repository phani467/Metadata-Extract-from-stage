//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in AdditionalCaseFieldsMethods.
// @return: NA
//-----------------------------
public class AdditionalCaseFieldsAfterInsertHandler extends TriggerHandlerBase{
    
  public override void mainEntry(TriggerParameters tp) {
    AdditionalCaseFieldsMethods.populateAdditionalFiledsLookupInCase(tp);
  }
}