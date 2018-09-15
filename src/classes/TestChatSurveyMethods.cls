//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for Chat Survey methods 
// @return: NA
//-----------------------------
@isTest
public with sharing class TestChatSurveyMethods {
	//-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: SFDC1-834 check that if LiveChatTranscript is already created then upon ChatSurvey__c insert with matching
    // 				chatkey the transcript lookup field on ChatSurvey__c is populated
    // 				ALSO ENSURE that ratings are copied to associated Case
    // @return: NA
    //-----------------------------
    static testMethod void testInsert() {
        String ck = 'test01072016';     
        Case c = new Case(SuppliedEmail = 'test01072016@markit.com');
        insert c;
        
        LiveChatVisitor v = new LiveChatVisitor();
        insert v;
        
        String body = 'Hello, Test Chat';

        
        LiveChatTranscript t = new LiveChatTranscript(ChatKey = ck, LiveChatVisitorId = v.Id, CaseId = c.Id, body = body);
        insert t;
        
        ChatSurvey__c cs = new ChatSurvey__c(ChatKey__c = ck,
                                                    Email__c = 'test01072016@markit.com',
                                                    SendTranscript__c = true);
        insert cs;
        
        cs = [select id, LiveChatTranscript__c from ChatSurvey__c where Id = :cs.Id];
        System.assertEquals(t.Id, cs.LiveChatTranscript__c);
    }
    
    static testMethod void testUpdate() {
        String ck = 'test01072016';     
        Case c = new Case(SuppliedEmail = 'test01072016@markit.com');
        insert c;
        
        LiveChatVisitor v = new LiveChatVisitor();
        insert v;
        
        String body = 'Hello, Test Chat';
        
        ChatSurvey__c cs = new ChatSurvey__c(ChatKey__c = ck,
                                                    Email__c = 'test01072016@markit.com',
                                                    SendTranscript__c = true);
        insert cs;
        
        LiveChatTranscript t = new LiveChatTranscript(ChatKey = ck, LiveChatVisitorId = v.Id, CaseId = c.Id, body = body);
        insert t;

        cs = [select id, LiveChatTranscript__c from ChatSurvey__c where Id = :cs.Id];
        System.assertEquals(t.Id, cs.LiveChatTranscript__c);
    }
}