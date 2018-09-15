//***********************************************
// @author Uttam Arya
// @date 22nd July 2017
// @description SFDC1-834 Trigger Event handler for Chat Survey Trigger
//***********************************************
public class ChatSurveyAfterInsertHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		ChatSurveyMethods.copySurveyResultsToLiveChatTranscript(tp);
	}
}