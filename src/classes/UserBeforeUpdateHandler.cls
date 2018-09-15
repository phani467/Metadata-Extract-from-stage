//***************************************
// @author Tran-Vu Tran
// @date 24th April 2018
// @description SFDC1-405 Implementation of Trigger framework.
//***************************************

public class UserBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        UserMethods.updateUserRegionWhenAddressCountryChanges(tp);
    }

}