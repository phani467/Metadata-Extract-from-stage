//***************************************
// @author Uttam Arya
// @date 6th Feb 2017
// @description Re-structuring the trigger methods by using Trigger Handler framework. Org assessment 2016.
//***************************************

public class ContactAfterUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
       // ContactMethods.updateCountryLookup(tp);
        ContactMethods.changeAdditionalContactFieldsObjectNameWhenContactFieldChanges(tp);
    }
}