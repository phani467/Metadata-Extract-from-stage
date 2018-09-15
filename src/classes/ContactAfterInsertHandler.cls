//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description Re-structuring the trigger methods by using Trigger Handler framework. Org assessment 2016.   
//***************************************
public class ContactAfterInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        // ContactMethods.updateCountryLookup(tp);
        ContactMethods.setAdditionalContactFieldsObject(tp);
    }
    
}