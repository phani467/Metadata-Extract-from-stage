//-----------------------------
// @author: Uttam Arya
// @date: 22nd Aug 2017
// @param: TriggerParameters
// @description: SFDC1-2103 AfterInsert dispatcher event handler class that calls the functions in AdditionalAccountFieldsMethods.
//                          Function is named as AdditionalAccFieldsAfterInsertHandler instaed of AdditionalAccountFieldsAfterInsertHandler 
//                          Due to character limit on class name
// @return: NA
//-----------------------------
public class AdditionalAccFieldsAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    AdditionalAccountFieldsMethods.populateAdditionalFiledsLookupInAccount(tp);
  }

}