//***************************************
// @author Uttam Arya
// @date 13th April 2018
// @description SFDC1-405 Implementation of Trigger framework.
//***************************************

public class ProductLoginAfterUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        ProductLoginMethods.changeProductLoginAdditionalFieldsObjectNameWhenUsernameChanges(tp);
        ProductLoginMethods.insertPLContactAssociationWhenEmailChanges(tp); 
    }
}