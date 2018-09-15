//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description SFDC1-405 Implementation of Trigger framework.
// @edits: 24th Aug 2017 SFDC1-2103 Uttam Arya, Adding a call to function to set Account Additional Fields Object (setAccountAdditionalFieldsObject)
//
// @modified by: Harshit Singhal
// @date: 07 Jun 2018
// @description: SFDC1-8537 Added updateAccountCreatedOnParentCase() method to convert Process Builder flow "Populate Parent Case On Account Creation" created in SFDC1-965(To populate the parent case on account creation from Case) to a trigger.
// 
//***************************************
public class AccountAfterInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
       // AccountMethods.updateAccountCountry(tp);
        AccountMethods.updateLegacyIdObject(tp);
        AccountMethods.updateAccountTeamMemberRole(tp);
        AccountMethods.setAccountAdditionalFieldsObject(tp);
        AccountMethods.updateAccountCreatedOnParentCase(tp);
    }
}