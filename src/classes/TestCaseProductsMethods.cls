/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 29 August 2017
* @description: Class to test CaseProductsMethods.
* @companyname: VERTIBA
*/
@isTest
private class TestCaseProductsMethods {

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 26 September 2017
     * @description: Helper method to insert case Product objects, adding product group and family as parameters
     * @companyname: VERTIBA 
     */ 
    private static CaseProducts__c createCaseProducts(id caseId, id ProductId, id productFamily, id productgroup) {

            CaseProducts__c testCaseProducts = new CaseProducts__c();
            testCaseProducts.Case__c = caseId;
            testCaseProducts.Product__c = ProductId;
            testCaseProducts.ProductFamily__c = productFamily;
            testCaseProducts.ProductGroup__c = productgroup;
            insert testCaseProducts;
            return testCaseProducts;
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
        Product2 testProd1 = TestUtility.createProduct('Test Product', true);
        Product2 testProd2 = TestUtility.createProduct('Product Test', true);
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;

        Test.startTest();
        //Creating case Product, record to be inserted successfully
        CaseProducts__c testCaseProducts1 = createCaseProducts(testCase.id,testProd1.id, null, null);
        System.assertNotEquals(null,testCaseProducts1.id); 
        
        //Adding second case Product, record to be inserted successfully 
        CaseProducts__c testCaseProducts2 = createCaseProducts(testCase.id,testProd2.id, null, null);
        System.assertNotEquals(null,testCaseProducts2.id); 
        
        //Add same case again, it should fail, Exception is caught and returned null.
        try {
            testCaseProducts1 = createCaseProducts(testCase.id,testProd1.id, null, null);
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseProductDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //Modifying Product with different Product
        testCaseProducts2.Product__c = testProd1.id;
        try {
            update testCaseProducts2;
        } catch (Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseProductDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }

    //-----------------------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 24 April 2018
    // @description: Testing the mandatory product related fields and auto population 
    // @companyname: VERTIBA 
    //-----------------------------------------   
    @isTest
    private static void testValidateAndAutoPopulateProductValues() {
        //Create test data
        List<ProductGroup__C> pgList = new List<ProductGroup__c>();
        ProductGroup__C pg1 = new ProductGroup__C(name = 'Test PG1');
        ProductGroup__C pg2 = new ProductGroup__C(name = 'Test PG2');
        pgList.add(pg1);
        pgList.add(pg2);
        insert pgList;
        Family__C pf = new Family__c(ProductGroup__C = pgList.get(0).id);
        insert pf;
        
        Product2 testProd1 = TestUtility.createProduct('Test Product', false);
        testProd1.ProductGroup__C = pgList.get(0).id;
        testProd1.Family__c = pf.id;
        insert testProd1;
        
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;

        Test.startTest();
        CaseProducts__c testCaseProducts1 = null;
        try {
            testCaseProducts1 = createCaseProducts(testCase.id,null, null, null);
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseProductMandatoryCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        //sending product group wrongly, so pg will be replaced with correct one and even the PF will be updated
        testCaseProducts1 = createCaseProducts(testCase.id,testProd1.id, null, pgList.get(1).id);
        System.assertNotEquals(null,testCaseProducts1.id); 
        testCaseProducts1 = [select id, productGroup__c, ProductFamily__c, product__C from 
                             caseProducts__C where id =: testCaseProducts1.id];
        System.assertEquals(testCaseProducts1.product__C,testProd1.id); 
        System.assertEquals(testCaseProducts1.productGroup__c,pgList.get(0).id); 
        System.assertEquals(testCaseProducts1.ProductFamily__c,pf.id); 
        
        Test.stopTest();
    }
    
    //-----------------------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 26 June 2018
    // @description: Earlier the duplicate check was done only on products. If there are more than one case product, with
    // 				Null as product then system was throwing error. Fixed it and this test class is to test it.
    // @companyname: VERTIBA 
    //-----------------------------------------   
    @isTest
    private static void testProductsCanBeEmpty() {
        //Create test data
        List<ProductGroup__C> pgList = new List<ProductGroup__c>();
        ProductGroup__C pg1 = new ProductGroup__C(name = 'Test PG1');
        ProductGroup__C pg2 = new ProductGroup__C(name = 'Test PG2');
        pgList.add(pg1);
        pgList.add(pg2);
        insert pgList;
        
        Account testAccount = TestUtility.createTestAccount('testAccount', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = 'Test subject';
        testCase.AccountId = testAccount.Id;
        testCase.contactId = testContact.Id;
        insert testCase;

        Test.startTest();
        System.assertNotEquals(null,createCaseProducts(testCase.id, null, null, pgList.get(1).id)); 
        System.assertNotEquals(null,createCaseProducts(testCase.id, null, null, pgList.get(0).id)); 
        try {
            createCaseProducts(testCase.id, null, null, pgList.get(1).id);
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CaseProductDuplicateCheck) ? true : false;
            // Assert to check correct Error is thrown
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        List<CaseProducts__c> caseProductsList = [select id from caseProducts__C where Case__c =: testCase.id];
        System.assertEquals(2, caseProductsList.size());
        Test.stopTest();
    }
}