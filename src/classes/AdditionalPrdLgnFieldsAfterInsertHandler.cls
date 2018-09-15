//-----------------------------
// @author: Uttam Arya
// @date: 13 April 2018
// @param: TriggerParameters
// @description: SFDC1-6347 AfterInsert dispatcher event handler class that calls the functions in AdditionalProductLoginFieldsMethods.
//                          Function is named as AdditionalUsrAccFiledsAfterInsertHandler instaed of AdditionalProductLoginFieldsAfterInsertHandler 
//                          Due to character limit on class name
// @return: NA
//-----------------------------
public class AdditionalPrdLgnFieldsAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    AdditionalProductLoginFieldsMethods.populateAdditionalFiledsLookupInProductLogin(tp);
  }
}