//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for Additional Case Fields trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestAdditionalCaseFieldsMethods {

    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: Test method for Additional Case Fields trigger methods populateAdditionalFiledsLookupInCase on insert
    // @return: NA
    //-----------------------------
	private static testMethod void testpopulateAdditionalFiledsLookupInCase() {
	    
	    Account a = TestUtility.createTestAccount('Account testpopulateAdditionalFiledsLookupInCase', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testpopulateAdditionalFiledsLookupInCase';
        c.AccountId = a.Id;
        
        //Assuming NRG recordtype exist in system
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        Case testCase = new Case();
        testCase.subject = 'Test subject testpopulateAdditionalFiledsLookupInCase';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        insert testCase;
        
        AdditionalCaseFields__c acf = new AdditionalCaseFields__c();
        acf.Case__c = testCase.Id;
        insert acf;
        
        list <Case> testCaseResult = [Select AdditionalFields__c, Id from case where Id = :testCase.Id];
         System.assertEquals(1, testCaseResult.size());
        System.assertEquals(acf.Id, testCaseResult[0].AdditionalFields__c);

	}
    //-----------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 19 June 2018
    // @description: This method tests that case is assigned to queue mentioned in Delivery Queue field 
    // 				of Delivery Case record type.
    // @companyname: VERTIBA 
    //----------------------------- 
    @isTest
    private static void testDeliveryCaseOwnerAssignment() {
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Id deliveryRecordTypeId = Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName().
        								get('Delivery').getRecordTypeId();
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        ProductGroup__c testProductgroup = TestUtility.createProductGroup('Delivery', true, false);
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingDelivery = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingDelivery.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingDelivery.AdditionalCaseRecordType__c = 'Delivery';
        aCaseTypeLinkingDelivery.ProductGroup__c = testProductgroup.Id;
        insert aCaseTypeLinkingDelivery;
        
        System.debug('aCaseTypeLinkingDelivery:' + aCaseTypeLinkingDelivery);
        
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.ProductGroup__c = testProductgroup.id;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;
        
        Map<String,Id> queueIdMap = new map<String,Id>();
        for(Group queue : [Select Name, Id From Group where Type = 'Queue'
                                      and name in ('Erights', 'Online Delivery')]) {
            queueIdMap.put(queue.Name, queue.id);
        }

        Test.startTest();
        testCase = [Select id, OwnerId, AdditionalFields__c from case where id =: testCase.Id];
        //updating delivery queue field to Erights. Case owner should be changed to Erights. 
        AdditionalCaseFields__c acf = new AdditionalCaseFields__c(id=testCase.AdditionalFields__c);
        acf.DeliveryQueue__c='Erights';
        update acf;
        
        testCase = [Select id, OwnerId, AdditionalFields__c from case where id =: testCase.Id];
        System.assertEquals(queueIdMap.get(acf.DeliveryQueue__c), testCase.OwnerId);
        Test.stopTest();
    }
}