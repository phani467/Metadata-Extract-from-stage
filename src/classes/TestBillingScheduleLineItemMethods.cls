//-----------------------------
    // @author: Mohit Modi
    // @date: 16 April 2018
    // @description: SFDC1-7472 : Test method for BillingScheduleLineItemMethods Class
    // @return: None
    //------------------------------
@isTest
private class TestBillingScheduleLineItemMethods {

    //-----------------------------
    // @author: Mohit Modi
    // @date: 16 April 2018
    // @description: SFDC1-7472 : Test method for CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation
    // @return: None
    //------------------------------
    @isTest
    static void testCreateCloneBillingScheduleLIFromCLIandPreventBSLICreation() {
    
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id trailRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        
        test.startTest();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,true);
        // Creating the CLI with Billing Period
        ContractLineItem__c  testCLI = TestUtility.createContractLineItem('TestCLI',contract1.id,testProd.id,false);
        testCLI.BillingPeriods__c = 4;
        insert testCLI;
        
        // Creating the BSLI record with IsCreatedfromQuickAction__c = true as equal to be created by Quick Action
        BillingScheduleLineItem__c testBSLI = new BillingScheduleLineItem__c (IsCreatedfromQuickAction__c = true,AUMBPS__c = 'test',AUMValue__c = 'test',Quantity__c = 4,ContractLineItem__c = testCLI.id);
        insert testBSLI ;
        
        // Checking that the remaing BSLI record has to be created equal to CLI's Billing Period
        integer BSLIcreated = [select count() from BillingScheduleLineItem__c where ContractLineItem__c = : testCLI.id ];
        System.assertEquals(BSLIcreated ,testCLI.BillingPeriods__c);
        
        // Reducing the Billing Period on CLI
        testCLI.BillingPeriods__c = 1;
        update testCLI;
        
        try {
            // Trying to insert new BSLI using Quick action after reducing the CLI Billing Period, Error Should be thrown.
            BillingScheduleLineItem__c testBSLI1 = new BillingScheduleLineItem__c (IsCreatedfromQuickAction__c = true,AUMBPS__c = 'test',AUMValue__c = 'test',Quantity__c = 4,ContractLineItem__c = testCLI.id);
            insert testBSLI1 ;
        } catch (exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.BSLIErrorOnQuickActionOnCLI) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
}