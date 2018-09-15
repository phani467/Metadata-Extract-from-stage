/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 29 August 2017
* @description: Class to test CaseContractsMethods.
* @companyname: VERTIBA
*/
@isTest
private class TestCaseContractsMethods {
	/**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 29 August 2017
     * @description: This method tests the CaseContractsMethods by creating/updating/deleting Case Contracts objects.
     * @companyname: VERTIBA 
     * @Last Modified Date : 23-Nov-2017
     * @lastmodifiedBy : Vishnu 
     * @Last Modified Description : fixing the errors in bitbucket
     */ 
    @isTest
    private static void testUpdateRollupSummariesInCase() {
        //create test data
        List<Product2> prodList = new List<Product2>();
        prodList.add(TestUtility.createProduct('Test Product', false));
        prodList.add(TestUtility.createProduct('Product Test', false));
        insert prodList;
        Id standardId = Test.getStandardPricebookId();
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        Country__c country = (Country__c)TestUtility.loadCountryData().get(0);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Contract contract2 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        List<ContractLineItem__c> cliList = new List<ContractLineItem__c>();
        cliList.add(TestUtility.createContractLineItem('CLI1', contract1.Id, prodList.get(0).Id, false));
        cliList.add(TestUtility.createContractLineItem('CLI2', contract1.Id, prodList.get(1).Id, false));
        cliList.add(TestUtility.createContractLineItem('CLI3', contract2.Id, prodList.get(1).Id, false));
        insert cliList;
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;
        
        Test.startTest();
        //Case Contract is not added so values should be empty
        Case case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.Revenue__c+' case1 '+case1.ContractProductList__c); 
        System.assertEquals(null, case1.ContractProductList__c);
        System.assertEquals(null, case1.Revenue__c);
        
        //Creating case Contract, so case should be updated
        CaseContracts__c testCaseContracts1 = createCaseContracts(case1.id,contract1.id);
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.Revenue__c+' case2 '+case1.ContractProductList__c); 
        System.assert(case1.ContractProductList__c.contains('Test Product'));
        System.assert(case1.ContractProductList__c.contains('Product Test'));
        System.assertEquals(case1.Revenue__c, 2000.0);

        //Modifying Contract with different Contract
        testCaseContracts1.Contract__c = contract2.id;
        update testCaseContracts1;
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.Revenue__c+' case3 '+case1.ContractProductList__c); 
        System.assert(case1.ContractProductList__c.contains('Product Test'));
		System.assertEquals(false,case1.ContractProductList__c.contains('Test Product'));
        System.assertEquals(case1.Revenue__c, 1000.0);
        
        //Test by adding a new record to existing one.
        CaseContracts__c testCaseContracts2 = createCaseContracts(case1.id,contract1.id);
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.Revenue__c+' case4 '+case1.ContractProductList__c); 
        System.assert(case1.ContractProductList__c.contains('Product Test'));
        System.assert(case1.ContractProductList__c.contains('Test Product')); 
        System.assertEquals(case1.Revenue__c, 3000.0);
        
        //Test by deleting record.
        delete testCaseContracts2;
        case1 = getCaseFromDatabase(testCase.id);
        System.debug(case1.Revenue__c+' case5 '+case1.ContractProductList__c); 
        System.assert(case1.ContractProductList__c.contains('Product Test'));
		System.assertEquals(false,case1.ContractProductList__c.contains('Test Product'));
        System.assertEquals(case1.Revenue__c, 1000.0);
        
        Test.stopTest();
    }

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 12 September 2017
     * @description: helper method to get case object from database.
     * @companyname: VERTIBA 
     */ 
    private static Case getCaseFromDatabase(Id caseId) {
        Case testCase = [Select id, ContractProductList__c, Revenue__c from case where id =: caseId];
        return testCase;
    }

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 12 September 2017
     * @description: Helper method to insert case contract objects.
     * @companyname: VERTIBA 
     */ 
    private static CaseContracts__c createCaseContracts(id caseId, id contractId) {
        try {
            CaseContracts__c testCaseContracts = new CaseContracts__c();
            testCaseContracts.Case__c = caseId;
            testCaseContracts.Contract__c = contractId;
            insert testCaseContracts;
            return testCaseContracts;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseContractDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
            return null;
        }
    }
    
    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 25 September 2017
     * @description: This method tests the ValidateIfCaseProductAlreadyExist by creating/updating Case Contract objects.
     * @companyname: VERTIBA 
     * @lastmodifiedSprint : Sprint 9
     */ 
    @isTest
    private static void testValidateIfCaseProductAlreadyExist() {
        //Create test data
        Id standardId = Test.getStandardPricebookId();
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        Country__c country = (Country__c)TestUtility.loadCountryData().get(0);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;
        
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Contract contract2 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Test.startTest();
        //Creating case Contract, record to be inserted successfully
        CaseContracts__c testCaseContracts1 = createCaseContracts(testCase.id,contract1.id);
        System.assertNotEquals(null,testCaseContracts1.id); 
        
        //Adding second case Contract, record to be inserted successfully 
        CaseContracts__c testCaseContracts2 = createCaseContracts(testCase.id,contract2.id);
        System.assertNotEquals(null,testCaseContracts2.id); 
        
        //Add same case again, it should fail, Exception is caught and returned null.
		testCaseContracts1 = createCaseContracts(testCase.id,contract1.id);
        System.assertEquals(null,testCaseContracts1); 
        
        //Modifying Contract with different Contract
        testCaseContracts2.Contract__c = contract1.id;
        try {
            update testCaseContracts2;
        } catch (Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseContractDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
}