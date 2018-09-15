//-----------------------------
// @author: Sonam Raju
// @date: 8 Mar 2018
// @param: NA
// @description: Test class for Additional Opportunity Fields trigger methods 
// @return: NA
// @Last Modified By : Sruti Srivastava
// @Last Modified Description : SFDC1-8090- Added test method testpopulateAdditionalFieldsLookupInOpportunityExceptionScenario
// @Last Modified Date : 27-Apr-2018
//-----------------------------

@isTest
private class TestAdditionalOpportunityFieldsMethods {

    //-----------------------------
    // @author: Sonam Raju
    // @date: 8 Mar 2018
    // @param: NA
    // @description: Test method for Additional Opportunity Fields trigger methods populateAdditionalFieldsLookupInOpportunity on insert.This also covers the functionality available in method setOpportunityAdditionalFieldsObject in OpportunityMethods Class.
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateAdditionalFieldsLookupInOpportunity() {
        
        Account a = TestUtility.createTestAccount('Account populateAdditionalFieldsLookupInOpportunity', true);
        Contact c = TestUtility.createContact(a.Id,'testaof@aof.com',true,'Test','populateAdditionalFieldsLookupInOpportunity');
        
        Test.Starttest();
        Opportunity opp = TestUtility.createOpportunity(a.Id, 'Testing AoF Creation',true);
        
        // Checking If New business Opportunity creation creates Additional Opportunity Field record
        list <AdditionalOpportunityFields__c> testAOFResult = [Select Id from AdditionalOpportunityFields__c where OpportunityReference__c= :opp.Id];
        System.assertEquals(1, testAOFResult.size());
        
        //Check If Additional Opportunity Field Record is updated in the AdditionalOpportunityFields__c on Opportunity
        list <Opportunity> testOpptyResult = [Select Id, AdditionalOpportunityFields__c from Opportunity where Id= :opp.Id];
        System.assertEquals(testAOFResult[0].Id,testOpptyResult[0].AdditionalOpportunityFields__c);
        
        Test.Stoptest();
    }
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 27th April 2018
    // @param: NA
    // @description: Test method for covering exception scenario
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateAdditionalFieldsLookupInOpportunityExceptionScenario() {
        
        //Creating test data
        Account testAccount = TestUtility.createTestAccount('Account populateAdditionalFieldsLookupInOpportunity', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit1@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        Id standardId = Test.getStandardPricebookId();
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Opportunity opp = TestUtility.createOpportunity(testAccount.Id, 'Testing AoF Creation', true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = opp.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(opp.Id, testPBE, true);
        
        //start test 
        Test.Starttest();
        
        // Checking If New business Opportunity creation creates Additional Opportunity Field record
        System.assertEquals(1, [Select count() from AdditionalOpportunityFields__c ]);
        
        // Deleting the Contact Role to get Error on Opportuntiy update
        List<OpportunityContactRole> listOppContactRole = [select ID from OpportunityContactRole where OpportunityId = :Opp.Id];
        delete listOppContactRole;
        
        //Updating Opportunity to closed status, so it doesn't allow any modification
        opp.StageName = '6W-Closed Won';
        opp.ContractId = contract1.id;
        opp.ContractStartDate__c = System.today();
        opp.ContractEndDate__c = System.today();
        opp.ActivityCreated__c = true;
        opp.ReadyForProcessingContractExist__c = true;
        opp.CloseDate = System.today()+2;
        opp.BudgetRange__c = '25,000-50,000';
        
        try {
            update opp;
            
            list<AdditionalOpportunityFields__c> testAOFResult = new list <AdditionalOpportunityFields__c> {new AdditionalOpportunityFields__c(Name = 'Test', OpportunityReference__c = opp.Id)};
            insert testAOFResult;
        }
        catch (Exception e) {
            System.assertEquals(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), true);    
        }
            
        Test.Stoptest();
        //Check If Additional Opportunity Field Record has failed, count should be one 
        System.assertEquals(1, [Select count() from AdditionalOpportunityFields__c where OpportunityReference__c= :opp.Id]);
    }
}