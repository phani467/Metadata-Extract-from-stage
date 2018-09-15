//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description SFDC1-405 Implementation of Trigger framework.
// @edits: 24th Aug 2017 SFDC1-2103 Uttam Arya, Adding a call to function to delete Account Additional Fields Record when account gets deleted (deleteAccountAdditionalFieldsRecordWhenAccountGetsDeleted)
//***************************************
public class AccountBeforeDeleteHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
		AccountMethods.deleteAccountAdditionalFieldsRecordWhenAccountGetsDeleted(tp);
	}
}