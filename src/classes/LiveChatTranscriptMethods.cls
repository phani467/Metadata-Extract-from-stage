//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834 Class to hold trigger methods 
// @return: NA
//-----------------------------
public class LiveChatTranscriptMethods {	
    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-834 LiveChatTranscript AFTER INSERT - called from LiveChatTranscriptTrigger
    // 					finds any Chat Surveys with matching chatkey and if found, populates Transcript lookup and Case Lookup on that record
    // 					Note! it is feasible for Transcript to be created before the ChatSurvey__c has been inserted, so we also have trigger on ChatSurvey__c object to search for Transcripts to cover this
    // @return: None
    //------------------------------
    
    public static void transcriptInitiatedSurveySearch(TriggerParameters tp) {
        
        Map<Id,LiveChatTranscript> mapLiveChatTranscript = (Map<Id,LiveChatTranscript>) tp.newMap;
        Map<String, LiveChatTranscript> mChatKeyToTranscript = new Map<String,LiveChatTranscript>();
        List<ChatSurvey__c> surveysToUpdate = new List<ChatSurvey__c>();
        
        for(LiveChatTranscript lct : mapLiveChatTranscript.values()) {
            mChatKeyToTranscript.put(lct.ChatKey, lct);
        }
        if(!mChatKeyToTranscript.isEmpty()) {
            for(ChatSurvey__c cs : [select id, ChatKey__c, LiveChatTranscript__c, Case__c from ChatSurvey__c where ChatKey__c in :mChatKeyToTranscript.keySet()]) {
                cs.Case__c = mChatKeyToTranscript.get(cs.ChatKey__c).CaseId;
                cs.LiveChatTranscript__c = mChatKeyToTranscript.get(cs.ChatKey__c).Id;
                surveysToUpdate.add(cs);
            }
        }
        if(!surveysToUpdate.isEmpty()) {
            update surveysToUpdate;
        }
        
    }
    
    //----------------------------- 
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-834 LiveChatTranscript BEFORE INSERT - called from LiveChatTranscriptTrigger
    // 					Remove TimeStamp From Transcript Body. Salesorce add TimeStamp to the Transcript Body and we do not want to send the timestamp to customer so we need to make a copy of transcript body
    // @return: None
    //------------------------------
    
    public static void removeTimeStampFromTranscriptBody(TriggerParameters tp) {
        
        for(LiveChatTranscript  lct : (list<LiveChatTranscript>) tp.newList) {
            if(lct.body != null && lct.Status == 'Completed') {
                if(lct.body.indexOf('</p>(') != -1){
                    String newBody = lct.body.substring(lct.body.indexOf('</p>(') + 4);
                    System.debug(lct.body__c);
                    Pattern transcriptpattern = Pattern.compile('\\(.([0-9]*h)?.([0-9]*m)?.([0-9]*s)*.\\).');
                    lct.body__c = transcriptpattern.matcher(newBody).replaceAll('');
                }
            }
        }
    }
    
    //----------------------------- 
    // @author: Uttam Arya
    // @date: 13 Nov 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-5504 LiveChatTranscript After Update - called from LiveChatTranscriptTrigger
    // The case that is auto generated when accepting the chat, Case owner is set to Automated Process instead of agent who took the chat. Assigning is back to the user who took the chat					
    // @return: None
    //------------------------------
    
    public static void assignCasetoTranscritpUser(TriggerParameters tp) {
        
        Map<Id,Id> mapCaseIdOwnerId = new Map<Id,Id>(); // map of case ids to LiveChatTranscript owner ids
        List<Case> casesToUpdate = new List<Case>();
        
        for(LiveChatTranscript  lct : (list<LiveChatTranscript>) tp.newList) {
            if(lct.CaseId  != null) {
                mapCaseIdOwnerId.put(lct.CaseId, lct.OwnerId);
            }
        }
        
        if(!mapCaseIdOwnerId.isEmpty()) { 
            
            //Using hardcoded id for Automated Process user, since Live Agent Site user do not have access to User object 
            for(Case c : [select id, ownerid from Case where Id IN :mapCaseIdOwnerId.keySet() and ownerid =  '0050P000006dHLJQA2']) {
                // update the case owner to be the same as the transcript owner, only if the case owner is currently user Automated Process          
                c.OwnerId = mapCaseIdOwnerId.get(c.id);
                casesToUpdate.add(c);
                System.debug('@@@UA' + c);
            }
        }
        if(!casesToUpdate.isEmpty()) {
             update casesToUpdate;
        }       
    }
    
    //----------------------------- 
    // @author: Uttam Arya
    // @date: 15 Feb 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7005 LiveChatTranscript before Update - called from LiveChatTranscriptTrigger
    // The case that is auto generated when accepting the chat, Case Number is not visible in Live Chat Transcript. Case Number is set here once the caseid is populated					
    // @return: None
    //------------------------------
    
    public static void populateCaseNumberInLivechatTranscritp(TriggerParameters tp) {
        
        Map<Id,Id> mapTranscriptCaseId = new Map<Id,Id>(); // map of LiveChatTranscript ids to case ids
        
        for(LiveChatTranscript  lct : (list<LiveChatTranscript>) tp.newList) {
            if(lct.CaseId  != null) {
                mapTranscriptCaseId.put(lct.Id, lct.CaseId);
            }
        }
        
        if(!mapTranscriptCaseId.isEmpty()) { 
            
            Map<Id,Case> caseMap = new Map<Id,Case>([select Id, CaseNumber from Case where Id IN :mapTranscriptCaseId.values()]);
            
            for(LiveChatTranscript  lct : (list<LiveChatTranscript>) tp.newList) {
                if(lct.CaseId  != null && caseMap.get(lct.CaseId) != null) {
                    lct.CaseNumber__c = caseMap.get(lct.CaseId).CaseNumber;
                }
            }
        }     
    }
}