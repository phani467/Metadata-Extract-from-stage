//***************************************
// @author Tran-Vu Tran
// @date 24th April 2018
// @description SFDC1-405 Implementation of Trigger framework.
//***************************************

public class UserBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        UserMethods.updateUserRegionWhenAddressCountryChanges(tp);
    }
}