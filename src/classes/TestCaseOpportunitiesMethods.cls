/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 29 August 2017
* @description: Class to test CaseOpportunitiesMethods.
* @companyname: VERTIBA
* @Last Modified By : Vinod Merwade
* @Last Modified Description : Corrected the Test class according to new validation rules on Opportunity
* @Last Modified Date : 19 Sept 2017
* @Last Modified By : Hemant Shukla
* @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
* @Last Modified Date : 6-Nov-2017
*/
@isTest
private class TestCaseOpportunitiesMethods {

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 29 August 2017
     * @description: This method tests the CaseOpportunitiesMethods by creating/updating/deleting Case opportunity objects.
     * @companyname: VERTIBA 
     * @lastmodifiedSprint : Sprint 9
     * @lastmodifiedBy : Prachi for SFDC1-1154 validation rule
     * @Last Modified Date : 23-Nov-2017
     * @lastmodifiedBy : Vishnu 
     * @Last Modified Description : fixing the errors in bitbucket
     * @lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
     * @modifiedBy: Ankita Singh on 5th December,2017
     */ 
    @isTest
    private static void testUpdateRollupSummariesInCase() {
        //create test data
        List<Product2> prodList = new List<Product2>();
        prodList.add(TestUtility.createProduct('Test Product', false));
        prodList.add(TestUtility.createProduct('Product Test', false));
        insert prodList;
        Id standardId = Test.getStandardPricebookId();
        List<PriceBookEntry> priceBEList = new List<PriceBookEntry>();
        priceBEList.add(TestUtility.createPriceBookEntry(standardId, prodList.get(0).Id, false));
        priceBEList.add(TestUtility.createPriceBookEntry(standardId, prodList.get(1).Id, false));
        insert(priceBEList);
        
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');

        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        Country__c country = (Country__c)TestUtility.loadCountryData().get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
       	List<Opportunity> oppList = new List<Opportunity>();
        List<OpportunityLineItem> oppLIList = new List<OpportunityLineItem>();
        
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id, 'Closed Opp', false);
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'Open Opp 1', false);
       
        oppList.add(testOpportunity1);
        oppList.add(testOpportunity2);
        insert oppList;
        testOpportunity1 = oppList.get(0);
        testOpportunity2 = oppList.get(1);
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity1.Id, priceBEList.get(0), false);
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(testOpportunity2.Id, priceBEList.get(1), false);
        OpportunityLineItem testOLI3 = TestUtility.createOpportunityLineItem(testOpportunity2.Id, priceBEList.get(0), false);
        oppLIList.add(testOLI1);
        oppLIList.add(testOLI2);
        oppLIList.add(testOLI3);
        insert oppLIList;
        
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.ContactId = testContact.Id;
        ocr1.OpportunityId = testOpportunity1.Id;
        ocr1.IsPrimary = TRUE;
        ocr1.Role = 'Decision Maker';
        
        OpportunityContactRole ocr2 = new OpportunityContactRole();
        ocr2.ContactId = testContact.Id;
        ocr2.OpportunityId = testOpportunity2.Id;
        ocr2.IsPrimary = TRUE;
        ocr2.Role = 'Decision Maker';
        ocrList.add(ocr1);
        ocrList.add(ocr2);
        insert ocrList;
        
        Test.startTest();
        testOpportunity2.StageName = '5-Contracting';
        testOpportunity2.ContractId = contract1.id;
        testOpportunity2.ContractStartDate__c = System.today();
        testOpportunity2.ContractEndDate__c = System.today();
        testOpportunity2.ActivityCreated__c = true;
        testOpportunity2.ReadyForProcessingContractExist__c  = true;
        testOpportunity1.StageName = '6W-Closed Won'; 
        testOpportunity1.ContractId = contract1.id;
        testOpportunity1.ContractStartDate__c = System.today();
        testOpportunity1.ContractEndDate__c = System.today();
        testOpportunity1.ActivityCreated__c = true;
        testOpportunity1.ReadyForProcessingContractExist__c  = true;
        oppList = new List<Opportunity>();
        oppList.add(testOpportunity1);
        oppList.add(testOpportunity2);
        update oppList;
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.subject = 'Test subject';
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;
        
        
        //Case Opportunity is not added so values should be empty
        Case case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.ExpectedRevenue__c+' case1 '+case1.OpportunityProductList__c); 
        System.assertEquals(null, case1.OpportunityProductList__c);
        System.assertEquals(null, case1.ExpectedRevenue__c);
        
        //Creating case opportunity, so case should be updated
        CaseOpportunities__c testCaseOpportunities1 = createCaseOpportunities(case1.id,testOpportunity1.id);
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.ExpectedRevenue__c+' case2 '+case1.OpportunityProductList__c); 
        System.assert(case1.OpportunityProductList__c.contains('Test Product'));
        System.assertEquals(50000, case1.ExpectedRevenue__c); 
        
        //Modifying opportunity with different opportunity
        testCaseOpportunities1.Opportunity__c = testOpportunity2.id;
        update testCaseOpportunities1;
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.ExpectedRevenue__c+' case3 '+case1.OpportunityProductList__c); 
        System.assert(case1.OpportunityProductList__c.contains('Product Test'));
        System.assertEquals(90000, case1.ExpectedRevenue__c);
        
        //Test by adding a new record to existing one.
        CaseOpportunities__c testCaseOpportunities2 = createCaseOpportunities(case1.id,testOpportunity1.id);
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.ExpectedRevenue__c+' case4 '+case1.OpportunityProductList__c); 
        System.assert(case1.OpportunityProductList__c.contains('Product Test'));
        System.assert(case1.OpportunityProductList__c.contains('Test Product')); 
        System.assertEquals(140000, case1.ExpectedRevenue__c);
        
        //Test by deleting record.
        delete testCaseOpportunities1;
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.ExpectedRevenue__c+' case5 '+case1.OpportunityProductList__c); 
        System.assert(case1.OpportunityProductList__c.contains('Test Product'));
        System.assertEquals(50000, case1.ExpectedRevenue__c);
        
        Test.stopTest();
    }

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 12 September 2017
     * @description: helper method to get case object from database.
     * @companyname: VERTIBA 
     */ 
    private static Case getCaseFromDatabase(Id caseId) {
        Case testCase = [Select id, OpportunityProductList__c, ExpectedRevenue__c from case where id =: caseId];
        return testCase;
    }

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 12 September 2017
     * @description: Helper method to insert case opportunities objects.
     * @companyname: VERTIBA 
     */ 
    private static CaseOpportunities__c createCaseOpportunities(id caseId, id opportunityId) {
        try {
            CaseOpportunities__c testCaseOpportunities = new CaseOpportunities__c();
            testCaseOpportunities.Case__c = caseId;
            testCaseOpportunities.Opportunity__c = opportunityId;
            insert testCaseOpportunities;
            return testCaseOpportunities;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseOpportunityDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
            return null;
        }
    }
    
    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 25 September 2017
     * @description: This method tests the ValidateIfCaseProductAlreadyExist by creating/updating Case opportunity objects.
     * @companyname: VERTIBA 
     * @lastmodifiedSprint : Sprint 9
     */ 
    @isTest
    private static void testValidateIfCaseProductAlreadyExist() {
        //create test data
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');

        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id, 'Closed Opp', true);
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'Open Opp 1', true);
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.subject = 'Test subject';
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;
        
        Test.startTest();
        //Creating case opportunity, record to be inserted successfully
        CaseOpportunities__c testCaseOpportunities1 = createCaseOpportunities(testCase.id,testOpportunity1.id);
        System.assertNotEquals(null,testCaseOpportunities1.id); 
        
        //Adding second case opportunity, record to be inserted successfully 
        CaseOpportunities__c testCaseOpportunities2 = createCaseOpportunities(testCase.id,testOpportunity2.id);
        System.assertNotEquals(null,testCaseOpportunities1.id); 
        
        //Add same case again, it should fail, Exception is caught and returned null.
        testCaseOpportunities1 = createCaseOpportunities(testCase.id,testOpportunity1.id);
        System.assertEquals(null,testCaseOpportunities1); 
        
        //Update 2 case opportunity with Opportunity 1. This should fail, Exception is caught and returned null.
        testCaseOpportunities2.Opportunity__c = testOpportunity1.id;
        try {
            update testCaseOpportunities2;
        } catch (Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseOpportunityDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
}