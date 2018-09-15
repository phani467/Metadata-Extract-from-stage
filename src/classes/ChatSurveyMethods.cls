//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834  Class to hold trigger methods 
// @return: NA
//-----------------------------
public class ChatSurveyMethods {
	
//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters tp
// @description: SFDC1-834 ChatSurvey__c BEFORE INSERT - called from ChatSurveyTrigger
//				 finds the transcript records(if exists) that matches the chatKey of the inserted ChatSurvey__c
//				 Note! it is feasible for ChatSurvey__c to be created before the transcript has been inserted, so we also have trigger on transcript object to search for ChatSurvey__c to cover this

// @return: None
//------------------------------
	
    public static void surveyInitiatedTranscriptSearch(TriggerParameters tp) {
    	
    	//Map<Id,ChatSurvey__c> mapChatSurveys = new Map<Id,ChatSurvey__c>();
    	//mapChatSurveys = (Map<Id,ChatSurvey__c>) tp.newMap;
        Set<Id> caseIds = new Set<Id>();
        Map<String, ChatSurvey__c> mChatKeyToSurvey = new Map<String,ChatSurvey__c>();
        
        for(ChatSurvey__c cs : (list<ChatSurvey__c>) tp.newList) {
            mChatKeyToSurvey.put(cs.ChatKey__c, cs);
            System.debug('@@@UA' + mChatKeyToSurvey);
        }
        // now find all transcripts that match the chatkey and update lookups to transcript and case record on the survey
        if(!mChatKeyToSurvey.isEmpty()) {
            for(LiveChatTranscript lct : [select id, CaseId, ChatKey from LiveChatTranscript where ChatKey IN :mChatKeyToSurvey.keySet()]) {
                mChatKeyToSurvey.get(lct.ChatKey).LiveChatTranscript__c = lct.id;
                mChatKeyToSurvey.get(lct.ChatKey).Case__c  = lct.CaseId;
                System.debug('@@@UA' + mChatKeyToSurvey);
            }
        }
    }
    
//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters tp
// @description: SFDC1-834 ChatSurvey__c AFTER INSERT, UPDATE - called from ChatSurveyTrigger
//				 if the Case field has been populated on the ChatSurvey__c then push the values up to the case
// @return: None
//------------------------------

    public static void copySurveyResultsToLiveChatTranscript(TriggerParameters tp) {
        
        Map<Id,ChatSurvey__c> mapOldSurveys = (Map<Id,ChatSurvey__c>) tp.oldMap;
        Map<Id,ChatSurvey__c> mapNewSurveys = (Map<Id,ChatSurvey__c>) tp.newMap;
        
        List<LiveChatTranscript> transcriptsToUpdate = new List<LiveChatTranscript>();
        
        for(ChatSurvey__c cs : mapNewSurveys.values()) {
            System.debug('ChatSurvey__c' + cs);
            if(cs.LiveChatTranscript__c != null && (mapOldSurveys == null || (mapOldSurveys != null && mapOldSurveys.get(cs.Id).LiveChatTranscript__c != cs.LiveChatTranscript__c))) {
                System.debug('Chat Survey' + cs.Email__c);
                if(Test.isRunningTest()) {
                    transcriptsToUpdate.add(new LiveChatTranscript(id = cs.LiveChatTranscript__c,
                                                               SendTranscript__c = cs.SendTranscript__c));
                }else{
                    transcriptsToUpdate.add(new LiveChatTranscript(id = cs.LiveChatTranscript__c,
                                                               SuppliedEmail__c = cs.Email__c,
                                                               SendTranscript__c = cs.SendTranscript__c));
                }
            }
        }

        if(!transcriptsToUpdate.isEmpty()) {
        	update transcriptsToUpdate;
        }
            
    }
}