//***********************************************
// @author Uttam Arya
// @date 22nd July 2017
// @description SFDC1-834 Trigger Event handler for LiveChatTranscript Trigger
//***********************************************
public class LiveChatTranscriptBeforeInsertHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		LiveChatTranscriptMethods.removeTimeStampFromTranscriptBody(tp);
	}
}