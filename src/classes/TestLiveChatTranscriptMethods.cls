//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for Live Chat Transcript methods 
// @return: NA
//-----------------------------
@isTest
public with sharing class TestLiveChatTranscriptMethods {
	//-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: SFDC1-834 Check that if ChatSurvey__c is already created then upon transcript insert with matching
    //				 chatkey the transcript lookup field on ChatSurvey__c is populated
    // @return: NA
    //-----------------------------

    static testMethod void testInsert() {
        
        Account a = TestUtility.createTestAccount('Account Live Chat Transcript', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        //Assuming NRG recordtype exist in system
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRG;
        
        Case testCase = new Case();
        testCase.subject = 'Test subject Live Chat Test';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        testCase.ProductGroup__c = pg.Id;
        testCase.ownerid =  '0050P000006dHLJQA2'; //System Processor Id
        insert testCase;

        
        String ck = 'TEST123';
        ChatSurvey__c cs = new ChatSurvey__c(ChatKey__c = ck, Email__c = 'test@diablo1983.com');
        insert cs;
        
        LiveChatVisitor v = new LiveChatVisitor();
        insert v;
        
        Test.startTest();
        
        String body = '<p align="center">Chat Started: Tuesday, July 25, 2017, 01:44:14 (+0530)</p><p align="center">Chat Origin: IHSMarkitSupportMCS</p><p align="center">Agent Uttam A</p>( 2s ) Uttam A: Hello Uttam Arya, welcome to IHS Markit live chat support, my name is Uttam how can I help you today?<br>';
        
        LiveChatTranscript t = new LiveChatTranscript(ChatKey = ck, LiveChatVisitorId = v.Id, body = body);
        insert t;
        
        t.CaseId = testCase.Id;
        t.Status = 'Completed';
        
        update t;
        
        cs = [select id, LiveChatTranscript__c from ChatSurvey__c where Id = :cs.Id];
        System.assertEquals(t.Id, cs.LiveChatTranscript__c);
        
        Test.stopTest();
    }
    
}