//-----------------------------
// @author: Tran-Vu Tran
// @date: 25 Sep 2017
// @param: TriggerParameters
// @description: SFDC1-2299 AfterInsert dispatcher event handler class that calls the functions in AdditionalContactFieldsMethods.
// Function is named as AdditionalContFieldsAfterInsertHandler instead of AdditionalContactFieldsAfterInsertHandler due to character limit on class name
// @return: NA
//-----------------------------
public class AdditionalContFieldsAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
      AdditionalContactFieldsMethods.populateAdditionalContactFieldsLookupInContact(tp);
  }

}