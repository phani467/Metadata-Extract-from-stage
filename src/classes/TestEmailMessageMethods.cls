//-------------------------------------
//@author: Sruti Srivastava
//@date: 25 June 2018
//@description: Test class to test EmailMessageMethods
//@companyname: VERTIBA
//-------------------------------------

@isTest
private class TestEmailMessageMethods {

    //-------------------------------------
    //@author: Sruti Srivastava
    //@date: 25 June 2018
    //@description: Test class to test EmailMessageMethods
    //@param: NA
    //@return: void
    ////-------------------------------------
    testmethod static void testReexecuteCaseAssignmentRulesAndCaseStatusUpdate() {
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        ProductGroup__c testProductgroup = TestUtility.createProductGroup('FieldDirect', true, false);
        Group queue = [Select id, name from group where type = 'Queue' and developerName = 'FMMSERV' limit 1];
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        Case cas1 = TestUtility.createCase(caseRecordTypeId, testAccount.Id, testContact.Id, 
                                           UserInfo.getUserId(), 'Case1', false);
        cas1.ProductGroup__c = testProductgroup.id;
        cas1.SkillLevel__c = '2 - Technical';
        cas1.Status = 'Waiting - Customer';
        cas1.PreviousQueue__c = queue.Name;
        Case cas2 = TestUtility.createCase(caseRecordTypeId, testAccount.Id, testContact.Id, 
                                           UserInfo.getUserId(), 'Case2', false);
        cas2.ProductGroup__c = testProductgroup.id;
        cas2.SkillLevel__c = '1 - General';
        cas2.Status='Closed - Canceled';
        cas2.ClosedReason__c = 'No Action Required';
        cas2.ResolutionDescription__c = 'test';
        cas2.PreviousQueue__c = queue.Name;
        
        Case cas3 = TestUtility.createCase(caseRecordTypeId, testAccount.Id, testContact.Id, 
                                           UserInfo.getUserId(), 'Case3', false);
        cas3.ProductGroup__c = testProductgroup.id;
        cas3.SkillLevel__c = '1 - General';
        cas3.Status='Closed - Canceled';
        cas3.ClosedReason__c = 'No Action Required';
        cas3.ResolutionDescription__c = 'test';
        
        List<case> caseList = new List<Case>();
        caseList.add(cas1);
        caseList.add(cas2);
        caseList.add(cas3);
        insert caseList;
        
		List<EmailMessage> listEmails = new List<EmailMessage>();
		listEmails.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'test@xyz.org', 
										Subject = 'Test email', HtmlBody = 'Test email body', ParentId = cas2.Id));
        listEmails.add(new EmailMessage(FromAddress = 'test@abc1.org', Incoming = True, ToAddress= 'test@xyz.org', 
										Subject = 'Test email', HtmlBody = 'Test email body', ParentId = cas1.Id));
        listEmails.add(new EmailMessage(FromAddress = 'test@abc2.org', Incoming = True, ToAddress= 'test@xyz.org', 
										Subject = 'Test email', HtmlBody = 'Test email body', ParentId = cas3.Id));
        Test.startTest();
        insert listEmails;
        Test.stopTest();
        
        //Verifying if status on cases have been updated 
        Map<Id,Case> updatedListCase = new Map<Id, case>([select id, ownerId, status, PreviousQueue__c from Case where status like 'In Progress' or status like 'Re-opened']);
        System.assertEquals(updatedListCase.size(), 3);
        Case testCase = updatedListCase.get(cas1.id); // Status should be inProgress
        System.assertEquals(testCase.Status, 'In Progress');
        System.assertEquals(testCase.ownerId, UserInfo.getUserId());//User shouldnt be changed
        
        //verifying if Case owner is updated as expected
        testCase = updatedListCase.get(cas3.id); // Status should be Reopened
        System.assertEquals(testCase.Status, 'Re-opened');
        System.assertNotEquals(testCase.ownerId.getsobjecttype(), User.sobjecttype);//Should not be user
        //In case this queue is used in settings as default queue in Case settings then below condition will fail.
        //So, commenting it out.
        //System.assertNotEquals(testCase.ownerId.getsobjecttype(), queue.Id);
        
        testCase = updatedListCase.get(cas2.id); // Status should be Reopened
        System.assertEquals(testCase.Status, 'Re-opened');
        System.assertEquals(testCase.ownerId, queue.Id);//Owner should be previous owner queue
	}  
}