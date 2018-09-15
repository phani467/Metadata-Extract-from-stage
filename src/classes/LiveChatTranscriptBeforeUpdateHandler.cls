//***********************************************
// @author Uttam Arya
// @date 13 Nov 2017
// @description SFDC1-5540 Trigger Event handler for LiveChatTranscript Trigger
//***********************************************
public class LiveChatTranscriptBeforeUpdateHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		LiveChatTranscriptMethods.removeTimeStampFromTranscriptBody(tp);
        LiveChatTranscriptMethods.populateCaseNumberInLivechatTranscritp(tp);
	}
}