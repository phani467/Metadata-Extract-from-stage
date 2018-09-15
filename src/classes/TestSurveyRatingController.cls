//-----------------------------
// @author: Ankita Singh
// @date: 20 Feb 2018
// @param: NA
// @description: Test class for SurveyRatingController 
// @return: NA
//-----------------------------
@isTest
public class TestSurveyRatingController {
    //-----------------------------
    // @author: Ankita Singh
    // @date: 20 Feb 2018
    // @param: NA
    // @description: Test method for SurveyRatingController WITH CE Score 
    // @return: NA
    //-----------------------------
    
   private static testMethod void testCEScore() {
       Account testAccount = TestUtility.createTestAccount('testAccount', true);
       Contact testContact1 = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        false, 'Test1', 'Contact1');
       Contact testContact2 = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        false, 'Test2', 'Contact2');
       List<Contact> conList = new List<Contact>();
       conList.add(testContact2);
       conList.add(testContact1);
       insert conList;
       
       Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
       List<case> caseList = new List<case>();
       Case testCase = new Case();
       testCase.RecordTypeId = caseRecordTypeId;
       testCase.subject = 'Test subject CE SCORE';
       testCase.AccountId = testAccount.Id;
       testCase.contactId = testContact1.Id;
       caseList.add(testCase);
       
       Case testCase2 = new Case();
       testCase2.RecordTypeId = caseRecordTypeId;
       testCase2.subject = 'Test subject CE SCORE INC';
       testCase2.AccountId = testAccount.Id;
       testCase2.contactId = testContact1.Id;
       testCase2.OIDTicket__c ='INC1234567';
       caseList.add(testCase2);
       
       insert caseList;
       
       List<SurveyResponse__c> srList = new List<SurveyResponse__c>();
       SurveyResponse__c sr1 = new SurveyResponse__c();
       sr1.SurveyType__c = 'Customer Care';
       sr1.ResponseDate__c= System.today();
       sr1.Account__c = testAccount.id;
       sr1.Contact__c = testContact1.id;
       sr1.CESScore__c= 2;
       
       SurveyResponse__c sr2 = new SurveyResponse__c();
       sr2.SurveyType__c = 'Customer Care';
       sr2.ResponseDate__c= System.today();
       sr2.Account__c = testAccount.id;
       sr2.Contact__c = testContact2.id;
       sr2.CESScore__c =6;
       srList.add(sr1);
       srList.add(sr2);
       insert srList;
       
       SurveyResponse__c sr3 = SurveyRatingController.getContactScore(testCase.id);
       System.assertEquals(sr3.CESScore__c,sr1.CESScore__c);
       SurveyRatingController.AccountScoreWrapper ces = SurveyRatingController.getAccountScore(testCase.Id); 
       System.assertEquals(4,ces.avgscore);
       Case c = SurveyRatingController.getLastIncidentTicket(testCase.Id); 
       System.assertEquals('INC1234567',c.OIDTicket__c);
   }
   
   //-----------------------------
    // @author: Ankita Singh
    // @date: 20 Feb 2018
    // @param: NA
    // @description: Test method for SurveyRatingController Without CE Score
    // @return: NA
    //-----------------------------
   private static testMethod void testCEScoreWithNullScore() {
       Account testAccount = TestUtility.createTestAccount('testAccount', true);
       Contact testContact1 = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test1', 'Contact1');
       
       Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
       Case testCase = new Case();
       testCase.RecordTypeId = caseRecordTypeId;
       testCase.subject = 'Test subject CE SCORE';
       testCase.AccountId = testAccount.Id;
       testCase.contactId = testContact1.Id;
       insert testCase;
       
       SurveyResponse__c sr3 = SurveyRatingController.getContactScore(testCase.id);
       System.assertEquals(null,sr3);
       SurveyRatingController.AccountScoreWrapper ces = SurveyRatingController.getAccountScore(testCase.Id);
       System.assertEquals(0.0,ces.avgscore);
		
       
   }
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 26 Feb 2018
    // @param: NA
    // @description: Test method for SurveyRatingController Without Account
    // @return: NA
    //-----------------------------
   private static testMethod void testCEScoreWithNullAccount() {
       
       Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
       Case testCase = new Case();
       testCase.RecordTypeId = caseRecordTypeId;
       testCase.subject = 'Test subject CE SCORE';
      // testCase.contactId = testContact1.Id;
       insert testCase;
       
       SurveyResponse__c sr3 = SurveyRatingController.getContactScore(testCase.id);
       System.assertEquals(null,sr3);
       SurveyRatingController.AccountScoreWrapper ces = SurveyRatingController.getAccountScore(testCase.Id);
       System.assertEquals(0.0,ces.avgscore);
       Case c = SurveyRatingController.getLastIncidentTicket(testCase.Id);
       System.assertEquals(null,c);
		
       
   }
    
       //-----------------------------
    // @author: Ankita Singh
    // @date: 28 Feb 2018
    // @param: NA
    // @description: Test method for SurveyRatingController Without INC Ticket
    // @return: NA
    //-----------------------------
   private static testMethod void testCEScoreWithNullTicket() {
       Account testAccount = TestUtility.createTestAccount('testAccount', true);
       Contact testContact1 = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test1', 'Contact1');
       
	   Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
       List<case> caseList = new List<case>();
       Case testCase = new Case();
       testCase.RecordTypeId = caseRecordTypeId;
       testCase.subject = 'Test subject CE SCORE';
       testCase.AccountId = testAccount.Id;
       testCase.contactId = testContact1.Id;
       caseList.add(testCase);
       
       Case testCase2 = new Case();
       testCase2.RecordTypeId = caseRecordTypeId;
       testCase2.subject = 'Test subject CE SCORE INC';
       testCase2.AccountId = testAccount.Id;
       testCase2.contactId = testContact1.Id;
       caseList.add(testCase2);
       
       insert caseList;
       
       Case c = SurveyRatingController.getLastIncidentTicket(testCase.Id);
       System.assertEquals(null,c);
		
       
   }
}