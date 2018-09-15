//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description Re-structuring the trigger methods by using Trigger Handler framework. Org assessment 2016.
//***************************************
public class ContactBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        ContactMethods.updateCountryLookup(tp);
    }
    
    //@Uttam Arya
    //Inprogress entry. Uncomment if being used. 
    /*public override void inProgressEntry(TriggerParameters tp) {
        System.debug('reentrant code...');
    }*/

}